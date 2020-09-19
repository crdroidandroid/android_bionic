/*
Copyright (C) 2019 The Android Open Source Project
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions
are met:
 * Redistributions of source code must retain the above copyright
   notice, this list of conditions and the following disclaimer.
 * Redistributions in binary form must reproduce the above copyright
   notice, this list of conditions and the following disclaimer in
   the documentation and/or other materials provided with the
   distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
"AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS
OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED
AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT
OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
SUCH DAMAGE.
*/

#include <private/bionic_asm.h>
# -- Begin  sin
ENTRY(sinhf_avx2)
# parameter 1: %xmm0
..B1.1:
..L1:

        pushq     %rbp
	.cfi_def_cfa_offset 16
        movq      %rsp, %rbp
	.cfi_def_cfa 6, 16
	.cfi_offset 6, -16
        andq      $-64, %rsp
        subq      $256, %rsp
        lea       1484+__svml_ssinh_ha_data_internal(%rip), %rcx
        vmovups   %xmm10, 160(%rsp)
        vmovaps   %xmm0, %xmm10
        vandps    1152+__svml_ssinh_ha_data_internal(%rip), %xmm10, %xmm7
        vmovups   1280+__svml_ssinh_ha_data_internal(%rip), %xmm3
        vxorps    %xmm10, %xmm7, %xmm0
        vmovups   960+__svml_ssinh_ha_data_internal(%rip), %xmm1
        vfmadd213ps %xmm3, %xmm0, %xmm1
        vpcmpgtd  1408+__svml_ssinh_ha_data_internal(%rip), %xmm0, %xmm6
        vmovups   1344+__svml_ssinh_ha_data_internal(%rip), %xmm5
        vmovmskps %xmm6, %r8d
        vmovups   %xmm12, 112(%rsp)
        vxorps    %xmm3, %xmm1, %xmm6
        vsubps    %xmm3, %xmm1, %xmm3
        vpsubd    %xmm6, %xmm5, %xmm2
        vpsrld    $28, %xmm2, %xmm4
        vpslld    $4, %xmm4, %xmm12
        vpor      %xmm6, %xmm12, %xmm2
        vmovups   1024+__svml_ssinh_ha_data_internal(%rip), %xmm1
        vpand     %xmm5, %xmm2, %xmm5
        vfnmadd213ps %xmm0, %xmm3, %xmm1
        vpslld    $4, %xmm5, %xmm4
        vmovups   %xmm11, 144(%rsp)
        vmovd     %xmm4, %edx
        vfnmadd231ps 1088+__svml_ssinh_ha_data_internal(%rip), %xmm3, %xmm1
        vmovd     -4(%rdx,%rcx), %xmm11
        vpextrd   $2, %xmm4, %r9d
        vpextrd   $1, %xmm4, %eax
        vpextrd   $3, %xmm4, %r10d
        vmovd     -4(%r9,%rcx), %xmm3
        vpinsrd   $1, -4(%rax,%rcx), %xmm11, %xmm12
        vpinsrd   $1, -4(%r10,%rcx), %xmm3, %xmm2
        vmovd     (%rdx,%rcx), %xmm4
        vmovd     (%r9,%rcx), %xmm3
        vunpcklpd %xmm2, %xmm12, %xmm11
        vpinsrd   $1, (%rax,%rcx), %xmm4, %xmm12
        vpinsrd   $1, (%r10,%rcx), %xmm3, %xmm2
        vmovups   5568+__svml_ssinh_ha_data_internal(%rip), %xmm4
        vpunpcklqdq %xmm2, %xmm12, %xmm3
        vpcmpgtd  %xmm5, %xmm4, %xmm2
        vfmadd213ps %xmm11, %xmm1, %xmm3
        vaddps    %xmm11, %xmm11, %xmm4
        vmovd     -8(%rdx,%rcx), %xmm11
        vpsubd    %xmm5, %xmm6, %xmm5
        vpinsrd   $1, -8(%rax,%rcx), %xmm11, %xmm12
        vpslld    $19, %xmm5, %xmm6
        vmovd     -8(%r9,%rcx), %xmm11
        vpinsrd   $1, -8(%r10,%rcx), %xmm11, %xmm11
        vpunpcklqdq %xmm11, %xmm12, %xmm11
        vandps    %xmm2, %xmm0, %xmm12
        vmovd     -12(%rdx,%rcx), %xmm0
        vandnps   %xmm4, %xmm2, %xmm2
        vfmadd213ps %xmm11, %xmm1, %xmm3
        vpinsrd   $1, -12(%rax,%rcx), %xmm0, %xmm11
        vmovd     -12(%r9,%rcx), %xmm0
        vpinsrd   $1, -12(%r10,%rcx), %xmm0, %xmm0
        vpunpcklqdq %xmm0, %xmm11, %xmm11
        vfmadd213ps %xmm11, %xmm1, %xmm3
        vorps     %xmm12, %xmm2, %xmm1
        vaddps    %xmm3, %xmm1, %xmm0
        vpaddd    %xmm6, %xmm0, %xmm0
        vorps     %xmm0, %xmm7, %xmm0
        testl     %r8d, %r8d
        jne       ..B1.3
..B1.2:
        vmovups   160(%rsp), %xmm10
	.cfi_restore 27
        vmovups   144(%rsp), %xmm11
	.cfi_restore 28
        vmovups   112(%rsp), %xmm12
	.cfi_restore 29
        movq      %rbp, %rsp
        popq      %rbp
	.cfi_def_cfa 7, 8
	.cfi_restore 6
        ret
	.cfi_def_cfa 6, 16
	.cfi_offset 6, -16
..B1.3:
        vmovups   %xmm10, 128(%rsp)
        vmovups   %xmm0, 192(%rsp)
..B1.6:
        xorl      %eax, %eax
        vmovups   %xmm8, 64(%rsp)
        vmovups   %xmm9, 48(%rsp)
        vmovups   %xmm13, 32(%rsp)
        vmovups   %xmm14, 16(%rsp)
        vmovups   %xmm15, (%rsp)
        movq      %rsi, 88(%rsp)
        movq      %rdi, 80(%rsp)
        movq      %r12, 104(%rsp)
        movl      %eax, %r12d
        movq      %r13, 96(%rsp)
        movl      %r8d, %r13d
..B1.7:
        btl       %r12d, %r13d
        jc        ..B1.10
..B1.8:
        incl      %r12d
        cmpl      $4, %r12d
        jl        ..B1.7
..B1.9:
        vmovups   64(%rsp), %xmm8
	.cfi_restore 25
        vmovups   48(%rsp), %xmm9
	.cfi_restore 26
        vmovups   32(%rsp), %xmm13
	.cfi_restore 30
        vmovups   16(%rsp), %xmm14
	.cfi_restore 31
        vmovups   (%rsp), %xmm15
	.cfi_restore 32
        movq      88(%rsp), %rsi
	.cfi_restore 4
        movq      80(%rsp), %rdi
	.cfi_restore 5
        movq      104(%rsp), %r12
	.cfi_restore 12
        movq      96(%rsp), %r13
	.cfi_restore 13
        vmovups   192(%rsp), %xmm0
        jmp       ..B1.2
..B1.10:
        lea       128(%rsp,%r12,4), %rdi
        lea       192(%rsp,%r12,4), %rsi
        call      __svml_ssinh_ha_cout_rare_internal
        jmp       ..B1.8
END(sinhf_avx2)
        .data
	.hidden __svml_ssinh_ha_data_internal
	.hidden __svml_ssinh_ha_cout_rare_internal
	.section .note.GNU-stack, ""
# End
