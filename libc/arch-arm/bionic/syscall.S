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

#include <private/bionic_asm.h>

ENTRY(syscall)
    /* Apply the sandbox path policy to raw faccessat() calls only. */
    ldr     ip, =__NR_faccessat
    cmp     r0, ip
    bne     L(raw_syscall)

    stmfd   sp!, {r0, r1, r2, r3, r4, lr}
    .cfi_def_cfa_offset 24
    .cfi_rel_offset r0, 0
    .cfi_rel_offset r1, 4
    .cfi_rel_offset r2, 8
    .cfi_rel_offset r3, 12
    .cfi_rel_offset r4, 16
    .cfi_rel_offset lr, 20
    mov     r0, r1
    mov     r1, r2
    bl      custom_rom_hide_filter_faccessat_syscall
    mov     ip, r0
    ldmfd   sp!, {r0, r1, r2, r3, r4, lr}
    .cfi_def_cfa_offset 0
    .cfi_restore r0
    .cfi_restore r1
    .cfi_restore r2
    .cfi_restore r3
    .cfi_restore r4
    .cfi_restore lr
    cmp     ip, #0
    bne     L(filtered)

L(raw_syscall):
    mov     ip, sp
    stmfd   sp!, {r4, r5, r6, r7}
    .cfi_def_cfa_offset 16
    .cfi_rel_offset r4, 0
    .cfi_rel_offset r5, 4
    .cfi_rel_offset r6, 8
    .cfi_rel_offset r7, 12
    mov     r7, r0
    mov     r0, r1
    mov     r1, r2
    mov     r2, r3
    ldmfd   ip, {r3, r4, r5, r6}
    swi     #0
    ldmfd   sp!, {r4, r5, r6, r7}
    .cfi_def_cfa_offset 0
    cmn     r0, #(MAX_ERRNO + 1)
    bxls    lr
    neg     r0, r0
    b       __set_errno_internal

L(filtered):
    mov     r0, ip
    b       __set_errno_internal
END(syscall)
