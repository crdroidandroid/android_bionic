/*
 * Copyright (C) 2019 The Android Open Source Project
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

#include <private/bionic_ifuncs.h>
#include <stddef.h>

// Accessors for the fields in MIDR_EL1.
// https://developer.arm.com/documentation/ddi0601/latest/AArch64-Registers/MIDR-EL1--Main-ID-Register
// https://www.kernel.org/doc/html/latest/arch/arm64/cpu-feature-registers.html#list-of-registers-with-visible-features
// We don't bother with "architecture" here because it's only meaningful for arm32.
inline int implementer(uint64_t midr_el1) { return (midr_el1 >> 24) & 0xff; }
inline int variant(uint64_t midr_el1) { return (midr_el1 >> 20) & 0xf; }
inline int part(uint64_t midr_el1) { return (midr_el1 >> 4) & 0xfff; }
inline int revision(uint64_t midr_el1) { return (midr_el1 >> 0) & 0xf; }

static inline bool __bionic_is_oryon(unsigned long hwcap) {
  if (!(hwcap & HWCAP_CPUID)) return false;

  unsigned long midr;
  __asm__ __volatile__("mrs %0, MIDR_EL1" : "=r"(midr));

  // Check for implementor Qualcomm's parts 0..15 (Oryon).
  // Variant (big vs middle vs little) and revision are ignored.
  return implementer(midr) == 'Q' && part(midr) <= 15;
}

extern "C" {

DEFINE_IFUNC_FOR(memchr) {
  if (arg->_hwcap2 & HWCAP2_MTE) {
    RETURN_FUNC(memchr_func_t, __memchr_aarch64_mte);
  } else {
    RETURN_FUNC(memchr_func_t, __memchr_aarch64);
  }
}
MEMCHR_SHIM()

DEFINE_IFUNC_FOR(memcmp) {
  // TODO: enable the SVE version.
  RETURN_FUNC(memcmp_func_t, __memcmp_aarch64);
}
MEMCMP_SHIM()

DEFINE_IFUNC_FOR(memcpy) {
  if (arg->_hwcap2 & HWCAP2_MOPS) {
    RETURN_FUNC(memcpy_func_t, __memmove_aarch64_mops);
  } else if (__bionic_is_oryon(arg->_hwcap)) {
    RETURN_FUNC(memcpy_func_t, __memcpy_aarch64_nt);
  } else if (arg->_hwcap & HWCAP_ASIMD) {
    RETURN_FUNC(memcpy_func_t, __memcpy_aarch64_simd);
  } else {
    RETURN_FUNC(memcpy_func_t, __memcpy_aarch64);
  }
}
MEMCPY_SHIM()

DEFINE_IFUNC_FOR(memmove) {
  if (arg->_hwcap2 & HWCAP2_MOPS) {
    RETURN_FUNC(memmove_func_t, __memmove_aarch64_mops);
  } else if (__bionic_is_oryon(arg->_hwcap)) {
    RETURN_FUNC(memmove_func_t, __memmove_aarch64_nt);
  } else if (arg->_hwcap & HWCAP_ASIMD) {
    RETURN_FUNC(memmove_func_t, __memmove_aarch64_simd);
  } else {
    RETURN_FUNC(memmove_func_t, __memmove_aarch64);
  }
}
MEMMOVE_SHIM()

DEFINE_IFUNC_FOR(memrchr) {
  RETURN_FUNC(memrchr_func_t, __memrchr_aarch64);
}
MEMRCHR_SHIM()

DEFINE_IFUNC_FOR(memset) {
  if (arg->_hwcap2 & HWCAP2_MOPS) {
    RETURN_FUNC(memset_func_t, __memset_aarch64_mops);
  } else if (__bionic_is_oryon(arg->_hwcap)) {
      if (HWCAP_ASIMD) {
        RETURN_FUNC(memset_func_t, __memset_aarch64_nt_simd);
      } else {
        RETURN_FUNC(memset_func_t, __memset_aarch64_nt);
      }
  } else {
    RETURN_FUNC(memset_func_t, __memset_aarch64);
  }
}
MEMSET_SHIM()

DEFINE_IFUNC_FOR(stpcpy) {
  // TODO: enable the SVE version.
  RETURN_FUNC(stpcpy_func_t, __stpcpy_aarch64);
}
STPCPY_SHIM()

DEFINE_IFUNC_FOR(strchr) {
  if (arg->_hwcap2 & HWCAP2_MTE) {
    RETURN_FUNC(strchr_func_t, __strchr_aarch64_mte);
  } else {
    RETURN_FUNC(strchr_func_t, __strchr_aarch64);
  }
}
STRCHR_SHIM()

DEFINE_IFUNC_FOR(strchrnul) {
  if (arg->_hwcap2 & HWCAP2_MTE) {
    RETURN_FUNC(strchrnul_func_t, __strchrnul_aarch64_mte);
  } else {
    RETURN_FUNC(strchrnul_func_t, __strchrnul_aarch64);
  }
}
STRCHRNUL_SHIM()

DEFINE_IFUNC_FOR(strcmp) {
  // TODO: enable the SVE version.
  RETURN_FUNC(strcmp_func_t, __strcmp_aarch64);
}
STRCMP_SHIM()

DEFINE_IFUNC_FOR(strcpy) {
  // TODO: enable the SVE version.
  RETURN_FUNC(strcpy_func_t, __strcpy_aarch64);
}
STRCPY_SHIM()

DEFINE_IFUNC_FOR(strlen) {
  if (arg->_hwcap2 & HWCAP2_MTE) {
    RETURN_FUNC(strlen_func_t, __strlen_aarch64_mte);
  } else {
    RETURN_FUNC(strlen_func_t, __strlen_aarch64);
  }
}
STRLEN_SHIM()

DEFINE_IFUNC_FOR(strncmp) {
  // TODO: enable the SVE version.
  RETURN_FUNC(strncmp_func_t, __strncmp_aarch64);
}
STRNCMP_SHIM()

DEFINE_IFUNC_FOR(strnlen) {
  // TODO: enable the SVE version.
  RETURN_FUNC(strnlen_func_t, __strnlen_aarch64);
}
STRNLEN_SHIM()

DEFINE_IFUNC_FOR(strrchr) {
  if (arg->_hwcap2 & HWCAP2_MTE) {
    RETURN_FUNC(strrchr_func_t, __strrchr_aarch64_mte);
  } else {
    RETURN_FUNC(strrchr_func_t, __strrchr_aarch64);
  }
}
STRRCHR_SHIM()

}  // extern "C"
