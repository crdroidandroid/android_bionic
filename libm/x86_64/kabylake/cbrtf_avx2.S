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
ENTRY(cbrtf_avx2)
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
        lea       __svml_scbrt_ha_data_internal(%rip), %rcx
        vmovups   %xmm15, 128(%rsp)
        vmovaps   %xmm0, %xmm15
        vmovd     1408+__svml_scbrt_ha_data_internal(%rip), %xmm2
        vpsrld    $16, %xmm15, %xmm3
        vmovd     1792+__svml_scbrt_ha_data_internal(%rip), %xmm0
        vmovd     1856+__svml_scbrt_ha_data_internal(%rip), %xmm4
        vmovups   %xmm14, 16(%rsp)
        vpand     %xmm2, %xmm3, %xmm14
        vpand     %xmm0, %xmm15, %xmm2
        vmovups   %xmm9, 48(%rsp)
        vpsubd    %xmm4, %xmm2, %xmm4
        vmovups   %xmm8, 112(%rsp)
        vmovss    1152+__svml_scbrt_ha_data_internal(%rip), %xmm9
        vmovss    1216+__svml_scbrt_ha_data_internal(%rip), %xmm8
        vmovd     1920+__svml_scbrt_ha_data_internal(%rip), %xmm5
        vandps    %xmm8, %xmm15, %xmm2
        vmovups   %xmm10, 80(%rsp)
        vpsrld    $7, %xmm3, %xmm10
        vmovd     1472+__svml_scbrt_ha_data_internal(%rip), %xmm1
        vpcmpgtd  %xmm5, %xmm4, %xmm3
        vmovss    1280+__svml_scbrt_ha_data_internal(%rip), %xmm6
        vandps    %xmm9, %xmm15, %xmm5
        vmovss    1344+__svml_scbrt_ha_data_internal(%rip), %xmm7
        vorps     %xmm6, %xmm5, %xmm6
        vmovups   %xmm11, 96(%rsp)
        vpand     %xmm1, %xmm10, %xmm11
        vmovd     1728+__svml_scbrt_ha_data_internal(%rip), %xmm0
        vorps     %xmm7, %xmm2, %xmm7
        vpmulld   %xmm0, %xmm11, %xmm1
        vsubss    %xmm7, %xmm6, %xmm2
        vmovmskps %xmm3, %esi
        vmovd     %xmm14, %eax
        vmovd     1664+__svml_scbrt_ha_data_internal(%rip), %xmm6
        vpsrld    $12, %xmm1, %xmm1
        vpsubd    %xmm6, %xmm11, %xmm7
        vpsubd    %xmm1, %xmm7, %xmm8
        vmovups   %xmm13, 144(%rsp)
        vpsubd    %xmm1, %xmm8, %xmm9
        vmovd     1536+__svml_scbrt_ha_data_internal(%rip), %xmm13
        vpand     %xmm13, %xmm10, %xmm4
        vpsubd    %xmm1, %xmm9, %xmm10
        vpslld    $7, %xmm10, %xmm11
        vpaddd    %xmm11, %xmm14, %xmm13
        vpandn    %xmm13, %xmm3, %xmm3
        vpslld    $1, %xmm3, %xmm14
        vmovd     %xmm14, %edx
        vmovups   %xmm12, 32(%rsp)
        vmovd     1600+__svml_scbrt_ha_data_internal(%rip), %xmm12
        movslq    %eax, %rax
        vpaddd    %xmm12, %xmm1, %xmm12
        movslq    %edx, %rdx
        vpor      %xmm4, %xmm12, %xmm5
        vpslld    $23, %xmm5, %xmm0
        vmulss    (%rcx,%rax), %xmm2, %xmm2
        vmovq     128(%rcx,%rdx), %xmm1
        vshufps   $85, %xmm1, %xmm1, %xmm3
        vmulss    %xmm0, %xmm1, %xmm7
        vmulss    %xmm0, %xmm3, %xmm5
        vmovss    896+__svml_scbrt_ha_data_internal(%rip), %xmm0
        vfmadd213ss 960+__svml_scbrt_ha_data_internal(%rip), %xmm2, %xmm0
        vfmadd213ss 1024+__svml_scbrt_ha_data_internal(%rip), %xmm2, %xmm0
        vfmadd213ss 1088+__svml_scbrt_ha_data_internal(%rip), %xmm2, %xmm0
        vmulss    %xmm2, %xmm7, %xmm2
        vmulss    %xmm2, %xmm0, %xmm4
        vaddss    %xmm5, %xmm4, %xmm6
        vaddss    %xmm7, %xmm6, %xmm0
        andl      $1, %esi
        jne       ..B1.3
..B1.2:
        vmovups   112(%rsp), %xmm8
	.cfi_restore 25
        vmovups   48(%rsp), %xmm9
        .cfi_restore 26
        vmovups   80(%rsp), %xmm10
        .cfi_restore 27
        vmovups   96(%rsp), %xmm11
        .cfi_restore 28    
        vmovups   32(%rsp), %xmm12
        .cfi_restore 29
        vmovups   144(%rsp), %xmm13
        .cfi_restore 30
        vmovups   16(%rsp), %xmm14
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
        vmovss    %xmm15, (%rsp)
        vmovss    %xmm0, 64(%rsp)
        jne       ..B1.6
..B1.4:
        vmovss    64(%rsp), %xmm0
        jmp       ..B1.2
..B1.6:
        lea       (%rsp), %rdi
        lea       64(%rsp), %rsi
        call      __svml_scbrt_ha_cout_rare_internal
        jmp       ..B1.4
END(cbrtf_avx2)
	.data
# -- End  __svml_cbrtf1_ha_l9
	.data
	.hidden __svml_scbrt_ha_data_internal
	.hidden __svml_scbrt_ha_cout_rare_internal
	.section .note.GNU-stack, ""
# End
