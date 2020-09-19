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
ENTRY(log1pf_avx2)
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
        lea       -137216+__svml_slog1p_ha_data_internal(%rip), %rdx
        vmovups   %xmm9, 96(%rsp)
        vmovaps   %xmm0, %xmm9
        vmovss    1984+__svml_slog1p_ha_data_internal(%rip), %xmm7
        vbroadcastss %xmm9, %xmm4
        vbroadcastss %xmm7, %xmm1
        vmovups   %xmm14, 144(%rsp)
        vmovups   %xmm12, 32(%rsp)
        vmovss    1088+__svml_slog1p_ha_data_internal(%rip), %xmm6
        vmaxps    %xmm4, %xmm1, %xmm12
        vminps    %xmm4, %xmm1, %xmm14
        vandps    %xmm6, %xmm9, %xmm5
        vmovups   %xmm10, 80(%rsp)
        vaddss    %xmm14, %xmm12, %xmm10
        vcmpltss  1152+__svml_slog1p_ha_data_internal(%rip), %xmm5, %xmm3
        vmovss    1216+__svml_slog1p_ha_data_internal(%rip), %xmm2
        vmovups   %xmm11, 112(%rsp)
        vorps     %xmm3, %xmm2, %xmm11
        vmovups   %xmm15, 48(%rsp)
        vmovups   %xmm8, 128(%rsp)
        vandnps   %xmm9, %xmm6, %xmm8
        vmovss    1536+__svml_slog1p_ha_data_internal(%rip), %xmm15
        vandps    %xmm11, %xmm10, %xmm6
        vmovss    1600+__svml_slog1p_ha_data_internal(%rip), %xmm0
        vandps    %xmm15, %xmm6, %xmm1
        vorps     %xmm0, %xmm1, %xmm4
        vpsrld    $23, %xmm6, %xmm15
        vrcpps    %xmm4, %xmm10
        vcmpltss  1664+__svml_slog1p_ha_data_internal(%rip), %xmm9, %xmm3
        vcmpnless 1728+__svml_slog1p_ha_data_internal(%rip), %xmm9, %xmm2
        vmovups   %xmm13, 16(%rsp)
        vorps     %xmm2, %xmm3, %xmm2
        vmovd     1280+__svml_slog1p_ha_data_internal(%rip), %xmm11
        vsubss    %xmm6, %xmm12, %xmm13
        vmovmskps %xmm2, %ecx
        vmovd     1344+__svml_slog1p_ha_data_internal(%rip), %xmm12
        vaddss    %xmm14, %xmm13, %xmm5
        vpand     %xmm11, %xmm6, %xmm13
        vroundss  $0, %xmm10, %xmm10, %xmm4
        vpsubd    %xmm13, %xmm12, %xmm14
        vmulss    %xmm4, %xmm14, %xmm0
        vpsrld    $13, %xmm4, %xmm4
        vmovd     %xmm4, %eax
        vpshufd   $0, %xmm15, %xmm1
        vcvtdq2ps %xmm1, %xmm1
        vfmsub213ss %xmm7, %xmm0, %xmm6
        vmulss    %xmm0, %xmm5, %xmm7
        movslq    %eax, %rax
        vmovaps   %xmm1, %xmm10
        vmovss    1408+__svml_slog1p_ha_data_internal(%rip), %xmm12
        vaddss    %xmm7, %xmm6, %xmm0
        vmovq     (%rdx,%rax), %xmm3
        vsubss    %xmm6, %xmm0, %xmm2
        vfmadd132ss 1856+__svml_slog1p_ha_data_internal(%rip), %xmm3, %xmm10
        vmulss    %xmm0, %xmm0, %xmm6
        vfmadd213ss 1472+__svml_slog1p_ha_data_internal(%rip), %xmm0, %xmm12
        vsubss    %xmm2, %xmm7, %xmm7
        vaddss    %xmm0, %xmm10, %xmm14
        vfmadd213ss %xmm7, %xmm6, %xmm12
        vshufps   $85, %xmm3, %xmm3, %xmm5
        vsubss    %xmm10, %xmm14, %xmm11
        vfmadd132ss 1920+__svml_slog1p_ha_data_internal(%rip), %xmm5, %xmm1
        vsubss    %xmm11, %xmm0, %xmm0
        vaddss    %xmm0, %xmm1, %xmm1
        vaddss    %xmm12, %xmm1, %xmm13
        vaddss    %xmm14, %xmm13, %xmm15
        vorps     %xmm8, %xmm15, %xmm0
        andl      $1, %ecx
        jne       ..B1.3
..B1.2:
        vmovups   128(%rsp), %xmm8
	.cfi_restore 25
        vmovups   96(%rsp), %xmm9
	.cfi_restore 26
        vmovups   80(%rsp), %xmm10
	.cfi_restore 27
        vmovups   112(%rsp), %xmm11
	.cfi_restore 28
        vmovups   32(%rsp), %xmm12
	.cfi_restore 29
        vmovups   16(%rsp), %xmm13
	.cfi_restore 30
        vmovups   144(%rsp), %xmm14
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
        vmovss    %xmm9, (%rsp)
        vmovss    %xmm0, 64(%rsp)
        jne       ..B1.6
..B1.4:
        vmovss    64(%rsp), %xmm0
        jmp       ..B1.2
..B1.6:
        lea       (%rsp), %rdi
        lea       64(%rsp), %rsi
        call      __svml_slog1p_ha_cout_rare_internal
        jmp       ..B1.4
END(log1pf_avx2)
# -- End  __svml_log1pf1_ha_l9
	.data
	.hidden __svml_slog1p_ha_data_internal
	.hidden __svml_slog1p_ha_cout_rare_internal
	.section .note.GNU-stack, ""
# End
