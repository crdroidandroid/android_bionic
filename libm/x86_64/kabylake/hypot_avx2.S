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
# -- Begin  hypot
ENTRY(hypot_avx2)
# parameter 1: %xmm0
# parameter 2: %xmm1

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
        vmovups   %xmm9, 160(%rsp)
        vmovapd   %xmm1, %xmm9
        vmovups   %xmm8, 112(%rsp)
        vmovapd   %xmm0, %xmm8
        vmovsd    64+__svml_dhypot_ha_data_internal(%rip), %xmm0
        vandpd    %xmm0, %xmm8, %xmm2
        vandpd    %xmm0, %xmm9, %xmm5
        vmovddup  %xmm2, %xmm3
        vmovddup  %xmm5, %xmm4
        vmaxpd    %xmm4, %xmm3, %xmm6
        vminpd    %xmm3, %xmm4, %xmm5
        vmovups   %xmm11, 80(%rsp)
        vmovups   %xmm10, 96(%rsp)
        vpshufd   $85, %xmm6, %xmm10
        vpshufd   $85, %xmm5, %xmm11
        vmovups   %xmm13, 144(%rsp)
        vmovsd    __svml_dhypot_ha_data_internal(%rip), %xmm7
        vmovups   %xmm12, 48(%rsp)
        vpsubd    %xmm11, %xmm10, %xmm12
        vmovd     512+__svml_dhypot_ha_data_internal(%rip), %xmm13
        vandpd    %xmm7, %xmm6, %xmm3
        vmovups   %xmm14, 32(%rsp)
        vpcmpgtd  %xmm13, %xmm12, %xmm14
        vmulsd    %xmm3, %xmm3, %xmm1
        vsubsd    %xmm3, %xmm6, %xmm4
        vaddsd    %xmm3, %xmm6, %xmm6
        vmovups   %xmm15, 16(%rsp)
        vpshufd   $0, %xmm14, %xmm15
        vandnpd   %xmm7, %xmm15, %xmm7
        vandpd    %xmm7, %xmm5, %xmm7
        vmovapd   %xmm7, %xmm0
        vsubsd    %xmm7, %xmm5, %xmm2
        vfmadd213sd %xmm1, %xmm7, %xmm0
        vmulsd    %xmm4, %xmm6, %xmm1
        vmovapd   %xmm2, %xmm3
        vfmadd213sd %xmm1, %xmm5, %xmm3
        vmovd     576+__svml_dhypot_ha_data_internal(%rip), %xmm4
        vmovd     640+__svml_dhypot_ha_data_internal(%rip), %xmm6
        vfmadd213sd %xmm3, %xmm7, %xmm2
        vmovapd   %xmm2, %xmm7
        vaddsd    %xmm2, %xmm0, %xmm1
        vcvtpd2ps %xmm1, %xmm14
        vbroadcastss %xmm14, %xmm15
        vpshufd   $85, %xmm1, %xmm5
        vpcmpgtd  %xmm5, %xmm4, %xmm10
        vpcmpgtd  %xmm6, %xmm5, %xmm11
        vpor      %xmm11, %xmm10, %xmm12
        vmovapd   %xmm0, %xmm5
        vrsqrtps  %xmm15, %xmm3
        vpshufd   $0, %xmm12, %xmm13
        vcvtps2pd %xmm3, %xmm12
        vmovmskpd %xmm13, %eax
        vmovsd    192+__svml_dhypot_ha_data_internal(%rip), %xmm6
        vmulsd    %xmm12, %xmm12, %xmm4
        vfmsub213sd 128+__svml_dhypot_ha_data_internal(%rip), %xmm4, %xmm5
        vfmadd213sd %xmm5, %xmm4, %xmm7
        vfmadd213sd 256+__svml_dhypot_ha_data_internal(%rip), %xmm7, %xmm6
        vfmadd213sd 320+__svml_dhypot_ha_data_internal(%rip), %xmm7, %xmm6
        vfmadd213sd 384+__svml_dhypot_ha_data_internal(%rip), %xmm7, %xmm6
        vfmadd213sd 448+__svml_dhypot_ha_data_internal(%rip), %xmm7, %xmm6
        vmulsd    %xmm7, %xmm6, %xmm10
        vmulsd    %xmm12, %xmm10, %xmm11
        vmulsd    %xmm1, %xmm11, %xmm1
        vfmadd213sd %xmm1, %xmm12, %xmm2
        vfmadd213sd %xmm2, %xmm12, %xmm0
        andl      $1, %eax
        jne       ..B1.3
..B1.2:
        vmovups   112(%rsp), %xmm8
	.cfi_restore 25
        vmovups   160(%rsp), %xmm9
	.cfi_restore 26
        vmovups   96(%rsp), %xmm10
	.cfi_restore 27
        vmovups   80(%rsp), %xmm11
	.cfi_restore 28
        vmovups   48(%rsp), %xmm12
	.cfi_restore 29
        vmovups   144(%rsp), %xmm13
	.cfi_restore 30
        vmovups   32(%rsp), %xmm14
	.cfi_restore 31
        vmovups   16(%rsp), %xmm15
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
        vmovsd    %xmm9, 64(%rsp)
        vmovsd    %xmm0, 128(%rsp)
        jne       ..B1.6
..B1.4:
        vmovsd    128(%rsp), %xmm0
        jmp       ..B1.2
..B1.6:
        lea       (%rsp), %rdi
        lea       64(%rsp), %rsi
        lea       128(%rsp), %rdx
        call      __svml_dhypot_ha_cout_rare_internal
        jmp       ..B1.4
END(hypot_avx2)
	.data
	.hidden __svml_dhypot_ha_data_internal
	.hidden __svml_dhypot_ha_cout_rare_internal
	.section .note.GNU-stack, ""
# End
