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
ENTRY(cos_avx2)
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
        lea       __svml_dcos_ha_data_internal_ha(%rip), %rdx
        vmovups   %xmm8, 144(%rsp)
        vmovapd   %xmm0, %xmm8
        vmovsd    16640+__svml_dcos_ha_data_internal_ha(%rip), %xmm6
        xorl      %eax, %eax
        vfmadd132sd 16576+__svml_dcos_ha_data_internal_ha(%rip), %xmm6, %xmm8
        vmovsd    16832+__svml_dcos_ha_data_internal_ha(%rip), %xmm3
        vmovq     16704+__svml_dcos_ha_data_internal_ha(%rip), %xmm4
        vmovups   %xmm10, 112(%rsp)
        vmovups   %xmm9, 96(%rsp)
        vmovsd    16384+__svml_dcos_ha_data_internal_ha(%rip), %xmm1
        vsubsd    %xmm6, %xmm8, %xmm6
        vmovapd   %xmm6, %xmm5
        vmovapd   %xmm6, %xmm7
        vfnmadd132sd 16768+__svml_dcos_ha_data_internal_ha(%rip), %xmm0, %xmm5
        vmovapd   %xmm6, %xmm10
        vpand     %xmm4, %xmm8, %xmm8
        vandpd    %xmm1, %xmm0, %xmm2
        vcmpnlesd 16448+__svml_dcos_ha_data_internal_ha(%rip), %xmm2, %xmm1
        vmovd     %xmm8, %ecx
        vfnmadd213sd %xmm5, %xmm3, %xmm7
        vmovmskpd %xmm1, %r8d
        vmovapd   %xmm7, %xmm4
        vsubsd    %xmm7, %xmm5, %xmm5
        vfnmadd213sd %xmm5, %xmm3, %xmm10
        shll      $5, %ecx
        vfnmadd132sd 16896+__svml_dcos_ha_data_internal_ha(%rip), %xmm10, %xmm6
        vmovapd   %xmm7, %xmm10
        vmovq     16(%rdx,%rcx), %xmm5
        vmovq     (%rcx,%rdx), %xmm3
        vmovdqa   %xmm3, %xmm8
        vfmadd132sd 8(%rdx,%rcx), %xmm5, %xmm10
        vfmadd213sd %xmm10, %xmm7, %xmm8
        vsubsd    %xmm10, %xmm5, %xmm9
        vfmadd132sd 8(%rdx,%rcx), %xmm9, %xmm4
        vsubsd    %xmm8, %xmm10, %xmm9
        vmovdqa   %xmm3, %xmm10
        vaddsd    8(%rdx,%rcx), %xmm3, %xmm3
        vfmadd213sd %xmm9, %xmm7, %xmm10
        vaddsd    %xmm4, %xmm10, %xmm9
        vmulsd    %xmm7, %xmm7, %xmm4
        vmovsd    17024+__svml_dcos_ha_data_internal_ha(%rip), %xmm10
        vfmadd213sd 16960+__svml_dcos_ha_data_internal_ha(%rip), %xmm4, %xmm10
        vmulsd    %xmm4, %xmm10, %xmm10
        vmulsd    %xmm7, %xmm10, %xmm10
        vfnmadd213sd %xmm3, %xmm5, %xmm7
        vfmadd213sd %xmm9, %xmm3, %xmm10
        vmovsd    17216+__svml_dcos_ha_data_internal_ha(%rip), %xmm9
        vfmadd213sd 17152+__svml_dcos_ha_data_internal_ha(%rip), %xmm4, %xmm9
        vfmadd213sd 24(%rdx,%rcx), %xmm7, %xmm6
        vfmadd213sd 17088+__svml_dcos_ha_data_internal_ha(%rip), %xmm4, %xmm9
        vmulsd    %xmm4, %xmm9, %xmm4
        vfmadd213sd %xmm10, %xmm5, %xmm4
        vaddsd    %xmm6, %xmm4, %xmm7
        vaddsd    %xmm7, %xmm8, %xmm3
        testl     $1, %r8d
        jne       ..B1.8
..B1.2:
        testl     %eax, %eax
        jne       ..B1.4
..B1.3:
        vmovups   144(%rsp), %xmm8
	.cfi_restore 25
        vmovapd   %xmm3, %xmm0
        vmovups   96(%rsp), %xmm9
	.cfi_restore 26
        vmovups   112(%rsp), %xmm10
	.cfi_restore 27
        movq      %rbp, %rsp
        popq      %rbp
	.cfi_def_cfa 7, 8
	.cfi_restore 6
        ret
	.cfi_def_cfa 6, 16
	.cfi_offset 6, -16
..B1.4:
        vmovsd    %xmm0, 128(%rsp)
        vmovsd    %xmm3, 192(%rsp)
        jne       ..B1.6
..B1.5:
        vmovsd    192(%rsp), %xmm3
        jmp       ..B1.3
..B1.6:
        je        ..B1.5
..B1.7:
        movq      %rsi, 8(%rsp)
        lea       192(%rsp), %rsi
        movq      %rdi, (%rsp)
        lea       128(%rsp), %rdi
        vmovups   %xmm11, -112(%rsi)
        vmovups   %xmm12, -128(%rsi)
        vmovups   %xmm13, -80(%rdi)
        vmovups   %xmm14, -96(%rdi)
        vmovups   %xmm15, -112(%rdi)
        call      __svml_dcos_ha_cout_rare_internal
..B1.11:
        vmovups   80(%rsp), %xmm11
	.cfi_restore 28
        vmovups   64(%rsp), %xmm12
	.cfi_restore 29
        vmovups   48(%rsp), %xmm13
	.cfi_restore 30
        vmovups   32(%rsp), %xmm14
	.cfi_restore 31
        vmovups   16(%rsp), %xmm15
	.cfi_restore 32
        movq      8(%rsp), %rsi
	.cfi_restore 4
        movq      (%rsp), %rdi
	.cfi_restore 5
        jmp       ..B1.5
..B1.8:
        vpand     .L_2il0floatpacket.16(%rip), %xmm0, %xmm10
        lea       __svml_dcos_ha_reduction_data_internal(%rip), %r9
        vmovups   %xmm12, 64(%rsp)
        vpsrlq    $52, %xmm10, %xmm12
        vmovd     %xmm12, %ecx
        vmovups   %xmm14, 32(%rsp)
        vmovsd    16512+__svml_dcos_ha_data_internal_ha(%rip), %xmm14
        vandpd    %xmm2, %xmm14, %xmm9
        vmovups   %xmm11, 80(%rsp)
        lea       (%rcx,%rcx,2), %r8d
        vpand     .L_2il0floatpacket.17(%rip), %xmm0, %xmm6
        vcmpeqsd  %xmm14, %xmm9, %xmm11
        vpaddq    .L_2il0floatpacket.18(%rip), %xmm6, %xmm4
        vmovmskpd %xmm11, %eax
        vmovups   %xmm13, 48(%rsp)
        vpsrlq    $32, %xmm4, %xmm11
        vmovdqu   .L_2il0floatpacket.19(%rip), %xmm14
        shll      $3, %r8d
        andl      $1, %eax
        vmovq     8(%r9,%r8), %xmm8
        vmovq     16(%r9,%r8), %xmm13
        vpsrlq    $32, %xmm8, %xmm7
        vmovupd   %xmm1, (%rsp)
        vpand     %xmm14, %xmm8, %xmm1
        vpsrlq    $32, %xmm13, %xmm2
        vpand     %xmm14, %xmm4, %xmm8
        vpand     %xmm14, %xmm13, %xmm13
        vpmuludq  %xmm13, %xmm11, %xmm5
        vpmuludq  %xmm2, %xmm11, %xmm13
        vpmuludq  %xmm2, %xmm8, %xmm2
        vpmuludq  %xmm1, %xmm8, %xmm4
        vpmuludq  %xmm1, %xmm11, %xmm1
        vpmuludq  %xmm7, %xmm8, %xmm6
        vpmuludq  %xmm7, %xmm11, %xmm7
        vpsrlq    $32, %xmm2, %xmm2
        vpsrlq    $32, %xmm5, %xmm5
        vpaddq    %xmm2, %xmm13, %xmm13
        vmovups   %xmm15, 16(%rsp)
        vpand     %xmm14, %xmm4, %xmm15
        vpaddq    %xmm13, %xmm15, %xmm15
        vpsrlq    $32, %xmm4, %xmm4
        vmovq     (%r8,%r9), %xmm12
        vpaddq    %xmm4, %xmm1, %xmm2
        vpaddq    %xmm15, %xmm5, %xmm13
        vpand     %xmm14, %xmm12, %xmm10
        vpand     %xmm14, %xmm6, %xmm15
        vpmuludq  %xmm10, %xmm8, %xmm9
        vpsrlq    $32, %xmm13, %xmm5
        vpmuludq  %xmm10, %xmm11, %xmm11
        vpaddq    %xmm2, %xmm15, %xmm15
        vpsrlq    $32, %xmm12, %xmm12
        vpand     %xmm14, %xmm9, %xmm1
        vpaddq    %xmm15, %xmm5, %xmm5
        vpmuludq  %xmm12, %xmm8, %xmm8
        vpsrlq    $32, %xmm6, %xmm15
        vpsrlq    $32, %xmm9, %xmm9
        vpaddq    %xmm15, %xmm7, %xmm6
        vpaddq    %xmm9, %xmm11, %xmm10
        vpaddq    %xmm6, %xmm1, %xmm4
        vpsrlq    $32, %xmm5, %xmm2
        vpand     %xmm14, %xmm8, %xmm1
        vpaddq    %xmm4, %xmm2, %xmm4
        vpaddq    %xmm10, %xmm1, %xmm9
        vpsrlq    $32, %xmm4, %xmm7
        vpsllq    $32, %xmm5, %xmm5
        vpaddq    %xmm9, %xmm7, %xmm2
        vpsllq    $32, %xmm2, %xmm7
        vpand     %xmm14, %xmm4, %xmm9
        vpaddq    %xmm9, %xmm7, %xmm6
        vpand     .L_2il0floatpacket.20(%rip), %xmm0, %xmm8
        vpand     %xmm14, %xmm13, %xmm13
        vpaddq    %xmm13, %xmm5, %xmm12
        vpxor     .L_2il0floatpacket.21(%rip), %xmm8, %xmm13
        vpsrlq    $12, %xmm6, %xmm14
        vmovupd   .L_2il0floatpacket.22(%rip), %xmm9
        vpor      %xmm13, %xmm14, %xmm5
        vpand     .L_2il0floatpacket.26(%rip), %xmm6, %xmm6
        vaddsd    %xmm5, %xmm9, %xmm11
        vpand     .L_2il0floatpacket.24(%rip), %xmm12, %xmm15
        vpsllq    $40, %xmm6, %xmm7
        vpsrlq    $24, %xmm12, %xmm12
        vpsllq    $28, %xmm15, %xmm1
        vpxor     .L_2il0floatpacket.23(%rip), %xmm8, %xmm4
        vsubsd    %xmm9, %xmm11, %xmm14
        vpxor     .L_2il0floatpacket.25(%rip), %xmm8, %xmm9
        vpor      %xmm12, %xmm7, %xmm8
        vpor      %xmm9, %xmm8, %xmm13
        vpor      %xmm4, %xmm1, %xmm2
        vmovupd   .L_2il0floatpacket.30(%rip), %xmm1
        vsubsd    %xmm14, %xmm5, %xmm10
        vsubsd    %xmm9, %xmm13, %xmm5
        vsubsd    %xmm4, %xmm2, %xmm15
        vaddsd    %xmm5, %xmm10, %xmm14
        vmovapd   %xmm14, %xmm9
        vsubsd    %xmm14, %xmm10, %xmm10
        vandps    .L_2il0floatpacket.31(%rip), %xmm11, %xmm11
        vaddsd    %xmm10, %xmm5, %xmm13
        vmovd     %xmm11, %r10d
        vmovupd   .L_2il0floatpacket.27(%rip), %xmm5
        vaddsd    %xmm15, %xmm13, %xmm12
        vmulsd    %xmm5, %xmm14, %xmm4
        vfmsub213sd %xmm4, %xmm5, %xmm9
        vandpd    .L_2il0floatpacket.29(%rip), %xmm0, %xmm15
        vcmpgtsd  %xmm1, %xmm15, %xmm8
        vcmplesd  %xmm1, %xmm15, %xmm2
        vfmadd132sd .L_2il0floatpacket.28(%rip), %xmm9, %xmm14
        vandpd    %xmm0, %xmm2, %xmm6
        vandpd    %xmm4, %xmm8, %xmm7
        vorpd     %xmm7, %xmm6, %xmm9
        shll      $5, %r10d
        vmovapd   %xmm9, %xmm2
        vfmadd213sd %xmm14, %xmm5, %xmm12
        vmovapd   %xmm9, %xmm7
        vmovq     16(%rdx,%r10), %xmm14
        vmovq     (%r10,%rdx), %xmm15
        vmovdqa   %xmm15, %xmm13
        vmovdqa   %xmm15, %xmm6
        vfmadd132sd 8(%rdx,%r10), %xmm14, %xmm2
        vandpd    %xmm12, %xmm8, %xmm5
        vmovsd    17024+__svml_dcos_ha_data_internal_ha(%rip), %xmm8
        vmulsd    %xmm9, %xmm9, %xmm12
        vfmadd213sd %xmm2, %xmm9, %xmm13
        vsubsd    %xmm2, %xmm14, %xmm1
        vfmadd213sd 16960+__svml_dcos_ha_data_internal_ha(%rip), %xmm12, %xmm8
        vfmadd132sd 8(%rdx,%r10), %xmm1, %xmm7
        vsubsd    %xmm13, %xmm2, %xmm4
        vaddsd    8(%rdx,%r10), %xmm15, %xmm2
        vmulsd    %xmm12, %xmm8, %xmm10
        vfmadd213sd %xmm4, %xmm9, %xmm6
        vmovsd    17216+__svml_dcos_ha_data_internal_ha(%rip), %xmm15
        vfmadd213sd 17152+__svml_dcos_ha_data_internal_ha(%rip), %xmm12, %xmm15
        vmulsd    %xmm9, %xmm10, %xmm1
        vaddsd    %xmm7, %xmm6, %xmm11
        vfnmadd213sd %xmm2, %xmm14, %xmm9
        vfmadd213sd 17088+__svml_dcos_ha_data_internal_ha(%rip), %xmm12, %xmm15
        vfmadd213sd %xmm11, %xmm2, %xmm1
        vfmadd213sd 24(%rdx,%r10), %xmm9, %xmm5
        vmovups   80(%rsp), %xmm11
	.cfi_restore 28
        vmulsd    %xmm12, %xmm15, %xmm4
        vfmadd213sd %xmm1, %xmm14, %xmm4
        vmovups   64(%rsp), %xmm12
	.cfi_restore 29
        vmovups   32(%rsp), %xmm14
	.cfi_restore 31
        vmovups   16(%rsp), %xmm15
	.cfi_restore 32
        vaddsd    %xmm5, %xmm4, %xmm5
        vaddsd    %xmm5, %xmm13, %xmm9
        vmovupd   (%rsp), %xmm13
        vblendvpd %xmm13, %xmm9, %xmm3, %xmm3
        vmovups   48(%rsp), %xmm13
	.cfi_restore 30
        jmp       ..B1.2
END(cos_avx2)
# -- End  __svml_cos1_ha_l9
	.section .rodata, "a"
	.align 16
	.align 16
.L_2il0floatpacket.16:
	.long	0x00000000,0x7ff00000,0x00000000,0x7ff00000
	.type	.L_2il0floatpacket.16,@object
	.size	.L_2il0floatpacket.16,16
	.align 16
.L_2il0floatpacket.17:
	.long	0xffffffff,0x000fffff,0xffffffff,0x000fffff
	.type	.L_2il0floatpacket.17,@object
	.size	.L_2il0floatpacket.17,16
	.align 16
.L_2il0floatpacket.18:
	.long	0x00000000,0x00100000,0x00000000,0x00100000
	.type	.L_2il0floatpacket.18,@object
	.size	.L_2il0floatpacket.18,16
	.align 16
.L_2il0floatpacket.19:
	.long	0xffffffff,0x00000000,0xffffffff,0x00000000
	.type	.L_2il0floatpacket.19,@object
	.size	.L_2il0floatpacket.19,16
	.align 16
.L_2il0floatpacket.20:
	.long	0x00000000,0x80000000,0x00000000,0x80000000
	.type	.L_2il0floatpacket.20,@object
	.size	.L_2il0floatpacket.20,16
	.align 16
.L_2il0floatpacket.21:
	.long	0x00000000,0x3ff00000,0x00000000,0x3ff00000
	.type	.L_2il0floatpacket.21,@object
	.size	.L_2il0floatpacket.21,16
	.align 16
.L_2il0floatpacket.22:
	.long	0x00000000,0x42a80000,0x00000000,0x42a80000
	.type	.L_2il0floatpacket.22,@object
	.size	.L_2il0floatpacket.22,16
	.align 16
.L_2il0floatpacket.23:
	.long	0x00000000,0x39700000,0x00000000,0x39700000
	.type	.L_2il0floatpacket.23,@object
	.size	.L_2il0floatpacket.23,16
	.align 16
.L_2il0floatpacket.24:
	.long	0x00ffffff,0x00000000,0x00ffffff,0x00000000
	.type	.L_2il0floatpacket.24,@object
	.size	.L_2il0floatpacket.24,16
	.align 16
.L_2il0floatpacket.25:
	.long	0x00000000,0x3cb00000,0x00000000,0x3cb00000
	.type	.L_2il0floatpacket.25,@object
	.size	.L_2il0floatpacket.25,16
	.align 16
.L_2il0floatpacket.26:
	.long	0x00000fff,0x00000000,0x00000fff,0x00000000
	.type	.L_2il0floatpacket.26,@object
	.size	.L_2il0floatpacket.26,16
	.align 16
.L_2il0floatpacket.27:
	.long	0x54442d18,0x401921fb,0x54442d18,0x401921fb
	.type	.L_2il0floatpacket.27,@object
	.size	.L_2il0floatpacket.27,16
	.align 16
.L_2il0floatpacket.28:
	.long	0x33145c07,0x3cb1a626,0x33145c07,0x3cb1a626
	.type	.L_2il0floatpacket.28,@object
	.size	.L_2il0floatpacket.28,16
	.align 16
.L_2il0floatpacket.29:
	.long	0xffffffff,0x7fffffff,0xffffffff,0x7fffffff
	.type	.L_2il0floatpacket.29,@object
	.size	.L_2il0floatpacket.29,16
	.align 16
.L_2il0floatpacket.30:
	.long	0x00000000,0x3eb00000,0x00000000,0x3eb00000
	.type	.L_2il0floatpacket.30,@object
	.size	.L_2il0floatpacket.30,16
	.align 16
.L_2il0floatpacket.31:
	.long	0x000001ff,0x00000000,0x000001ff,0x00000000
	.type	.L_2il0floatpacket.31,@object
	.size	.L_2il0floatpacket.31,16
	.data
	.hidden __svml_dcos_ha_reduction_data_internal
	.hidden __svml_dcos_ha_data_internal_ha
	.hidden __svml_dcos_ha_cout_rare_internal
	.section .note.GNU-stack, ""
# End
