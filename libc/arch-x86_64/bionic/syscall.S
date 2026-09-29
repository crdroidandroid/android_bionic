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

/*
 * Generic syscall call.
 * Upon entry:
 *   %rax: system call number
 *   %rdi: arg0 to system call
 *   %rsi: arg1
 *   %rdx: arg2
 *   %rcx: arg3 - syscall expects it at %r10
 *   %r8: arg4
 *   %r9: arg5
 */

#include <private/bionic_asm.h>

ENTRY(syscall)
    # Apply the sandbox path policy to raw faccessat() calls only.
    cmpl    $__NR_faccessat, %edi
    jne     L(raw_syscall)

    subq    $56, %rsp
    .cfi_adjust_cfa_offset 56
    movq    %rdi, 0(%rsp)
    movq    %rsi, 8(%rsp)
    movq    %rdx, 16(%rsp)
    movq    %rcx, 24(%rsp)
    movq    %r8, 32(%rsp)
    movq    %r9, 40(%rsp)
    movl    %esi, %edi
    movq    %rdx, %rsi
    call    custom_rom_hide_filter_faccessat_syscall
    movl    %eax, %r11d
    movq    0(%rsp), %rdi
    movq    8(%rsp), %rsi
    movq    16(%rsp), %rdx
    movq    24(%rsp), %rcx
    movq    32(%rsp), %r8
    movq    40(%rsp), %r9
    addq    $56, %rsp
    .cfi_adjust_cfa_offset -56
    testl   %r11d, %r11d
    jne     L(filtered)

L(raw_syscall):
    # All arguments are passed via registers.
    # (Not all will be valid, depending on the syscall.)
    mov     %edi, %eax
    mov     %rsi, %rdi
    mov     %rdx, %rsi
    mov     %rcx, %rdx
    mov     %r8,  %r10
    mov     %r9,  %r8
    mov     8(%rsp), %r9

    # Make the system call.
    syscall
    cmpq    $-MAX_ERRNO, %rax
    jb      1f
    negl    %eax
    movl    %eax, %edi
    call    __set_errno_internal
1:
    ret

L(filtered):
    movl    %r11d, %edi
    jmp     __set_errno_internal
END(syscall)
