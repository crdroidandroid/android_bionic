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
# -- Begin  asin
ENTRY(log10f_avx2)
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
        vmovaps   %xmm0, %xmm1
        vmovss    1280+__svml_slog10_ha_data_internal(%rip), %xmm2
        vpsrld    $23, %xmm1, %xmm7
        vmovss    1344+__svml_slog10_ha_data_internal(%rip), %xmm4
        vandps    %xmm2, %xmm1, %xmm3
        vorps     %xmm4, %xmm3, %xmm0
        lea       -136944+__svml_slog10_ha_data_internal(%rip), %rdx
        vrcpps    %xmm0, %xmm5
        vcmpltss  1408+__svml_slog10_ha_data_internal(%rip), %xmm1, %xmm2
        vcmpnless 1472+__svml_slog10_ha_data_internal(%rip), %xmm1, %xmm3
        vmovss    1600+__svml_slog10_ha_data_internal(%rip), %xmm4
        vmulss    %xmm4, %xmm5, %xmm6
        vorps     %xmm3, %xmm2, %xmm5
        vmovmskps %xmm5, %ecx
        vmovups   %xmm8, 16(%rsp)
        vroundss  $0, %xmm6, %xmm6, %xmm6
        vpsrld    $13, %xmm6, %xmm8
        vpshufd   $0, %xmm7, %xmm7
        vmovd     %xmm8, %eax
        vmovups   %xmm13, 48(%rsp)
        vmovups   %xmm9, 96(%rsp)
        vcvtdq2ps %xmm7, %xmm13
        vfmsub213ss %xmm4, %xmm6, %xmm0
        vmovups   %xmm11, 112(%rsp)
        vmovaps   %xmm13, %xmm11
        movslq    %eax, %rax
        vmovups   %xmm14, 32(%rsp)
        vmovss    1088+__svml_slog10_ha_data_internal(%rip), %xmm14
        vfmadd213ss 1152+__svml_slog10_ha_data_internal(%rip), %xmm0, %xmm14
        vmovq     (%rdx,%rax), %xmm9
        vmovups   %xmm10, 144(%rsp)
        vshufps   $85, %xmm9, %xmm9, %xmm10
        vmovups   %xmm12, 80(%rsp)
        vfmadd132ss 1664+__svml_slog10_ha_data_internal(%rip), %xmm9, %xmm11
        vfmadd132ss 1728+__svml_slog10_ha_data_internal(%rip), %xmm10, %xmm13
        vfmadd213ss 1216+__svml_slog10_ha_data_internal(%rip), %xmm0, %xmm14
        vmovups   %xmm15, 128(%rsp)
        vaddss    %xmm0, %xmm11, %xmm2
        vfmadd213ss %xmm13, %xmm0, %xmm14
        vsubss    %xmm11, %xmm2, %xmm12
        vsubss    %xmm12, %xmm0, %xmm15
        vaddss    %xmm15, %xmm14, %xmm0
        vaddss    %xmm2, %xmm0, %xmm0
        andl      $1, %ecx
        jne       ..B1.3
..B1.2:
        vmovups   16(%rsp), %xmm8
	.cfi_restore 25
        vmovups   96(%rsp), %xmm9
	.cfi_restore 26
        vmovups   144(%rsp), %xmm10
	.cfi_restore 27
        vmovups   112(%rsp), %xmm11
	.cfi_restore 28
        vmovups   80(%rsp), %xmm12
	.cfi_restore 29
        vmovups   48(%rsp), %xmm13
	.cfi_restore 30
        vmovups   32(%rsp), %xmm14
	.cfi_restore 31
        vmovups   128(%rsp), %xmm15
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
        vmovss    %xmm1, (%rsp)
        vmovss    %xmm0, 64(%rsp)
        jne       ..B1.6
..B1.4:
        vmovss    64(%rsp), %xmm0
        jmp       ..B1.2
..B1.6:
        lea       (%rsp), %rdi
        lea       64(%rsp), %rsi
        call      __svml_slog10_ha_cout_rare_internal
        jmp       ..B1.4
END(log10f_avx2)
	.data
	.hidden __svml_slog10_ha_data_internal
	.hidden __svml_slog10_ha_cout_rare_internal
	.section .note.GNU-stack, ""
# End
