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

# -- Machine type EM64t
	.text
..TXTST0:
.L_2__routine_start___svml_dcbrt_ha_cout_rare_internal_0:
# -- Begin  __svml_dcbrt_ha_cout_rare_internal
	.text
       .align    16,0x90
	.hidden __svml_dcbrt_ha_cout_rare_internal
	.globl __svml_dcbrt_ha_cout_rare_internal
__svml_dcbrt_ha_cout_rare_internal:
# parameter 1: %rdi
# parameter 2: %rsi
..B1.1:
	.cfi_startproc
..L1:

        movq      %rsi, %r8
        movzwl    6(%rdi), %r9d
        andl      $32752, %r9d
        shrl      $4, %r9d
        movb      7(%rdi), %sil
        movsd     (%rdi), %xmm1
        cmpl      $2047, %r9d
        je        ..B1.9
..B1.2:
        ucomisd   432+_vmldCbrtHATab(%rip), %xmm1
        jp        ..B1.3
        je        ..B1.8
..B1.3:
        movb      %sil, %al
        lea       440+_vmldCbrtHATab(%rip), %rdx
        andb      $-128, %al
        andb      $127, %sil
        shrb      $7, %al
        xorl      %edi, %edi
        movsd     %xmm1, -56(%rsp)
        movzbl    %al, %ecx
        movb      %sil, -49(%rsp)
        movsd     (%rdx,%rcx,8), %xmm6
        testl     %r9d, %r9d
        jne       ..B1.5
..B1.4:
        movsd     -56(%rsp), %xmm0
        movl      $100, %edi
        mulsd     360+_vmldCbrtHATab(%rip), %xmm0
        movsd     %xmm0, -56(%rsp)
        jmp       ..B1.6
..B1.5:
        movsd     -56(%rsp), %xmm0
..B1.6:
        movzwl    -50(%rsp), %esi
        movl      $1431655766, %eax
        andl      $32752, %esi
        lea       _vmldCbrtHATab(%rip), %r11
        shrl      $4, %esi
        movsd     %xmm0, -40(%rsp)
        movsd     368+_vmldCbrtHATab(%rip), %xmm15
        imull     %esi
        movl      $1431655766, %eax
        lea       (%rdx,%rdx,2), %ecx
        negl      %ecx
        addl      %esi, %ecx
        subl      %ecx, %esi
        addl      %ecx, %ecx
        addl      $-1023, %esi
        imull     %esi
        sarl      $31, %esi
        subl      %esi, %edx
        addl      $1023, %edx
        subl      %edi, %edx
        movzwl    -34(%rsp), %edi
        andl      $2047, %edx
        andl      $-32753, %edi
        addl      $16368, %edi
        movw      %di, -34(%rsp)
        movsd     -40(%rsp), %xmm12
        movaps    %xmm12, %xmm7
        mulsd     376+_vmldCbrtHATab(%rip), %xmm7
        movsd     %xmm7, -32(%rsp)
        movsd     -32(%rsp), %xmm8
        movl      -36(%rsp), %r10d
        andl      $1048575, %r10d
        subsd     -40(%rsp), %xmm8
        movsd     %xmm8, -24(%rsp)
        movsd     -32(%rsp), %xmm10
        movsd     -24(%rsp), %xmm9
        shrl      $15, %r10d
        subsd     %xmm9, %xmm10
        movsd     %xmm10, -32(%rsp)
        movsd     -32(%rsp), %xmm11
        movsd     (%r11,%r10,8), %xmm5
        subsd     %xmm11, %xmm12
        movaps    %xmm5, %xmm13
        movaps    %xmm5, %xmm14
        mulsd     %xmm5, %xmm13
        movsd     %xmm12, -24(%rsp)
        movsd     -32(%rsp), %xmm3
        mulsd     %xmm13, %xmm3
        mulsd     %xmm3, %xmm14
        movsd     440+_vmldCbrtHATab(%rip), %xmm7
        movsd     -24(%rsp), %xmm4
        subsd     %xmm14, %xmm7
        mulsd     %xmm13, %xmm4
        mulsd     %xmm7, %xmm15
        mulsd     %xmm4, %xmm5
        movsd     %xmm15, -32(%rsp)
        movsd     -32(%rsp), %xmm0
        xorps     .L_2il0floatpacket.65(%rip), %xmm5
        subsd     %xmm7, %xmm0
        movsd     %xmm0, -24(%rsp)
        movsd     -32(%rsp), %xmm2
        movsd     -24(%rsp), %xmm1
        movsd     352+_vmldCbrtHATab(%rip), %xmm0
        subsd     %xmm1, %xmm2
        movsd     %xmm2, -32(%rsp)
        movsd     -32(%rsp), %xmm14
        movsd     256+_vmldCbrtHATab(%rip), %xmm8
        subsd     %xmm14, %xmm7
        movsd     %xmm7, -24(%rsp)
        movsd     -32(%rsp), %xmm1
        movsd     -24(%rsp), %xmm2
        movsd     256+_vmldCbrtHATab(%rip), %xmm10
        addsd     %xmm5, %xmm2
        movaps    %xmm1, %xmm5
        movslq    %ecx, %rcx
        addsd     %xmm2, %xmm5
        mulsd     %xmm5, %xmm0
        movq      440+_vmldCbrtHATab(%rip), %r9
        movq      %r9, -48(%rsp)
        shrq      $48, %r9
        addsd     344+_vmldCbrtHATab(%rip), %xmm0
        mulsd     %xmm5, %xmm0
        andl      $-32753, %r9d
        shll      $4, %edx
        addsd     336+_vmldCbrtHATab(%rip), %xmm0
        mulsd     %xmm5, %xmm0
        orl       %edx, %r9d
        movw      %r9w, -42(%rsp)
        addsd     328+_vmldCbrtHATab(%rip), %xmm0
        mulsd     %xmm5, %xmm0
        addsd     320+_vmldCbrtHATab(%rip), %xmm0
        mulsd     %xmm5, %xmm0
        addsd     312+_vmldCbrtHATab(%rip), %xmm0
        mulsd     %xmm5, %xmm0
        addsd     304+_vmldCbrtHATab(%rip), %xmm0
        mulsd     %xmm5, %xmm0
        addsd     296+_vmldCbrtHATab(%rip), %xmm0
        mulsd     %xmm5, %xmm0
        addsd     288+_vmldCbrtHATab(%rip), %xmm0
        mulsd     %xmm5, %xmm0
        addsd     280+_vmldCbrtHATab(%rip), %xmm0
        mulsd     %xmm5, %xmm0
        addsd     272+_vmldCbrtHATab(%rip), %xmm0
        mulsd     %xmm5, %xmm0
        movsd     256+_vmldCbrtHATab(%rip), %xmm5
        addsd     %xmm0, %xmm8
        movsd     %xmm8, -32(%rsp)
        movsd     -32(%rsp), %xmm9
        movsd     368+_vmldCbrtHATab(%rip), %xmm8
        subsd     %xmm9, %xmm10
        movsd     %xmm10, -24(%rsp)
        movsd     -32(%rsp), %xmm12
        movsd     -24(%rsp), %xmm11
        addsd     %xmm11, %xmm12
        movsd     %xmm12, -16(%rsp)
        movsd     -24(%rsp), %xmm13
        addsd     %xmm13, %xmm0
        movsd     %xmm0, -24(%rsp)
        movsd     -16(%rsp), %xmm15
        subsd     %xmm15, %xmm5
        movsd     %xmm5, -16(%rsp)
        movsd     -24(%rsp), %xmm7
        movsd     -16(%rsp), %xmm0
        addsd     %xmm0, %xmm7
        movsd     %xmm7, -16(%rsp)
        movaps    %xmm2, %xmm7
        movsd     -32(%rsp), %xmm14
        mulsd     %xmm14, %xmm8
        movsd     -16(%rsp), %xmm0
        movsd     %xmm8, -32(%rsp)
        movaps    %xmm1, %xmm8
        movsd     -32(%rsp), %xmm9
        subsd     %xmm14, %xmm9
        addsd     264+_vmldCbrtHATab(%rip), %xmm0
        movsd     %xmm9, -24(%rsp)
        movsd     -32(%rsp), %xmm11
        movsd     -24(%rsp), %xmm10
        subsd     %xmm10, %xmm11
        movsd     %xmm11, -32(%rsp)
        movsd     -32(%rsp), %xmm12
        subsd     %xmm12, %xmm14
        movaps    %xmm3, %xmm12
        movsd     %xmm14, -24(%rsp)
        movsd     -32(%rsp), %xmm13
        movsd     -24(%rsp), %xmm5
        mulsd     %xmm13, %xmm2
        addsd     %xmm0, %xmm5
        mulsd     %xmm13, %xmm8
        mulsd     %xmm5, %xmm7
        mulsd     %xmm5, %xmm1
        addsd     %xmm2, %xmm7
        addsd     %xmm1, %xmm7
        movsd     368+_vmldCbrtHATab(%rip), %xmm1
        mulsd     %xmm8, %xmm1
        movsd     %xmm7, -32(%rsp)
        movsd     -32(%rsp), %xmm7
        movsd     %xmm1, -32(%rsp)
        movsd     -32(%rsp), %xmm2
        subsd     %xmm8, %xmm2
        movsd     %xmm2, -24(%rsp)
        movsd     -32(%rsp), %xmm0
        movsd     -24(%rsp), %xmm15
        subsd     %xmm15, %xmm0
        movsd     %xmm0, -32(%rsp)
        movsd     -32(%rsp), %xmm1
        subsd     %xmm1, %xmm8
        movsd     %xmm8, -24(%rsp)
        movsd     -32(%rsp), %xmm5
        movsd     -24(%rsp), %xmm2
        movaps    %xmm5, %xmm1
        mulsd     %xmm4, %xmm5
        addsd     %xmm2, %xmm7
        mulsd     %xmm3, %xmm1
        movaps    %xmm7, %xmm9
        movaps    %xmm1, %xmm10
        mulsd     %xmm4, %xmm9
        addsd     %xmm3, %xmm10
        mulsd     %xmm3, %xmm7
        addsd     %xmm5, %xmm9
        addsd     %xmm7, %xmm9
        movsd     %xmm9, -32(%rsp)
        movsd     -32(%rsp), %xmm0
        movsd     %xmm10, -32(%rsp)
        movsd     -32(%rsp), %xmm11
        subsd     %xmm11, %xmm12
        movsd     %xmm12, -24(%rsp)
        movsd     -32(%rsp), %xmm14
        movsd     -24(%rsp), %xmm13
        addsd     %xmm13, %xmm14
        movsd     %xmm14, -16(%rsp)
        movsd     -24(%rsp), %xmm15
        addsd     %xmm15, %xmm1
        movsd     %xmm1, -24(%rsp)
        movsd     -16(%rsp), %xmm2
        subsd     %xmm2, %xmm3
        movsd     368+_vmldCbrtHATab(%rip), %xmm2
        movsd     %xmm3, -16(%rsp)
        movsd     -24(%rsp), %xmm1
        movsd     -16(%rsp), %xmm3
        addsd     %xmm3, %xmm1
        movsd     %xmm1, -16(%rsp)
        movsd     -32(%rsp), %xmm9
        mulsd     %xmm9, %xmm2
        movsd     -16(%rsp), %xmm11
        movsd     %xmm2, -32(%rsp)
        movsd     -32(%rsp), %xmm5
        movsd     384(%r11,%rcx,8), %xmm1
        subsd     %xmm9, %xmm5
        movsd     %xmm5, -24(%rsp)
        movsd     -32(%rsp), %xmm7
        movsd     -24(%rsp), %xmm3
        subsd     %xmm3, %xmm7
        movsd     %xmm7, -32(%rsp)
        movsd     -32(%rsp), %xmm8
        subsd     %xmm8, %xmm9
        movsd     %xmm9, -24(%rsp)
        movsd     -32(%rsp), %xmm12
        movsd     -24(%rsp), %xmm10
        movaps    %xmm12, %xmm3
        mulsd     %xmm1, %xmm3
        addsd     %xmm10, %xmm11
        addsd     %xmm11, %xmm0
        addsd     %xmm4, %xmm0
        movsd     392(%r11,%rcx,8), %xmm4
        movaps    %xmm4, %xmm2
        mulsd     %xmm0, %xmm2
        mulsd     %xmm12, %xmm4
        mulsd     %xmm1, %xmm0
        addsd     %xmm4, %xmm2
        addsd     %xmm0, %xmm2
        movsd     %xmm2, -32(%rsp)
        movsd     -32(%rsp), %xmm0
        addsd     %xmm3, %xmm0
        mulsd     -48(%rsp), %xmm0
        mulsd     %xmm0, %xmm6
        movsd     %xmm6, (%r8)
..B1.7:
        xorl      %eax, %eax
        ret
..B1.8:
        movsd     440+_vmldCbrtHATab(%rip), %xmm0
        mulsd     %xmm0, %xmm1
        movsd     %xmm1, (%r8)
        jmp       ..B1.7
..B1.9:
        addsd     %xmm1, %xmm1
        movsd     %xmm1, (%r8)
        jmp       ..B1.7
        .align    16,0x90
	.cfi_endproc
	.type	__svml_dcbrt_ha_cout_rare_internal,@function
	.size	__svml_dcbrt_ha_cout_rare_internal,.-__svml_dcbrt_ha_cout_rare_internal
..LN__svml_dcbrt_ha_cout_rare_internal.0:
	.data
# -- End  __svml_dcbrt_ha_cout_rare_internal
	.section .rodata, "a"
	.align 32
	.align 32
_vmldCbrtHATab:
	.long	0
	.long	1072693248
	.long	0
	.long	1072668672
	.long	0
	.long	1072644096
	.long	0
	.long	1072627712
	.long	0
	.long	1072611328
	.long	0
	.long	1072586752
	.long	0
	.long	1072570368
	.long	0
	.long	1072553984
	.long	0
	.long	1072537600
	.long	0
	.long	1072521216
	.long	0
	.long	1072504832
	.long	0
	.long	1072488448
	.long	0
	.long	1072480256
	.long	0
	.long	1072463872
	.long	0
	.long	1072447488
	.long	0
	.long	1072439296
	.long	0
	.long	1072422912
	.long	0
	.long	1072414720
	.long	0
	.long	1072398336
	.long	0
	.long	1072390144
	.long	0
	.long	1072373760
	.long	0
	.long	1072365568
	.long	0
	.long	1072357376
	.long	0
	.long	1072340992
	.long	0
	.long	1072332800
	.long	0
	.long	1072324608
	.long	0
	.long	1072308224
	.long	0
	.long	1072300032
	.long	0
	.long	1072291840
	.long	0
	.long	1072283648
	.long	0
	.long	1072275456
	.long	0
	.long	1072267264
	.long	1431655765
	.long	1071994197
	.long	1431655765
	.long	1015371093
	.long	1908874354
	.long	1071761180
	.long	1007461464
	.long	1071618781
	.long	565592401
	.long	1071446176
	.long	241555088
	.long	1071319599
	.long	943963244
	.long	1071221150
	.long	2330668378
	.long	1071141453
	.long	2770428108
	.long	1071075039
	.long	3622256836
	.long	1071018464
	.long	1497196870
	.long	1070969433
	.long	280472551
	.long	1070926345
	.long	1585032765
	.long	1070888044
	.long	0
	.long	1387266048
	.long	33554432
	.long	1101004800
	.long	512
	.long	1117782016
	.long	0
	.long	1072693248
	.long	0
	.long	0
	.long	4160749568
	.long	1072965794
	.long	2921479643
	.long	1043912488
	.long	2684354560
	.long	1073309182
	.long	4060791142
	.long	1045755320
	.long	0
	.long	0
	.long	0
	.long	1072693248
	.long	0
	.long	3220176896
	.type	_vmldCbrtHATab,@object
	.size	_vmldCbrtHATab,456
	.space 8, 0x00 	# pad
	.align 16
.L_2il0floatpacket.65:
	.long	0x00000000,0x80000000,0x00000000,0x00000000
	.type	.L_2il0floatpacket.65,@object
	.size	.L_2il0floatpacket.65,16
	.data
	.section .note.GNU-stack, ""
# End
