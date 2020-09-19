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
ENTRY(log10_avx2)
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
        vmovapd   %xmm0, %xmm2
        vmovsd    9024+__svml_dlog10_ha_data_internal(%rip), %xmm3
        lea       -4221880+__svml_dlog10_ha_data_internal(%rip), %rdx
        vmovsd    9088+__svml_dlog10_ha_data_internal(%rip), %xmm5
        vandpd    %xmm3, %xmm2, %xmm4
        vorpd     %xmm5, %xmm4, %xmm1
        vpsrlq    $20, %xmm2, %xmm5
        vcvtpd2ps %xmm1, %xmm6
        vmovlhps  %xmm6, %xmm6, %xmm7
        vrcpps    %xmm7, %xmm0
        vcvtps2pd %xmm0, %xmm3
        vmovups   %xmm11, 112(%rsp)
        vmovsd    9344+__svml_dlog10_ha_data_internal(%rip), %xmm11
        vmulsd    %xmm11, %xmm3, %xmm4
        vpshufd   $85, %xmm5, %xmm6
        vmovups   %xmm12, 48(%rsp)
        vroundsd  $0, %xmm4, %xmm4, %xmm12
        vpshufd   $0, %xmm6, %xmm7
        vmovups   %xmm13, 16(%rsp)
        vpsrlq    $40, %xmm12, %xmm13
        vcvtdq2pd %xmm7, %xmm0
        vfmsub213sd %xmm11, %xmm12, %xmm1
        vmovd     %xmm13, %eax
        vmovups   %xmm14, 96(%rsp)
        vmovapd   %xmm0, %xmm3
        vmovsd    9472+__svml_dlog10_ha_data_internal(%rip), %xmm14
        movslq    %eax, %rax
        vmovsd    8320+__svml_dlog10_ha_data_internal(%rip), %xmm6
        vmovups   %xmm9, 128(%rsp)
        vmovups   %xmm8, 80(%rsp)
        vfmadd213sd -8(%rdx,%rax), %xmm14, %xmm3
        vmovsd    8448+__svml_dlog10_ha_data_internal(%rip), %xmm14
        vmovsd    8576+__svml_dlog10_ha_data_internal(%rip), %xmm5
        vmovups   %xmm10, 32(%rsp)
        vmovups   %xmm15, 144(%rsp)
        vfmadd213sd 8384+__svml_dlog10_ha_data_internal(%rip), %xmm1, %xmm6
        vfmadd213sd 8512+__svml_dlog10_ha_data_internal(%rip), %xmm1, %xmm14
        vmulsd    %xmm1, %xmm1, %xmm4
        vcmpltsd  9152+__svml_dlog10_ha_data_internal(%rip), %xmm2, %xmm8
        vfmadd213sd 8640+__svml_dlog10_ha_data_internal(%rip), %xmm1, %xmm5
        vcmpnlesd 9216+__svml_dlog10_ha_data_internal(%rip), %xmm2, %xmm9
        vfmadd213sd %xmm14, %xmm4, %xmm6
        vorpd     %xmm9, %xmm8, %xmm10
        vaddsd    %xmm1, %xmm3, %xmm9
        vmovmskpd %xmm10, %ecx
        vfmadd213sd %xmm5, %xmm4, %xmm6
        vmovddup  (%rdx,%rax), %xmm15
        vsubsd    %xmm3, %xmm9, %xmm7
        vfmadd132sd 9536+__svml_dlog10_ha_data_internal(%rip), %xmm15, %xmm0
        vmulsd    %xmm1, %xmm6, %xmm8
        vsubsd    %xmm7, %xmm1, %xmm1
        vaddsd    %xmm1, %xmm0, %xmm0
        vaddsd    %xmm8, %xmm0, %xmm1
        vaddsd    %xmm9, %xmm1, %xmm0
        andl      $1, %ecx
        jne       ..B1.3
..B1.2:
        vmovups   80(%rsp), %xmm8
	.cfi_restore 25
        vmovups   128(%rsp), %xmm9
	.cfi_restore 26
        vmovups   32(%rsp), %xmm10
	.cfi_restore 27
        vmovups   112(%rsp), %xmm11
	.cfi_restore 28
        vmovups   48(%rsp), %xmm12
	.cfi_restore 29
        vmovups   16(%rsp), %xmm13
	.cfi_restore 30
        vmovups   96(%rsp), %xmm14
	.cfi_restore 31
        vmovups   144(%rsp), %xmm15
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
        vmovsd    %xmm2, (%rsp)
        vmovsd    %xmm0, 64(%rsp)
        jne       ..B1.6
..B1.4:
        vmovsd    64(%rsp), %xmm0
        jmp       ..B1.2
..B1.6:
        lea       (%rsp), %rdi
        lea       64(%rsp), %rsi
        call      __svml_dlog10_ha_cout_rare_internal
        jmp       ..B1.4
END(log10_avx2)
	.data
	.hidden __svml_dlog10_ha_data_internal
	.hidden __svml_dlog10_ha_cout_rare_internal
	.section .note.GNU-stack, ""
# End
