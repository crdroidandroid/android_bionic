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
ENTRY(sin_avx2)
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
        lea       __svml_dsin_ha_data_internal_ha(%rip), %rdx
        vmovsd    16384+__svml_dsin_ha_data_internal_ha(%rip), %xmm2
        xorl      %eax, %eax
        vandnpd   %xmm0, %xmm2, %xmm1
        vandpd    %xmm2, %xmm0, %xmm2
        vmovups   %xmm8, 176(%rsp)
        vmovapd   %xmm2, %xmm8
        vmovsd    16640+__svml_dsin_ha_data_internal_ha(%rip), %xmm6
        vfmadd132sd 16576+__svml_dsin_ha_data_internal_ha(%rip), %xmm6, %xmm8
        vmovsd    16832+__svml_dsin_ha_data_internal_ha(%rip), %xmm3
        vmovq     16704+__svml_dsin_ha_data_internal_ha(%rip), %xmm4
        vmovups   %xmm15, 160(%rsp)
        vmovups   %xmm14, 144(%rsp)
        vsubsd    %xmm6, %xmm8, %xmm6
        vpand     %xmm4, %xmm8, %xmm8
        vmovd     %xmm8, %ecx
        vmovapd   %xmm6, %xmm5
        vmovapd   %xmm6, %xmm7
        vfnmadd132sd 16768+__svml_dsin_ha_data_internal_ha(%rip), %xmm2, %xmm5
        vmovapd   %xmm6, %xmm15
        vfnmadd213sd %xmm5, %xmm3, %xmm7
        shll      $5, %ecx
        vmovapd   %xmm7, %xmm4
        vsubsd    %xmm7, %xmm5, %xmm5
        vfnmadd213sd %xmm5, %xmm3, %xmm15
        vmovq     16(%rdx,%rcx), %xmm5
        vmovq     (%rcx,%rdx), %xmm3
        vmovdqa   %xmm3, %xmm8
        vfnmadd132sd 16896+__svml_dsin_ha_data_internal_ha(%rip), %xmm15, %xmm6
        vmovapd   %xmm7, %xmm15
        vfmadd132sd 8(%rdx,%rcx), %xmm5, %xmm15
        vfmadd213sd %xmm15, %xmm7, %xmm8
        vsubsd    %xmm15, %xmm5, %xmm14
        vfmadd132sd 8(%rdx,%rcx), %xmm14, %xmm4
        vsubsd    %xmm8, %xmm15, %xmm14
        vmovdqa   %xmm3, %xmm15
        vaddsd    8(%rdx,%rcx), %xmm3, %xmm3
        vfmadd213sd %xmm14, %xmm7, %xmm15
        vaddsd    %xmm4, %xmm15, %xmm14
        vmulsd    %xmm7, %xmm7, %xmm4
        vmovsd    17024+__svml_dsin_ha_data_internal_ha(%rip), %xmm15
        vfmadd213sd 16960+__svml_dsin_ha_data_internal_ha(%rip), %xmm4, %xmm15
        vmulsd    %xmm4, %xmm15, %xmm15
        vmulsd    %xmm7, %xmm15, %xmm15
        vfnmadd213sd %xmm3, %xmm5, %xmm7
        vfmadd213sd %xmm14, %xmm3, %xmm15
        vmovsd    17216+__svml_dsin_ha_data_internal_ha(%rip), %xmm14
        vfmadd213sd 17152+__svml_dsin_ha_data_internal_ha(%rip), %xmm4, %xmm14
        vfmadd213sd 24(%rdx,%rcx), %xmm7, %xmm6
        vfmadd213sd 17088+__svml_dsin_ha_data_internal_ha(%rip), %xmm4, %xmm14
        vmulsd    %xmm4, %xmm14, %xmm4
        vfmadd213sd %xmm15, %xmm5, %xmm4
        vaddsd    %xmm6, %xmm4, %xmm7
        vcmpnlesd 16448+__svml_dsin_ha_data_internal_ha(%rip), %xmm2, %xmm4
        vaddsd    %xmm7, %xmm8, %xmm3
        vmovmskpd %xmm4, %r8d
        vxorpd    %xmm1, %xmm3, %xmm3
        testl     $1, %r8d
        jne       ..B1.8
..B1.2:
        testl     %eax, %eax
        jne       ..B1.4
..B1.3:
        vmovups   176(%rsp), %xmm8
	.cfi_restore 25
        vmovapd   %xmm3, %xmm0
        vmovups   144(%rsp), %xmm14
	.cfi_restore 31
        vmovups   160(%rsp), %xmm15
	.cfi_restore 32
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
        vmovups   %xmm9, -112(%rsi)
        vmovups   %xmm10, -128(%rsi)
        vmovups   %xmm11, -80(%rdi)
        vmovups   %xmm12, -96(%rdi)
        vmovups   %xmm13, -112(%rdi)
        call      __svml_dsin_ha_cout_rare_internal
..B1.11:
        vmovups   80(%rsp), %xmm9
	.cfi_restore 26
        vmovups   64(%rsp), %xmm10
	.cfi_restore 27
        vmovups   48(%rsp), %xmm11
	.cfi_restore 28
        vmovups   32(%rsp), %xmm12
	.cfi_restore 29
        vmovups   16(%rsp), %xmm13
	.cfi_restore 30
        movq      8(%rsp), %rsi
	.cfi_restore 4
        movq      (%rsp), %rdi
	.cfi_restore 5
        jmp       ..B1.5
..B1.8:
        vmovups   %xmm10, 64(%rsp)
        lea       __svml_dsin_ha_reduction_data_internal(%rip), %r9
        vpand     .L_2il0floatpacket.16(%rip), %xmm2, %xmm10
        vpsrlq    $52, %xmm10, %xmm14
        vmovups   %xmm12, 32(%rsp)
        vmovd     %xmm14, %ecx
        vmovsd    16512+__svml_dsin_ha_data_internal_ha(%rip), %xmm12
        vpand     .L_2il0floatpacket.17(%rip), %xmm2, %xmm8
        vandpd    %xmm2, %xmm12, %xmm15
        vmovups   %xmm9, 80(%rsp)
        vpaddq    .L_2il0floatpacket.18(%rip), %xmm8, %xmm9
        vmovups   %xmm13, 16(%rsp)
        lea       (%rcx,%rcx,2), %r8d
        shll      $3, %r8d
        vpsrlq    $32, %xmm9, %xmm10
        vmovq     16(%r9,%r8), %xmm6
        vcmpeqsd  %xmm12, %xmm15, %xmm13
        vmovdqu   .L_2il0floatpacket.19(%rip), %xmm15
        vmovupd   %xmm1, 96(%rsp)
        vpsrlq    $32, %xmm6, %xmm1
        vpand     %xmm15, %xmm6, %xmm6
        vpand     %xmm15, %xmm9, %xmm9
        vpmuludq  %xmm6, %xmm10, %xmm6
        vmovmskpd %xmm13, %eax
        vmovq     8(%r9,%r8), %xmm7
        vpsrlq    $32, %xmm6, %xmm12
        vpmuludq  %xmm1, %xmm10, %xmm6
        vpsrlq    $32, %xmm7, %xmm8
        vpmuludq  %xmm1, %xmm9, %xmm1
        vmovupd   %xmm4, 112(%rsp)
        vpand     %xmm15, %xmm7, %xmm4
        vpmuludq  %xmm4, %xmm9, %xmm5
        vpsrlq    $32, %xmm1, %xmm1
        vpmuludq  %xmm4, %xmm10, %xmm4
        vpmuludq  %xmm8, %xmm9, %xmm7
        vpmuludq  %xmm8, %xmm10, %xmm8
        vpaddq    %xmm1, %xmm6, %xmm6
        vmovups   %xmm11, 48(%rsp)
        vpand     %xmm15, %xmm7, %xmm1
        vmovq     (%r8,%r9), %xmm11
        vpsrlq    $32, %xmm7, %xmm7
        vmovupd   %xmm0, (%rsp)
        vpand     %xmm15, %xmm5, %xmm0
        vpand     %xmm15, %xmm11, %xmm14
        vpsrlq    $32, %xmm5, %xmm5
        vpaddq    %xmm6, %xmm0, %xmm6
        vpaddq    %xmm5, %xmm4, %xmm4
        vpaddq    %xmm6, %xmm12, %xmm12
        vpaddq    %xmm4, %xmm1, %xmm4
        vpaddq    %xmm7, %xmm8, %xmm8
        vpmuludq  %xmm14, %xmm9, %xmm13
        vpmuludq  %xmm14, %xmm10, %xmm10
        vpsrlq    $32, %xmm11, %xmm11
        vpsrlq    $32, %xmm12, %xmm6
        vpmuludq  %xmm11, %xmm9, %xmm1
        vpand     %xmm15, %xmm13, %xmm5
        vpaddq    %xmm4, %xmm6, %xmm6
        vpaddq    %xmm8, %xmm5, %xmm8
        vpsrlq    $32, %xmm13, %xmm13
        vpsrlq    $32, %xmm6, %xmm4
        vpaddq    %xmm13, %xmm10, %xmm13
        vpaddq    %xmm8, %xmm4, %xmm8
        vpand     %xmm15, %xmm1, %xmm1
        vpsrlq    $32, %xmm8, %xmm7
        vpaddq    %xmm13, %xmm1, %xmm13
        vpaddq    %xmm13, %xmm7, %xmm13
        vpsllq    $32, %xmm13, %xmm13
        vpand     %xmm15, %xmm8, %xmm10
        vpaddq    %xmm10, %xmm13, %xmm10
        vpand     .L_2il0floatpacket.20(%rip), %xmm2, %xmm14
        vpsllq    $32, %xmm6, %xmm6
        vpand     %xmm15, %xmm12, %xmm15
        andl      $1, %eax
        vpaddq    %xmm15, %xmm6, %xmm12
        vpxor     .L_2il0floatpacket.21(%rip), %xmm14, %xmm6
        vpsrlq    $12, %xmm10, %xmm15
        vpor      %xmm6, %xmm15, %xmm6
        vmovupd   .L_2il0floatpacket.22(%rip), %xmm15
        vpxor     .L_2il0floatpacket.23(%rip), %xmm14, %xmm1
        vaddsd    %xmm6, %xmm15, %xmm13
        vpand     .L_2il0floatpacket.26(%rip), %xmm10, %xmm10
        vsubsd    %xmm15, %xmm13, %xmm15
        vpsllq    $40, %xmm10, %xmm10
        vsubsd    %xmm15, %xmm6, %xmm6
        vpand     .L_2il0floatpacket.24(%rip), %xmm12, %xmm15
        vpsrlq    $24, %xmm12, %xmm12
        vpsllq    $28, %xmm15, %xmm15
        vpor      %xmm12, %xmm10, %xmm12
        vpor      %xmm1, %xmm15, %xmm15
        vmovupd   (%rsp), %xmm0
        vsubsd    %xmm1, %xmm15, %xmm15
        vpxor     .L_2il0floatpacket.25(%rip), %xmm14, %xmm1
        vpor      %xmm1, %xmm12, %xmm12
        vmovups   64(%rsp), %xmm10
	.cfi_restore 27
        vsubsd    %xmm1, %xmm12, %xmm12
        vmovups   48(%rsp), %xmm11
	.cfi_restore 28
        vaddsd    %xmm12, %xmm6, %xmm5
        vmovapd   %xmm5, %xmm4
        vsubsd    %xmm5, %xmm6, %xmm6
        vaddsd    %xmm6, %xmm12, %xmm6
        vaddsd    %xmm15, %xmm6, %xmm7
        vmovupd   .L_2il0floatpacket.27(%rip), %xmm15
        vmulsd    %xmm15, %xmm5, %xmm12
        vfmsub213sd %xmm12, %xmm15, %xmm4
        vmovupd   .L_2il0floatpacket.30(%rip), %xmm6
        vfmadd132sd .L_2il0floatpacket.28(%rip), %xmm4, %xmm5
        vfmadd213sd %xmm5, %xmm15, %xmm7
        vandpd    .L_2il0floatpacket.29(%rip), %xmm2, %xmm15
        vcmpgtsd  %xmm6, %xmm15, %xmm4
        vcmplesd  %xmm6, %xmm15, %xmm15
        vandpd    %xmm2, %xmm15, %xmm2
        vandpd    %xmm12, %xmm4, %xmm15
        vorpd     %xmm15, %xmm2, %xmm6
        vandpd    %xmm7, %xmm4, %xmm12
        vandps    .L_2il0floatpacket.31(%rip), %xmm13, %xmm15
        vmovapd   %xmm6, %xmm8
        vmovd     %xmm15, %r10d
        vmovapd   %xmm6, %xmm14
        vmovups   16(%rsp), %xmm13
	.cfi_restore 30
        vmulsd    %xmm6, %xmm6, %xmm7
        shll      $5, %r10d
        vmovq     16(%rdx,%r10), %xmm2
        vfmadd132sd 8(%rdx,%r10), %xmm2, %xmm8
        vmovq     (%r10,%rdx), %xmm4
        vmovdqa   %xmm4, %xmm15
        vmovdqa   %xmm4, %xmm9
        vaddsd    8(%rdx,%r10), %xmm4, %xmm4
        vfmadd213sd %xmm8, %xmm6, %xmm15
        vsubsd    %xmm8, %xmm2, %xmm1
        vfmadd132sd 8(%rdx,%r10), %xmm1, %xmm14
        vsubsd    %xmm15, %xmm8, %xmm1
        vfmadd213sd %xmm1, %xmm6, %xmm9
        vmovsd    17024+__svml_dsin_ha_data_internal_ha(%rip), %xmm1
        vfmadd213sd 16960+__svml_dsin_ha_data_internal_ha(%rip), %xmm7, %xmm1
        vaddsd    %xmm14, %xmm9, %xmm5
        vmovups   80(%rsp), %xmm9
	.cfi_restore 26
        vmulsd    %xmm7, %xmm1, %xmm1
        vmulsd    %xmm6, %xmm1, %xmm1
        vfnmadd213sd %xmm4, %xmm2, %xmm6
        vfmadd213sd %xmm5, %xmm4, %xmm1
        vmovsd    17216+__svml_dsin_ha_data_internal_ha(%rip), %xmm5
        vfmadd213sd 17152+__svml_dsin_ha_data_internal_ha(%rip), %xmm7, %xmm5
        vfmadd213sd 24(%rdx,%r10), %xmm6, %xmm12
        vfmadd213sd 17088+__svml_dsin_ha_data_internal_ha(%rip), %xmm7, %xmm5
        vmulsd    %xmm7, %xmm5, %xmm5
        vfmadd213sd %xmm1, %xmm2, %xmm5
        vmovupd   112(%rsp), %xmm2
        vaddsd    %xmm12, %xmm5, %xmm1
        vmovups   32(%rsp), %xmm12
	.cfi_restore 29
        vaddsd    %xmm1, %xmm15, %xmm1
        vxorpd    96(%rsp), %xmm1, %xmm1
        vblendvpd %xmm2, %xmm1, %xmm3, %xmm3
        jmp       ..B1.2
END(sin_avx2) 
	.data
# -- End  __svml_sin1_ha_l9
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
	.hidden __svml_dsin_ha_reduction_data_internal
	.hidden __svml_dsin_ha_data_internal_ha
	.hidden __svml_dsin_ha_cout_rare_internal
	.section .note.GNU-stack, ""
# End
