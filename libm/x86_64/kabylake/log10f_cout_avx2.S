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
.L_2__routine_start___svml_slog10_ha_cout_rare_internal_0:
# -- Begin  __svml_slog10_ha_cout_rare_internal
	.text
       .align    16,0x90
	.hidden __svml_slog10_ha_cout_rare_internal
	.globl __svml_slog10_ha_cout_rare_internal
__svml_slog10_ha_cout_rare_internal:
# parameter 1: %rdi
# parameter 2: %rsi
..B1.1:
       .cfi_startproc
..L1:

        movq      %rdi, %r8
        xorl      %eax, %eax
        xorl      %edi, %edi
        movzwl    2(%r8), %ecx
        movl      %ecx, %edx
        andl      $32640, %edx
        cmpl      $32640, %edx
        je        ..B1.12
..B1.2:
        movss     (%r8), %xmm1
        movss     %xmm1, -16(%rsp)
        testl     $32640, %ecx
        jne       ..B1.4
..B1.3:
        mulss     .L_2il0floatpacket.75(%rip), %xmm1
        movl      $-40, %edi
        movss     %xmm1, -16(%rsp)
..B1.4:
        pxor      %xmm0, %xmm0
        comiss    %xmm0, %xmm1
        jbe       ..B1.8
..B1.5:
        movaps    %xmm1, %xmm2
        subss     .L_2il0floatpacket.91(%rip), %xmm2
        movss     %xmm2, -20(%rsp)
        andb      $127, -17(%rsp)
        movss     -20(%rsp), %xmm0
        comiss    .L_2il0floatpacket.76(%rip), %xmm0
        jbe       ..B1.7
..B1.6:
        movzwl    -14(%rsp), %edx
        pxor      %xmm7, %xmm7
        andl      $32640, %edx
        lea       _vmldLgHATab(%rip), %r10
        shrl      $7, %edx
        movss     %xmm1, -20(%rsp)
        movss     .L_2il0floatpacket.80(%rip), %xmm3
        movaps    %xmm3, %xmm2
        movss     .L_2il0floatpacket.82(%rip), %xmm8
        lea       -127(%rdi,%rdx), %ecx
        movzwl    -18(%rsp), %edi
        andl      $-32641, %edi
        addl      $16256, %edi
        movw      %di, -18(%rsp)
        movss     -20(%rsp), %xmm4
        movaps    %xmm4, %xmm1
        addss     %xmm4, %xmm2
        addss     .L_2il0floatpacket.79(%rip), %xmm1
        cvtsi2ss  %ecx, %xmm7
        movss     %xmm1, -24(%rsp)
        movl      -24(%rsp), %r8d
        movss     %xmm2, -24(%rsp)
        andl      $127, %r8d
        movss     -24(%rsp), %xmm9
        movss     .L_2il0floatpacket.77(%rip), %xmm11
        subss     %xmm3, %xmm9
        mulss     %xmm7, %xmm11
        subss     %xmm9, %xmm4
        movss     .L_2il0floatpacket.78(%rip), %xmm0
        lea       (%r8,%r8,2), %r9d
        movss     (%r10,%r9,4), %xmm10
        mulss     %xmm10, %xmm9
        addss     4(%r10,%r9,4), %xmm11
        mulss     %xmm4, %xmm10
        mulss     %xmm0, %xmm7
        subss     .L_2il0floatpacket.81(%rip), %xmm9
        addss     8(%r10,%r9,4), %xmm7
        addss     %xmm9, %xmm11
        movaps    %xmm9, %xmm5
        movaps    %xmm10, %xmm6
        addss     %xmm10, %xmm5
        mulss     %xmm5, %xmm8
        addss     .L_2il0floatpacket.83(%rip), %xmm8
        mulss     %xmm5, %xmm8
        addss     .L_2il0floatpacket.84(%rip), %xmm8
        mulss     %xmm5, %xmm8
        addss     .L_2il0floatpacket.85(%rip), %xmm8
        mulss     %xmm5, %xmm8
        addss     .L_2il0floatpacket.86(%rip), %xmm8
        mulss     %xmm5, %xmm8
        addss     .L_2il0floatpacket.87(%rip), %xmm8
        mulss     %xmm5, %xmm8
        addss     .L_2il0floatpacket.88(%rip), %xmm8
        mulss     %xmm5, %xmm8
        addss     .L_2il0floatpacket.89(%rip), %xmm8
        mulss     %xmm8, %xmm6
        mulss     %xmm8, %xmm9
        addss     %xmm6, %xmm7
        addss     %xmm7, %xmm10
        addss     %xmm9, %xmm10
        addss     %xmm10, %xmm11
        movss     %xmm11, (%rsi)
        ret
..B1.7:
        movss     .L_2il0floatpacket.81(%rip), %xmm0
        mulss     %xmm0, %xmm2
        movss     .L_2il0floatpacket.82(%rip), %xmm1
        mulss     %xmm2, %xmm1
        addss     .L_2il0floatpacket.83(%rip), %xmm1
        mulss     %xmm2, %xmm1
        addss     .L_2il0floatpacket.84(%rip), %xmm1
        mulss     %xmm2, %xmm1
        addss     .L_2il0floatpacket.85(%rip), %xmm1
        mulss     %xmm2, %xmm1
        addss     .L_2il0floatpacket.86(%rip), %xmm1
        mulss     %xmm2, %xmm1
        addss     .L_2il0floatpacket.87(%rip), %xmm1
        mulss     %xmm2, %xmm1
        addss     .L_2il0floatpacket.88(%rip), %xmm1
        mulss     %xmm2, %xmm1
        addss     .L_2il0floatpacket.89(%rip), %xmm1
        mulss     %xmm2, %xmm1
        addss     %xmm1, %xmm2
        movss     %xmm2, (%rsi)
        ret
..B1.8:
        ucomiss   %xmm0, %xmm1
        jp        ..B1.9
        je        ..B1.11
..B1.9:
        divss     %xmm0, %xmm0
        movss     %xmm0, (%rsi)
        movl      $1, %eax
..B1.10:
        ret
..B1.11:
        movss     .L_2il0floatpacket.90(%rip), %xmm1
        movl      $2, %eax
        divss     %xmm0, %xmm1
        movss     %xmm1, (%rsi)
        ret
..B1.12:
        movb      3(%r8), %dl
        andb      $-128, %dl
        cmpb      $-128, %dl
        je        ..B1.14
..B1.13:
        movss     (%r8), %xmm0
        mulss     %xmm0, %xmm0
        movss     %xmm0, (%rsi)
        ret
..B1.14:
        testl     $8388607, (%r8)
        jne       ..B1.13
..B1.15:
        movl      $1, %eax
        pxor      %xmm1, %xmm1
        pxor      %xmm0, %xmm0
        divss     %xmm0, %xmm1
        movss     %xmm1, (%rsi)
        ret
        .align    16,0x90
	.cfi_endproc
	.type	__svml_slog10_ha_cout_rare_internal,@function
	.size	__svml_slog10_ha_cout_rare_internal,.-__svml_slog10_ha_cout_rare_internal
..LN__svml_slog10_ha_cout_rare_internal.0:
	.data
# -- End  __svml_slog10_ha_cout_rare_internal
	.section .rodata, "a"
	.align 32
	.align 32
_vmldLgHATab:
	.long	1121868800
	.long	0
	.long	0
	.long	1121641104
	.long	1004535808
	.long	912917177
	.long	1121413408
	.long	1013055488
	.long	3065901602
	.long	1121185712
	.long	1017839616
	.long	3083361151
	.long	1120958016
	.long	1021673472
	.long	929297206
	.long	1120844168
	.long	1023524864
	.long	3077496589
	.long	1120616472
	.long	1025499136
	.long	3070500046
	.long	1120388776
	.long	1027506176
	.long	912271551
	.long	1120274928
	.long	1028521984
	.long	927716856
	.long	1120047232
	.long	1030586368
	.long	923757491
	.long	1119933384
	.long	1031634944
	.long	3056752848
	.long	1119705688
	.long	1032775680
	.long	917029265
	.long	1119591840
	.long	1033314304
	.long	3065085585
	.long	1119364144
	.long	1034403840
	.long	3064614024
	.long	1119250296
	.long	1034954752
	.long	921091539
	.long	1119136448
	.long	1035513856
	.long	3057436454
	.long	1118908752
	.long	1036644352
	.long	922468856
	.long	1118794904
	.long	1037219840
	.long	3049155845
	.long	1118681056
	.long	1037799424
	.long	904301451
	.long	1118567208
	.long	1038385152
	.long	908617625
	.long	1118453360
	.long	1038977024
	.long	905362229
	.long	1118225664
	.long	1040179200
	.long	3027570914
	.long	1118111816
	.long	1040488448
	.long	882280038
	.long	1117997968
	.long	1040796672
	.long	911375775
	.long	1117884120
	.long	1041108480
	.long	904500572
	.long	1117770272
	.long	1041423872
	.long	3057579304
	.long	1117656424
	.long	1041742336
	.long	3053334705
	.long	1117542576
	.long	1042064384
	.long	3053389931
	.long	1117428728
	.long	1042390016
	.long	3051561465
	.long	1117314880
	.long	1042719232
	.long	3011187895
	.long	1117201032
	.long	1043052544
	.long	3059907089
	.long	1117087184
	.long	1043389440
	.long	3057005374
	.long	1116973336
	.long	1043729920
	.long	911932638
	.long	1116859488
	.long	1044075008
	.long	892958461
	.long	1116859488
	.long	1044075008
	.long	892958461
	.long	1116745640
	.long	1044424192
	.long	3048660547
	.long	1116631792
	.long	1044777472
	.long	3049032043
	.long	1116517944
	.long	1045134848
	.long	906867152
	.long	1116404096
	.long	1045496832
	.long	911484894
	.long	1116404096
	.long	1045496832
	.long	911484894
	.long	1116290248
	.long	1045863424
	.long	912580963
	.long	1116176400
	.long	1046235136
	.long	3058440244
	.long	1116062552
	.long	1046610944
	.long	895945194
	.long	1116062552
	.long	1046610944
	.long	895945194
	.long	1115948704
	.long	1046991872
	.long	904357324
	.long	1115834856
	.long	1047377920
	.long	902293870
	.long	1115721008
	.long	1047769088
	.long	907149878
	.long	1115721008
	.long	1047769088
	.long	907149878
	.long	1115529456
	.long	1048165888
	.long	3052029263
	.long	1115301760
	.long	1048567808
	.long	3035959522
	.long	1115301760
	.long	1048567808
	.long	3035959522
	.long	1115074064
	.long	1048775680
	.long	892998645
	.long	1115074064
	.long	1048775680
	.long	892998645
	.long	1114846368
	.long	1048982400
	.long	881767775
	.long	1114618672
	.long	1049192064
	.long	893839142
	.long	1114618672
	.long	1049192064
	.long	893839142
	.long	1114390976
	.long	1049404800
	.long	896498651
	.long	1114390976
	.long	1049404800
	.long	896498651
	.long	1114163280
	.long	1049620736
	.long	3033695903
	.long	1114163280
	.long	1049620736
	.long	3033695903
	.long	1113935584
	.long	1049839872
	.long	3029986056
	.long	1113935584
	.long	1049839872
	.long	3029986056
	.long	1113707888
	.long	1050062336
	.long	884671939
	.long	1113707888
	.long	1050062336
	.long	884671939
	.long	1113480192
	.long	1050288256
	.long	894707678
	.long	1050279936
	.long	964848148
	.long	1207959616
	.long	1174405120
	.long	1002438656
	.long	1400897536
	.long	0
	.long	1065353216
	.long	1121868800
	.long	3212771328
	.long	3079888218
	.long	870463078
	.long	2957202361
	.long	749987585
	.long	2838272395
	.long	631921661
	.long	2720751022
	.type	_vmldLgHATab,@object
	.size	_vmldLgHATab,848
	.align 4
.L_2il0floatpacket.75:
	.long	0x53800000
	.type	.L_2il0floatpacket.75,@object
	.size	.L_2il0floatpacket.75,4
	.align 4
.L_2il0floatpacket.76:
	.long	0x3bc00000
	.type	.L_2il0floatpacket.76,@object
	.size	.L_2il0floatpacket.76,4
	.align 4
.L_2il0floatpacket.77:
	.long	0x3e9a0000
	.type	.L_2il0floatpacket.77,@object
	.size	.L_2il0floatpacket.77,4
	.align 4
.L_2il0floatpacket.78:
	.long	0x39826a14
	.type	.L_2il0floatpacket.78,@object
	.size	.L_2il0floatpacket.78,4
	.align 4
.L_2il0floatpacket.79:
	.long	0x48000040
	.type	.L_2il0floatpacket.79,@object
	.size	.L_2il0floatpacket.79,4
	.align 4
.L_2il0floatpacket.80:
	.long	0x46000000
	.type	.L_2il0floatpacket.80,@object
	.size	.L_2il0floatpacket.80,4
	.align 4
.L_2il0floatpacket.81:
	.long	0x42de5c00
	.type	.L_2il0floatpacket.81,@object
	.size	.L_2il0floatpacket.81,4
	.align 4
.L_2il0floatpacket.82:
	.long	0xa22b5dae
	.type	.L_2il0floatpacket.82,@object
	.size	.L_2il0floatpacket.82,4
	.align 4
.L_2il0floatpacket.83:
	.long	0x25aa5bfd
	.type	.L_2il0floatpacket.83,@object
	.size	.L_2il0floatpacket.83,4
	.align 4
.L_2il0floatpacket.84:
	.long	0xa92c998b
	.type	.L_2il0floatpacket.84,@object
	.size	.L_2il0floatpacket.84,4
	.align 4
.L_2il0floatpacket.85:
	.long	0x2cb3e701
	.type	.L_2il0floatpacket.85,@object
	.size	.L_2il0floatpacket.85,4
	.align 4
.L_2il0floatpacket.86:
	.long	0xb04353b9
	.type	.L_2il0floatpacket.86,@object
	.size	.L_2il0floatpacket.86,4
	.align 4
.L_2il0floatpacket.87:
	.long	0x33e23666
	.type	.L_2il0floatpacket.87,@object
	.size	.L_2il0floatpacket.87,4
	.align 4
.L_2il0floatpacket.88:
	.long	0xb7935d5a
	.type	.L_2il0floatpacket.88,@object
	.size	.L_2il0floatpacket.88,4
	.align 4
.L_2il0floatpacket.89:
	.long	0xbf7f0000
	.type	.L_2il0floatpacket.89,@object
	.size	.L_2il0floatpacket.89,4
	.align 4
.L_2il0floatpacket.90:
	.long	0xbf800000
	.type	.L_2il0floatpacket.90,@object
	.size	.L_2il0floatpacket.90,4
	.align 4
.L_2il0floatpacket.91:
	.long	0x3f800000
	.type	.L_2il0floatpacket.91,@object
	.size	.L_2il0floatpacket.91,4
	.data
	.section .note.GNU-stack, ""
# End
