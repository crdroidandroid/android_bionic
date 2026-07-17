/*
 * Copyright (C) 2017 The Android Open Source Project
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 *  * Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 *  * Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in
 *    the documentation and/or other materials provided with the
 *    distribution.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
 * FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
 * COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
 * BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS
 * OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED
 * AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
 * OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT
 * OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
 * SUCH DAMAGE.
 */

#include <sys/system_properties.h>

#include <async_safe/CHECK.h>
#include <system_properties/prop_area.h>
#include <system_properties/system_properties.h>

#include <string.h>

#include "private/bionic_defs.h"
#include "custom_rom_hide.h"

static SystemProperties system_properties;
static_assert(__is_trivially_constructible(SystemProperties),
              "System Properties must be trivially constructable");

// This is public because it was exposed in the NDK. As of 2017-01, ~60 apps reference this symbol.
// It is set to nullptr and never modified.
__BIONIC_WEAK_VARIABLE_FOR_NATIVE_BRIDGE
prop_area* __system_property_area__ = nullptr;

__BIONIC_WEAK_FOR_NATIVE_BRIDGE
int __system_properties_init() {
  return system_properties.Init(PROP_DIRNAME) ? 0 : -1;
}

__BIONIC_WEAK_FOR_NATIVE_BRIDGE
int __system_property_set_filename(const char*) {
  return -1;
}

__BIONIC_WEAK_FOR_NATIVE_BRIDGE
int __system_property_area_init() {
  bool fsetxattr_fail = false;
  return system_properties.AreaInit(PROP_DIRNAME, &fsetxattr_fail) && !fsetxattr_fail ? 0 : -1;
}

__BIONIC_WEAK_FOR_NATIVE_BRIDGE
uint32_t __system_property_area_serial() {
  return system_properties.AreaSerial();
}

__BIONIC_WEAK_FOR_NATIVE_BRIDGE
const prop_info* __system_property_find(const char* name) {
  if (custom_rom_hide_should_hide_prop(name)) {
    return nullptr;
  }
  return system_properties.Find(name);
}

__BIONIC_WEAK_FOR_NATIVE_BRIDGE
int __system_property_read(const prop_info* pi, char* name, char* value) {
  int len = system_properties.Read(pi, name, value);
  if (name && custom_rom_hide_should_spoof_prop(name, value)) {
    return strlen(value);
  }
  return len;
}

struct ReadCallbackOverrideCtx {
    void (*original_callback)(void* cookie, const char* name, const char* value, uint32_t serial);
    void* original_cookie;
};

static void read_callback_intercept(void* cookie, const char* name, const char* value,
                                    uint32_t serial) {
    auto* ctx = static_cast<ReadCallbackOverrideCtx*>(cookie);

    if (!custom_rom_hide_is_app_process()) {
        ctx->original_callback(ctx->original_cookie, name, value, serial);
        return;
    }

    bool is_ro = (strncmp(name, "ro.", 3) == 0);

    if (custom_rom_hide_should_hide_prop(name)) {
        uint32_t fake_serial = is_ro ? 0 : (serial & 0xffffff);
        ctx->original_callback(ctx->original_cookie, name, "", fake_serial);
        return;
    }

    const char* override_val = custom_rom_hide_get_prop_override(name);
    if (override_val) {
        uint32_t len = strlen(override_val);
        uint32_t fake_serial = serial;
        if (is_ro) {
            fake_serial = (len < PROP_VALUE_MAX) ? (len << 24) : ((50 << 24) | (1 << 16));
        } else {
            fake_serial = (serial & 0xffffff) | (len << 24);
        }
        ctx->original_callback(ctx->original_cookie, name, override_val, fake_serial);
        return;
    }

    uint32_t final_serial = serial;
    if (is_ro) {
        uint32_t len = strlen(value);
        final_serial = (len < PROP_VALUE_MAX) ? (len << 24) : ((50 << 24) | (1 << 16));
    }

    ctx->original_callback(ctx->original_cookie, name, value, final_serial);
}

__BIONIC_WEAK_FOR_NATIVE_BRIDGE
void __system_property_read_callback(const prop_info* pi,
                                     void (*callback)(void* cookie, const char* name,
                                                      const char* value, uint32_t serial),
                                     void* cookie) {
  ReadCallbackOverrideCtx ctx{callback, cookie};
  return system_properties.ReadCallback(pi, read_callback_intercept, &ctx);
}

__BIONIC_WEAK_FOR_NATIVE_BRIDGE
int __system_property_get(const char* name, char* value) {
  int len = system_properties.Get(name, value);
  if (custom_rom_hide_should_spoof_prop(name, value)) {
    return strlen(value);
  }
  return len;
}

__BIONIC_WEAK_FOR_NATIVE_BRIDGE
int __system_property_update(prop_info* pi, const char* value, unsigned int len) {
  return system_properties.Update(pi, value, len);
}

__BIONIC_WEAK_FOR_NATIVE_BRIDGE
int __system_property_add(const char* name, unsigned int namelen, const char* value,
                          unsigned int valuelen) {
  return system_properties.Add(name, namelen, value, valuelen);
}

__BIONIC_WEAK_FOR_NATIVE_BRIDGE
uint32_t __system_property_serial(const prop_info* pi) {
  // N.B. a previous version of this function was much heavier-weight
  // and enforced acquire semantics, so give our load here acquire
  // semantics just in case somebody depends on
  // __system_property_serial enforcing memory order, e.g., in case
  // someone spins on the result of this function changing before
  // loading some value.
  if (!pi) return 0;
  uint32_t real_serial = atomic_load_explicit(&pi->serial, memory_order_acquire);

  if (!custom_rom_hide_is_app_process()) return real_serial;

  const char* name = pi->name;
  bool is_ro = (strncmp(name, "ro.", 3) == 0);

  if (custom_rom_hide_should_hide_prop(name)) {
      return is_ro ? 0 : (real_serial & 0xffffff);
  }

  const char* override_val = custom_rom_hide_get_prop_override(name);
  if (override_val) {
      uint32_t len = strlen(override_val);
      if (is_ro) {
          return (len < PROP_VALUE_MAX) ? (len << 24) : ((50 << 24) | (1 << 16));
      } else {
          return (real_serial & 0xffffff) | (len << 24);
      }
  }

  if (is_ro) {
      if ((real_serial & (1 << 16)) != 0) {
          return (50 << 24) | (1 << 16);
      } else {
          uint32_t len = real_serial >> 24;
          return len << 24;
      }
  }

  return real_serial;
}

__BIONIC_WEAK_FOR_NATIVE_BRIDGE
uint32_t __system_property_wait_any(uint32_t old_serial) {
  return system_properties.WaitAny(old_serial);
}

__BIONIC_WEAK_FOR_NATIVE_BRIDGE
bool __system_property_wait(const prop_info* pi, uint32_t old_serial, uint32_t* new_serial_ptr,
                            const timespec* relative_timeout) {
  return system_properties.Wait(pi, old_serial, new_serial_ptr, relative_timeout);
}

__BIONIC_WEAK_FOR_NATIVE_BRIDGE
const prop_info* __system_property_find_nth(unsigned n) {
  return system_properties.FindNth(n);
}

struct ForeachOverrideCtx {
    void (*original_callback)(const prop_info* pi, void* cookie);
    void* original_cookie;
};

struct ForeachReadCtx {
    const prop_info* pi;
    ForeachOverrideCtx* foreach_ctx;
};

static void foreach_read_callback(void* cookie, const char* name, const char*, uint32_t) {
    auto* ctx = static_cast<ForeachReadCtx*>(cookie);
    if (custom_rom_hide_should_hide_prop(name)) {
        return;
    }
    ctx->foreach_ctx->original_callback(ctx->pi, ctx->foreach_ctx->original_cookie);
}

static void foreach_callback_intercept(const prop_info* pi, void* cookie) {
    auto* ctx = static_cast<ForeachOverrideCtx*>(cookie);
    ForeachReadCtx read_ctx{pi, ctx};
    system_properties.ReadCallback(pi, foreach_read_callback, &read_ctx);
}

__BIONIC_WEAK_FOR_NATIVE_BRIDGE
int __system_property_foreach(void (*propfn)(const prop_info* pi, void* cookie), void* cookie) {
    if (!propfn) return -1;
    ForeachOverrideCtx ctx{propfn, cookie};
    return system_properties.Foreach(foreach_callback_intercept, &ctx);
}

__BIONIC_WEAK_FOR_NATIVE_BRIDGE
int __system_properties_zygote_reload(void) {
  CHECK(getpid() == gettid());
  return system_properties.Reload(false) ? 0 : -1;
}
