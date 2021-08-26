/*
 * Copyright (C) 2008 The Android Open Source Project
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

#include <stddef.h>

#include <private/bionic_ifuncs.h>

extern "C" {

typedef int memcmp_func(const void* __lhs, const void* __rhs, size_t __n);
DEFINE_IFUNC_FOR(memcmp) {
  RETURN_FUNC(memcmp_func, memcmp_generic);
}

typedef void* memmove_func(void* __dst, const void* __src, size_t __n);
DEFINE_IFUNC_FOR(memmove) {
  RETURN_FUNC(memmove_func, memmove_generic);
}

typedef void* memcpy_func(void* __dst, const void* __src, size_t __n);
DEFINE_IFUNC_FOR(memcpy) {
  __builtin_cpu_init();
  if (__builtin_cpu_supports("sse2")) RETURN_FUNC(memcpy_func, memcpy_sse2);
  if (__builtin_cpu_supports("avx2")) RETURN_FUNC(memcpy_func, memcpy_avx2);
  RETURN_FUNC(memcpy_func, memmove_generic);
}

typedef int wmemset_func(const wchar_t* __lhs, const wchar_t* __rhs, size_t __n);
DEFINE_IFUNC_FOR(wmemset) {
  __builtin_cpu_init();
  if (__builtin_cpu_supports("avx2")) RETURN_FUNC(wmemset_func, wmemset_avx2);
  RETURN_FUNC(wmemset_func, wmemset_freebsd);
}

}  // extern "C"
