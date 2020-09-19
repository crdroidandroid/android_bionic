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
ENTRY(sinh_avx2)
# parameter 1: %ymm0
..B1.1:
..L1:

        pushq     %rbp
	.cfi_def_cfa_offset 16
        movq      %rsp, %rbp
	.cfi_def_cfa 6, 16
	.cfi_offset 6, -16
        andq      $-64, %rsp
        subq      $384, %rsp
        lea       __svml_dsinh_ha_data_internal(%rip), %rcx
        vmovdqa   %ymm0, %ymm2
        vmovupd   1408+__svml_dsinh_ha_data_internal(%rip), %ymm0
        vmovups   %ymm14, 224(%rsp)
        vmovupd   512+__svml_dsinh_ha_data_internal(%rip), %ymm7
        vmovupd   1216+__svml_dsinh_ha_data_internal(%rip), %ymm14
        vmovups   %ymm15, 160(%rsp)
        vmovups   %ymm13, 288(%rsp)
        vmovups   %ymm12, 320(%rsp)
        vandpd    %ymm2, %ymm0, %ymm1
        vxorpd    %ymm2, %ymm1, %ymm5
        vfmadd213pd %ymm7, %ymm5, %ymm14
        vcmpeqpd  576+__svml_dsinh_ha_data_internal(%rip), %ymm14, %ymm15
        vblendvpd %ymm15, %ymm7, %ymm14, %ymm15
        vandps    704+__svml_dsinh_ha_data_internal(%rip), %ymm15, %ymm13
        vsubpd    %ymm7, %ymm15, %ymm7
        vxorps    %ymm13, %ymm15, %ymm15
        vextracti128 $1, %ymm5, %xmm6
        vshufps   $221, %xmm6, %xmm5, %xmm4
        vpsllq    $3, %ymm13, %ymm6
        vpcmpgtd  640+__svml_dsinh_ha_data_internal(%rip), %xmm4, %xmm3
        vmovmskps %xmm3, %r8d
        vfnmadd231pd 1280+__svml_dsinh_ha_data_internal(%rip), %ymm7, %ymm5
        vfnmadd231pd 1344+__svml_dsinh_ha_data_internal(%rip), %ymm7, %ymm5
        testl     %r8d, %r8d
        vpsllq    $48, %ymm15, %ymm7
        vextracti128 $1, %ymm6, %xmm12
        vmovd     %xmm6, %edx
        vmovd     %xmm12, %r9d
        movslq    %edx, %rdx
        vpextrd   $2, %xmm6, %eax
        movslq    %r9d, %r9
        vpextrd   $2, %xmm12, %r10d
        movslq    %eax, %rax
        movslq    %r10d, %r10
        vmovsd    (%rdx,%rcx), %xmm4
        vmovsd    (%r9,%rcx), %xmm14
        vmovhpd   (%rax,%rcx), %xmm4, %xmm3
        vmovhpd   (%r10,%rcx), %xmm14, %xmm6
        vmovsd    256(%rdx,%rcx), %xmm4
        vmovhpd   256(%rax,%rcx), %xmm4, %xmm14
        vinsertf128 $1, %xmm6, %ymm3, %ymm12
        vmovsd    256(%r9,%rcx), %xmm6
        vmovhpd   256(%r10,%rcx), %xmm6, %xmm4
        vmovsd    128(%rdx,%rcx), %xmm3
        vmovhpd   128(%rax,%rcx), %xmm3, %xmm6
        vpaddq    %ymm7, %ymm12, %ymm12
        vinsertf128 $1, %xmm4, %ymm14, %ymm14
        vmovsd    128(%r9,%rcx), %xmm4
        vmovhpd   128(%r10,%rcx), %xmm4, %xmm3
        vmovsd    384(%rdx,%rcx), %xmm4
        vpsubq    %ymm7, %ymm14, %ymm13
        vsubpd    %ymm13, %ymm12, %ymm15
        vaddpd    %ymm13, %ymm12, %ymm14
        vinsertf128 $1, %xmm3, %ymm6, %ymm3
        vmovhpd   384(%rax,%rcx), %xmm4, %xmm6
        vmovsd    384(%r9,%rcx), %xmm4
        vmovhpd   384(%r10,%rcx), %xmm4, %xmm4
        vpaddq    %ymm7, %ymm3, %ymm3
        vinsertf128 $1, %xmm4, %ymm6, %ymm4
        vandnpd   %ymm4, %ymm0, %ymm0
        vpsubq    %ymm7, %ymm4, %ymm4
        vmulpd    %ymm5, %ymm5, %ymm6
        vcmplt_oqpd %ymm7, %ymm0, %ymm0
        vsubpd    %ymm12, %ymm15, %ymm7
        vandnpd   %ymm4, %ymm0, %ymm4
        vmovupd   1152+__svml_dsinh_ha_data_internal(%rip), %ymm0
        vaddpd    %ymm7, %ymm13, %ymm12
        vmovupd   1088+__svml_dsinh_ha_data_internal(%rip), %ymm13
        vfmadd213pd 1024+__svml_dsinh_ha_data_internal(%rip), %ymm6, %ymm0
        vsubpd    %ymm12, %ymm3, %ymm3
        vfmadd213pd 960+__svml_dsinh_ha_data_internal(%rip), %ymm6, %ymm13
        vfmadd213pd 896+__svml_dsinh_ha_data_internal(%rip), %ymm6, %ymm0
        vsubpd    %ymm4, %ymm3, %ymm3
        vfmadd213pd 832+__svml_dsinh_ha_data_internal(%rip), %ymm6, %ymm13
        vfmadd213pd 768+__svml_dsinh_ha_data_internal(%rip), %ymm6, %ymm0
        vmulpd    %ymm13, %ymm6, %ymm4
        vmulpd    %ymm0, %ymm6, %ymm6
        vfmadd213pd %ymm5, %ymm5, %ymm4
        vfmadd213pd %ymm3, %ymm15, %ymm6
        vfmadd213pd %ymm6, %ymm14, %ymm4
        vaddpd    %ymm4, %ymm15, %ymm5
        vorpd     %ymm5, %ymm1, %ymm0
        jne       ..B1.3
..B1.2:
        vmovups   320(%rsp), %ymm12
	.cfi_restore 95
        vmovups   288(%rsp), %ymm13
	.cfi_restore 96
        vmovups   224(%rsp), %ymm14
	.cfi_restore 97
        vmovups   160(%rsp), %ymm15
	.cfi_restore 98
        movq      %rbp, %rsp
        popq      %rbp
	.cfi_def_cfa 7, 8
	.cfi_restore 6
        ret
	.cfi_def_cfa 6, 16
	.cfi_offset 6, -16
..B1.3:
        vmovupd   %ymm2, 192(%rsp)
        vmovupd   %ymm0, 256(%rsp)
..B1.6:
        xorl      %eax, %eax
        vmovups   %ymm8, 96(%rsp)
        vmovups   %ymm9, 64(%rsp)
        vmovups   %ymm10, 32(%rsp)
        vmovups   %ymm11, (%rsp)
        movq      %rsi, 136(%rsp)
        movq      %rdi, 128(%rsp)
        movq      %r12, 152(%rsp)
        movl      %eax, %r12d
        movq      %r13, 144(%rsp)
        movl      %r8d, %r13d
..B1.7:
        btl       %r12d, %r13d
        jc        ..B1.10
..B1.8:
        incl      %r12d
        cmpl      $4, %r12d
        jl        ..B1.7
..B1.9:
        vmovups   96(%rsp), %ymm8
	.cfi_restore 91
        vmovups   64(%rsp), %ymm9
	.cfi_restore 92
        vmovups   32(%rsp), %ymm10
	.cfi_restore 93
        vmovups   (%rsp), %ymm11
	.cfi_restore 94
        vmovupd   256(%rsp), %ymm0
        movq      136(%rsp), %rsi
	.cfi_restore 4
        movq      128(%rsp), %rdi
	.cfi_restore 5
        movq      152(%rsp), %r12
	.cfi_restore 12
        movq      144(%rsp), %r13
	.cfi_restore 13
        jmp       ..B1.2
..B1.10:
        vzeroupper
        lea       192(%rsp,%r12,8), %rdi
        lea       256(%rsp,%r12,8), %rsi
        call      __svml_dsinh_ha_cout_rare_internal
        jmp       ..B1.8
END(sinh_avx2)
	.data
	.hidden __svml_dsinh_ha_data_internal
	.hidden __svml_dsinh_ha_cout_rare_internal
	.section .note.GNU-stack, ""
# End
