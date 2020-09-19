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

typedef double ceil_func(double __x);
DEFINE_IFUNC_FOR(ceil) {
    __builtin_cpu_init();
    if (__builtin_cpu_supports("avx2")) RETURN_FUNC(ceil_func, ceil_avx2);
    RETURN_FUNC(ceil_func, ceil_generic);
}

typedef float ceilf_func(float __x);
DEFINE_IFUNC_FOR(ceilf) {
    __builtin_cpu_init();
    if (__builtin_cpu_supports("avx2")) RETURN_FUNC(ceilf_func, ceilf_avx2);
    RETURN_FUNC(ceilf_func, ceilf_generic);
}

typedef double floor_func(double __x);
DEFINE_IFUNC_FOR(floor) {
    __builtin_cpu_init();
    if (__builtin_cpu_supports("avx2")) RETURN_FUNC(floor_func, floor_avx2);
    RETURN_FUNC(floor_func, floor_generic);
}

typedef float floorf_func(float __x);
DEFINE_IFUNC_FOR(floorf) {
    __builtin_cpu_init();
    if (__builtin_cpu_supports("avx2")) RETURN_FUNC(floorf_func, floorf_avx2);
    RETURN_FUNC(floorf_func, floorf_generic);
}

typedef double rint_func(double __x);
DEFINE_IFUNC_FOR(rint) {
    __builtin_cpu_init();
    if (__builtin_cpu_supports("avx2")) RETURN_FUNC(rint_func, rint_avx2);
    RETURN_FUNC(rint_func, rint_generic);
}

typedef float rintf_func(float __x);
DEFINE_IFUNC_FOR(rintf) {
    __builtin_cpu_init();
    if (__builtin_cpu_supports("avx2")) RETURN_FUNC(rintf_func, rintf_avx2);
    RETURN_FUNC(rintf_func, rintf_generic);
}

typedef double hypot_func(double __x, double __y);
DEFINE_IFUNC_FOR(hypot) {
    __builtin_cpu_init();
    if (__builtin_cpu_supports("avx2")) RETURN_FUNC(hypot_func, hypot_avx2);
    RETURN_FUNC(hypot_func, hypot_generic);
}

typedef double log10_func(double __x);
DEFINE_IFUNC_FOR(log10) {
    __builtin_cpu_init();
    if (__builtin_cpu_supports("avx2")) RETURN_FUNC(log10_func, log10_avx2);
    RETURN_FUNC(log10_func, log10_generic);
}

typedef float log10f_func(float __x);
DEFINE_IFUNC_FOR(log10f) {
    __builtin_cpu_init();
    if (__builtin_cpu_supports("avx2")) RETURN_FUNC(log10f_func, log10f_avx2);
    RETURN_FUNC(log10f_func, log10f_generic);
}

typedef double log1p_func(double __x);
DEFINE_IFUNC_FOR(log1p) {
    __builtin_cpu_init();
    if (__builtin_cpu_supports("avx2")) RETURN_FUNC(log1p_func, log1p_avx2);
    RETURN_FUNC(log1p_func, log1p_generic);
}

typedef float log1pf_func(float __x);
DEFINE_IFUNC_FOR(log1pf) {
    __builtin_cpu_init();
    if (__builtin_cpu_supports("avx2")) RETURN_FUNC(log1pf_func, log1pf_avx2);
    RETURN_FUNC(log1pf_func, log1pf_generic);
}

typedef double cbrt_func(double __x);
DEFINE_IFUNC_FOR(cbrt) {
    __builtin_cpu_init();
    if (__builtin_cpu_supports("avx2")) RETURN_FUNC(cbrt_func, cbrt_avx2);
    RETURN_FUNC(cbrt_func, cbrt_generic);
}

typedef float cbrtf_func(float __x);
DEFINE_IFUNC_FOR(cbrtf) {
    __builtin_cpu_init();
    if (__builtin_cpu_supports("avx2")) RETURN_FUNC(cbrtf_func, cbrtf_avx2);
    RETURN_FUNC(cbrtf_func, cbrtf_generic);
}

typedef double cos_func(double __x);
DEFINE_IFUNC_FOR(cos) {
    __builtin_cpu_init();
    if (__builtin_cpu_supports("avx2")) RETURN_FUNC(cos_func, cos_avx2);
    RETURN_FUNC(cos_func, cos_generic);
}

typedef double sin_func(double __x);
DEFINE_IFUNC_FOR(sin) {
    __builtin_cpu_init();
    if (__builtin_cpu_supports("avx2")) RETURN_FUNC(sin_func, sin_avx2);
    RETURN_FUNC(sin_func, sin_generic);
}

typedef double sinh_func(double __x);
DEFINE_IFUNC_FOR(sinh) {
    __builtin_cpu_init();
    if (__builtin_cpu_supports("avx2")) RETURN_FUNC(sinh_func, sinh_avx2);
    RETURN_FUNC(sinh_func, sinh_generic);
}

typedef float sinhf_func(float __x);
DEFINE_IFUNC_FOR(sinhf) {
    __builtin_cpu_init();
    if (__builtin_cpu_supports("avx2")) RETURN_FUNC(sinhf_func, sinhf_avx2);
    RETURN_FUNC(sinhf_func, sinhf_generic);
}

}  // extern "C"
