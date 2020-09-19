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
# -- Begin  
ENTRY(log1p_avx2)
# parameter 1: %xmm0
..B1.1:
..L1:

        pushq     %rbp
	.cfi_def_cfa_offset 16
        movq      %rsp, %rbp
	.cfi_def_cfa 6, 16
	.cfi_offset 6, -16
        andq      $-64, %rsp
        pushq     %rsi
        pushq     %rdi
        subq      $176, %rsp
        lea       -8454136+__svml_dlog1p_ha_data_internal(%rip), %rdx
        vmovups   %xmm11, 96(%rsp)
        vmovapd   %xmm0, %xmm11
        vmovsd    13056+__svml_dlog1p_ha_data_internal(%rip), %xmm2
        vandpd    %xmm2, %xmm11, %xmm1
        vmovups   %xmm10, 32(%rsp)
        vmovsd    12992+__svml_dlog1p_ha_data_internal(%rip), %xmm10
        vmovsd    13184+__svml_dlog1p_ha_data_internal(%rip), %xmm6
        vaddsd    %xmm11, %xmm10, %xmm5
        vcmpltsd  13120+__svml_dlog1p_ha_data_internal(%rip), %xmm1, %xmm7
        vmovups   %xmm12, 144(%rsp)
        vorpd     %xmm7, %xmm6, %xmm12
        vmovups   %xmm8, 80(%rsp)
        vandpd    %xmm12, %xmm5, %xmm8
        vmovsd    12672+__svml_dlog1p_ha_data_internal(%rip), %xmm1
        vmovsd    12736+__svml_dlog1p_ha_data_internal(%rip), %xmm6
        vandpd    %xmm1, %xmm8, %xmm0
        vorpd     %xmm6, %xmm0, %xmm6
        vmovups   %xmm9, 112(%rsp)
        vandnpd   %xmm11, %xmm2, %xmm9
        vcvtpd2ps %xmm6, %xmm2
        vmovddup  12992+__svml_dlog1p_ha_data_internal(%rip), %xmm4
        vmovddup  %xmm11, %xmm3
        vmovups   %xmm15, 48(%rsp)
        vmovups   %xmm13, 16(%rsp)
        vmaxpd    %xmm3, %xmm4, %xmm13
        vminpd    %xmm3, %xmm4, %xmm15
        vmovlhps  %xmm2, %xmm2, %xmm4
        vrcpps    %xmm4, %xmm3
        vcvtps2pd %xmm3, %xmm5
        vcmpnlesd 12864+__svml_dlog1p_ha_data_internal(%rip), %xmm11, %xmm3
        vmovups   %xmm14, 128(%rsp)
        vsubsd    %xmm8, %xmm13, %xmm14
        vmovq     13568+__svml_dlog1p_ha_data_internal(%rip), %xmm12
        vaddsd    %xmm15, %xmm14, %xmm7
        vroundsd  $0, %xmm5, %xmm5, %xmm4
        vmovq     13632+__svml_dlog1p_ha_data_internal(%rip), %xmm13
        vfmsub213sd %xmm10, %xmm4, %xmm6
        vpand     %xmm12, %xmm8, %xmm10
        vpsubq    %xmm10, %xmm13, %xmm14
        vcmpltsd  12800+__svml_dlog1p_ha_data_internal(%rip), %xmm11, %xmm5
        vmulsd    %xmm4, %xmm14, %xmm2
        vpsrlq    $20, %xmm8, %xmm8
        vorpd     %xmm3, %xmm5, %xmm0
        vpshufd   $85, %xmm8, %xmm15
        vpsrlq    $39, %xmm4, %xmm3
        vmulsd    %xmm2, %xmm7, %xmm7
        vmovd     %xmm3, %eax
        vmovmskpd %xmm0, %ecx
        vpshufd   $0, %xmm15, %xmm1
        vaddsd    %xmm7, %xmm6, %xmm3
        vcvtdq2pd %xmm1, %xmm1
        vsubsd    %xmm6, %xmm3, %xmm6
        movslq    %eax, %rax
        vmovapd   %xmm1, %xmm0
        vmovsd    13248+__svml_dlog1p_ha_data_internal(%rip), %xmm4
        vmovsd    12416+__svml_dlog1p_ha_data_internal(%rip), %xmm8
        vmovsd    12544+__svml_dlog1p_ha_data_internal(%rip), %xmm2
        vfmadd213sd -8(%rdx,%rax), %xmm4, %xmm0
        vsubsd    %xmm6, %xmm7, %xmm4
        vfmadd213sd 12480+__svml_dlog1p_ha_data_internal(%rip), %xmm3, %xmm8
        vfmadd213sd 12608+__svml_dlog1p_ha_data_internal(%rip), %xmm3, %xmm2
        vmovddup  (%rdx,%rax), %xmm5
        vaddsd    %xmm3, %xmm0, %xmm12
        vfmadd132sd 13312+__svml_dlog1p_ha_data_internal(%rip), %xmm5, %xmm1
        vmulsd    %xmm3, %xmm3, %xmm5
        vsubsd    %xmm0, %xmm12, %xmm0
        vaddsd    %xmm4, %xmm1, %xmm1
        vfmadd213sd %xmm2, %xmm5, %xmm8
        vsubsd    %xmm0, %xmm3, %xmm7
        vfmadd213sd %xmm1, %xmm5, %xmm8
        vaddsd    %xmm8, %xmm7, %xmm10
        vaddsd    %xmm12, %xmm10, %xmm13
        vorpd     %xmm9, %xmm13, %xmm0
        andl      $1, %ecx
        jne       ..B1.3
..B1.2:
        vmovups   80(%rsp), %xmm8
	.cfi_restore 25
        vmovups   112(%rsp), %xmm9
	.cfi_restore 26
        vmovups   32(%rsp), %xmm10
	.cfi_restore 27
        vmovups   96(%rsp), %xmm11
	.cfi_restore 28
        vmovups   144(%rsp), %xmm12
	.cfi_restore 29
        vmovups   16(%rsp), %xmm13
	.cfi_restore 30
        vmovups   128(%rsp), %xmm14
	.cfi_restore 31
        vmovups   48(%rsp), %xmm15
	.cfi_restore 32
        addq      $176, %rsp
	.cfi_restore 5
        popq      %rdi
	.cfi_restore 4
        popq      %rsi
        movq      %rbp, %rsp
        popq      %rbp
	.cfi_def_cfa 7, 8
	.cfi_restore 6
        ret
	.cfi_def_cfa 6, 16
	.cfi_offset 6, -16
..B1.3:
        vmovsd    %xmm11, (%rsp)
        vmovsd    %xmm0, 64(%rsp)
        jne       ..B1.6
..B1.4:
        vmovsd    64(%rsp), %xmm0
        jmp       ..B1.2
..B1.6:
        lea       (%rsp), %rdi
        lea       64(%rsp), %rsi
        call      __svml_dlog1p_ha_cout_rare_internal
        jmp       ..B1.4
END(log1p_avx2)
	.data
	.hidden __svml_dlog1p_ha_data_internal
	.hidden __svml_dlog1p_ha_cout_rare_internal
	.section .note.GNU-stack, ""
# End
