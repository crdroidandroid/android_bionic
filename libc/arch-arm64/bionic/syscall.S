/*
 * Copyright (C) 2013 The Android Open Source Project
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

#include <private/bionic_asm.h>

ENTRY(syscall)
    /*
     * Some callers use the generic syscall() entry point to bypass the
     * faccessat() wrapper. Keep the sandbox path policy consistent for that
     * exact syscall while leaving every other raw syscall untouched.
     */
    cmp     x0, #__NR_faccessat
    b.ne    L(raw_syscall)

    stp     x0, x1, [sp, #-64]!
    .cfi_def_cfa_offset 64
    .cfi_rel_offset x0, 0
    .cfi_rel_offset x1, 8
    stp     x2, x3, [sp, #16]
    .cfi_rel_offset x2, 16
    .cfi_rel_offset x3, 24
    stp     x4, x5, [sp, #32]
    .cfi_rel_offset x4, 32
    .cfi_rel_offset x5, 40
    stp     x6, x30, [sp, #48]
    .cfi_rel_offset x6, 48
    .cfi_rel_offset x30, 56

    mov     w0, w1
    mov     x1, x2
    bl      custom_rom_hide_filter_faccessat_syscall
    mov     w8, w0

    ldp     x2, x3, [sp, #16]
    ldp     x4, x5, [sp, #32]
    ldp     x6, x30, [sp, #48]
    ldp     x0, x1, [sp], #64
    .cfi_def_cfa_offset 0
    .cfi_restore x0
    .cfi_restore x1
    .cfi_restore x2
    .cfi_restore x3
    .cfi_restore x4
    .cfi_restore x5
    .cfi_restore x6
    .cfi_restore x30

    cbnz    w8, L(filtered)

L(raw_syscall):
    /* Move syscall No. from x0 to x8 */
    mov     x8, x0
    /* Move syscall parameters from x1 thru x6 to x0 thru x5 */
    mov     x0, x1
    mov     x1, x2
    mov     x2, x3
    mov     x3, x4
    mov     x4, x5
    mov     x5, x6
    svc     #0

    /* check if syscall returned successfully */
    cmn     x0, #(MAX_ERRNO + 1)
    cneg    x0, x0, hi
    b.hi    __set_errno_internal

    ret

L(filtered):
    mov     w0, w8
    b       __set_errno_internal
END(syscall)

NOTE_GNU_PROPERTY()
