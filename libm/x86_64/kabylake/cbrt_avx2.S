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
# -- Begin  cbrt
ENTRY(cbrt_avx2)
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
        lea       __svml_dcbrt_ha_data_internal(%rip), %rcx
        vmovups   %xmm8, 80(%rsp)
        vmovapd   %xmm0, %xmm8
        vmovups   %xmm15, 128(%rsp)
        vmovups   %xmm14, 144(%rsp)
        vpsrlq    $52, %xmm8, %xmm14
        vmovq     2624+__svml_dcbrt_ha_data_internal(%rip), %xmm15
        vmovq     2688+__svml_dcbrt_ha_data_internal(%rip), %xmm4
        vpand     %xmm15, %xmm14, %xmm0
        vpmuludq  %xmm4, %xmm0, %xmm4
        vmovd     2816+__svml_dcbrt_ha_data_internal(%rip), %xmm1
        vpshufd   $85, %xmm8, %xmm7
        vmovd     3008+__svml_dcbrt_ha_data_internal(%rip), %xmm3
        vpand     %xmm1, %xmm7, %xmm2
        vpshufd   $0, %xmm4, %xmm1
        vmovups   %xmm12, 112(%rsp)
        vmovups   %xmm10, 32(%rsp)
        vmovups   %xmm9, 48(%rsp)
        vpsubd    %xmm3, %xmm2, %xmm9
        vmovd     2752+__svml_dcbrt_ha_data_internal(%rip), %xmm12
        vpsrld    $14, %xmm1, %xmm2
        vmovd     3072+__svml_dcbrt_ha_data_internal(%rip), %xmm10
        vpshufd   $0, %xmm0, %xmm4
        vmovups   %xmm13, 96(%rsp)
        vpand     %xmm12, %xmm7, %xmm13
        vmovups   %xmm11, 16(%rsp)
        vpcmpgtd  %xmm10, %xmm9, %xmm11
        vmovd     2880+__svml_dcbrt_ha_data_internal(%rip), %xmm6
        vpsubd    %xmm2, %xmm4, %xmm9
        vpaddd    %xmm2, %xmm2, %xmm10
        vpsrld    $20, %xmm7, %xmm7
        vmovd     2944+__svml_dcbrt_ha_data_internal(%rip), %xmm5
        vpand     %xmm6, %xmm7, %xmm6
        vmovmskps %xmm11, %esi
        vpsubd    %xmm10, %xmm9, %xmm11
        vpsrld    $12, %xmm13, %xmm3
        vpslld    $8, %xmm11, %xmm12
        vpor      %xmm5, %xmm6, %xmm5
        vmovd     %xmm3, %eax
        vpaddd    %xmm12, %xmm3, %xmm3
        vmovsd    2368+__svml_dcbrt_ha_data_internal(%rip), %xmm9
        vpaddd    %xmm2, %xmm5, %xmm2
        vmovsd    2496+__svml_dcbrt_ha_data_internal(%rip), %xmm5
        vpslld    $1, %xmm3, %xmm13
        vmovsd    2432+__svml_dcbrt_ha_data_internal(%rip), %xmm7
        vandpd    %xmm5, %xmm8, %xmm6
        vmovsd    2304+__svml_dcbrt_ha_data_internal(%rip), %xmm11
        vandpd    %xmm9, %xmm8, %xmm10
        vmovd     %xmm13, %edx
        vorpd     %xmm7, %xmm6, %xmm12
        vorpd     %xmm11, %xmm10, %xmm13
        vpslld    $20, %xmm2, %xmm4
        vsubsd    %xmm13, %xmm12, %xmm14
        movslq    %eax, %rax
        vpxor     %xmm3, %xmm3, %xmm3
        vpunpckldq %xmm4, %xmm3, %xmm15
        vmovsd    1792+__svml_dcbrt_ha_data_internal(%rip), %xmm3
        movslq    %edx, %rdx
        vmulsd    (%rcx,%rax), %xmm14, %xmm2
        vfmadd213sd 1856+__svml_dcbrt_ha_data_internal(%rip), %xmm2, %xmm3
        vmovupd   256(%rcx,%rdx), %xmm0
        vmovsd    264(%rcx,%rdx), %xmm1
        vmulsd    %xmm15, %xmm0, %xmm4
        vfmadd213sd 1920+__svml_dcbrt_ha_data_internal(%rip), %xmm2, %xmm3
        vmulsd    %xmm15, %xmm1, %xmm15
        vmulsd    %xmm2, %xmm4, %xmm1
        vfmadd213sd 1984+__svml_dcbrt_ha_data_internal(%rip), %xmm2, %xmm3
        vfmadd213sd 2048+__svml_dcbrt_ha_data_internal(%rip), %xmm2, %xmm3
        vfmadd213sd 2112+__svml_dcbrt_ha_data_internal(%rip), %xmm2, %xmm3
        vfmadd213sd 2176+__svml_dcbrt_ha_data_internal(%rip), %xmm2, %xmm3
        vfmadd213sd 2240+__svml_dcbrt_ha_data_internal(%rip), %xmm2, %xmm3
        vmulsd    %xmm1, %xmm3, %xmm0
        vaddsd    %xmm15, %xmm0, %xmm0
        vaddsd    %xmm4, %xmm0, %xmm0
        andl      $1, %esi
        jne       ..B1.3
..B1.2:
        vmovups   80(%rsp), %xmm8
	.cfi_restore 25
        vmovups   48(%rsp), %xmm9
	.cfi_restore 26
        vmovups   32(%rsp), %xmm10
	.cfi_restore 27
        vmovups   16(%rsp), %xmm11
	.cfi_restore 28
        vmovups   112(%rsp), %xmm12
	.cfi_restore 29
        vmovups   96(%rsp), %xmm13
	.cfi_restore 30
        vmovups   144(%rsp), %xmm14
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
        vmovsd    %xmm8, (%rsp)
        vmovsd    %xmm0, 64(%rsp)
        jne       ..B1.6
..B1.4:
        vmovsd    64(%rsp), %xmm0
        jmp       ..B1.2
..B1.6:
        lea       (%rsp), %rdi
        lea       64(%rsp), %rsi
        call      __svml_dcbrt_ha_cout_rare_internal
        jmp       ..B1.4
END(cbrt_avx2)
	.hidden __svml_dcbrt_ha_data_internal
	.hidden __svml_dcbrt_ha_cout_rare_internal
	.section .note.GNU-stack, ""
# End
