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
.L_2__routine_start___svml_slog1p_ha_cout_rare_internal_0:
# -- Begin  __svml_slog1p_ha_cout_rare_internal
	.text
       .align    16,0x90
	.hidden __svml_slog1p_ha_cout_rare_internal
	.globl __svml_slog1p_ha_cout_rare_internal
__svml_slog1p_ha_cout_rare_internal:
# parameter 1: %rdi
# parameter 2: %rsi
..B1.1:
	.cfi_startproc
..L1:

        pxor      %xmm2, %xmm2
        cvtss2sd  (%rdi), %xmm2
        xorl      %eax, %eax
        xorb      %r8b, %r8b
        addsd     .L_2il0floatpacket.86(%rip), %xmm2
        cvtsd2ss  %xmm2, %xmm2
        movss     %xmm2, -20(%rsp)
        movzwl    -18(%rsp), %edx
        andl      $32640, %edx
        cmpl      $32640, %edx
        je        ..B1.15
..B1.2:
        movss     %xmm2, -16(%rsp)
        xorl      %ecx, %ecx
        movzwl    -14(%rsp), %edx
        testl     $32640, %edx
        jne       ..B1.4
..B1.3:
        mulss     .L_2il0floatpacket.71(%rip), %xmm2
        movb      $1, %r8b
        movss     %xmm2, -16(%rsp)
        movl      $-40, %ecx
..B1.4:
        pxor      %xmm0, %xmm0
        comiss    %xmm0, %xmm2
        jbe       ..B1.10
..B1.5:
        movss     .L_2il0floatpacket.87(%rip), %xmm1
        movaps    %xmm2, %xmm4
        subss     %xmm1, %xmm4
        movss     %xmm4, -20(%rsp)
        andb      $127, -17(%rsp)
        movss     -20(%rsp), %xmm3
        comiss    .L_2il0floatpacket.72(%rip), %xmm3
        jbe       ..B1.9
..B1.6:
        movzwl    -14(%rsp), %edx
        pxor      %xmm4, %xmm4
        andl      $32640, %edx
        shrl      $7, %edx
        lea       -127(%rcx,%rdx), %ecx
        cvtsi2ss  %ecx, %xmm4
        cmpb      $1, %r8b
        je        ..B1.13
..B1.7:
        movss     .L_2il0floatpacket.82(%rip), %xmm5
        movss     .L_2il0floatpacket.83(%rip), %xmm0
        mulss     %xmm4, %xmm5
        mulss     %xmm0, %xmm4
        movaps    %xmm4, %xmm0
..B1.8:
        movss     %xmm2, -20(%rsp)
        movaps    %xmm5, %xmm9
        movzwl    -18(%rsp), %edx
        lea       _vmldLnHATab(%rip), %r8
        andl      $-32641, %edx
        addl      $16256, %edx
        movw      %dx, -18(%rsp)
        movss     -20(%rsp), %xmm8
        movaps    %xmm8, %xmm3
        movss     .L_2il0floatpacket.85(%rip), %xmm7
        movss     .L_2il0floatpacket.73(%rip), %xmm13
        addss     .L_2il0floatpacket.84(%rip), %xmm3
        movss     %xmm3, -24(%rsp)
        movl      -24(%rsp), %ecx
        andl      $127, %ecx
        lea       (%rcx,%rcx,2), %edi
        movss     4(%r8,%rdi,4), %xmm6
        movss     (%r8,%rdi,4), %xmm2
        addss     %xmm6, %xmm9
        addss     8(%r8,%rdi,4), %xmm0
        movaps    %xmm9, %xmm4
        subss     %xmm5, %xmm4
        movss     %xmm4, -24(%rsp)
        movss     -24(%rsp), %xmm5
        subss     %xmm5, %xmm6
        movss     %xmm6, -24(%rsp)
        movss     -24(%rsp), %xmm10
        addss     %xmm0, %xmm10
        movaps    %xmm7, %xmm0
        addss     %xmm8, %xmm0
        movss     %xmm0, -24(%rsp)
        movaps    %xmm10, %xmm0
        movss     -24(%rsp), %xmm14
        subss     %xmm7, %xmm14
        subss     %xmm14, %xmm8
        mulss     %xmm2, %xmm14
        subss     %xmm1, %xmm14
        mulss     %xmm8, %xmm2
        movaps    %xmm14, %xmm1
        addss     %xmm2, %xmm0
        addss     %xmm2, %xmm1
        addss     %xmm9, %xmm14
        mulss     %xmm1, %xmm13
        movaps    %xmm0, %xmm11
        movaps    %xmm14, %xmm15
        addss     .L_2il0floatpacket.74(%rip), %xmm13
        subss     %xmm10, %xmm11
        addss     %xmm0, %xmm15
        mulss     %xmm1, %xmm13
        movss     %xmm11, -24(%rsp)
        movss     -24(%rsp), %xmm12
        addss     .L_2il0floatpacket.75(%rip), %xmm13
        subss     %xmm12, %xmm2
        mulss     %xmm1, %xmm13
        movss     %xmm2, -24(%rsp)
        addss     .L_2il0floatpacket.76(%rip), %xmm13
        mulss     %xmm1, %xmm13
        addss     .L_2il0floatpacket.77(%rip), %xmm13
        mulss     %xmm1, %xmm13
        addss     .L_2il0floatpacket.78(%rip), %xmm13
        mulss     %xmm1, %xmm13
        addss     .L_2il0floatpacket.79(%rip), %xmm13
        mulss     %xmm1, %xmm13
        mulss     %xmm1, %xmm13
        movss     -24(%rsp), %xmm1
        movss     %xmm15, (%rsi)
        subss     %xmm14, %xmm15
        addss     %xmm13, %xmm1
        movss     %xmm15, -24(%rsp)
        movss     -24(%rsp), %xmm13
        subss     %xmm13, %xmm0
        movss     %xmm0, -24(%rsp)
        movss     -24(%rsp), %xmm14
        addss     %xmm14, %xmm1
        movss     %xmm1, -24(%rsp)
        movss     -24(%rsp), %xmm2
        addss     (%rsi), %xmm2
        movss     %xmm2, (%rsi)
        ret
..B1.9:
        movss     .L_2il0floatpacket.73(%rip), %xmm0
        mulss     %xmm4, %xmm0
        addss     .L_2il0floatpacket.74(%rip), %xmm0
        mulss     %xmm4, %xmm0
        addss     .L_2il0floatpacket.75(%rip), %xmm0
        mulss     %xmm4, %xmm0
        addss     .L_2il0floatpacket.76(%rip), %xmm0
        mulss     %xmm4, %xmm0
        addss     .L_2il0floatpacket.77(%rip), %xmm0
        mulss     %xmm4, %xmm0
        addss     .L_2il0floatpacket.78(%rip), %xmm0
        mulss     %xmm4, %xmm0
        addss     .L_2il0floatpacket.79(%rip), %xmm0
        mulss     %xmm4, %xmm0
        mulss     %xmm4, %xmm0
        addss     %xmm0, %xmm4
        movss     %xmm4, (%rsi)
        ret
..B1.10:
        ucomiss   %xmm0, %xmm2
        jp        ..B1.11
        je        ..B1.14
..B1.11:
        divss     %xmm0, %xmm0
        movss     %xmm0, (%rsi)
        movl      $1, %eax
..B1.12:
        ret
..B1.13:
        movss     .L_2il0floatpacket.81(%rip), %xmm3
        mulss     %xmm3, %xmm4
        movaps    %xmm4, %xmm5
        jmp       ..B1.8
..B1.14:
        movss     .L_2il0floatpacket.80(%rip), %xmm1
        movl      $2, %eax
        divss     %xmm0, %xmm1
        movss     %xmm1, (%rsi)
        ret
..B1.15:
        movb      -17(%rsp), %dl
        andb      $-128, %dl
        cmpb      $-128, %dl
        je        ..B1.17
..B1.16:
        mulss     %xmm2, %xmm2
        movss     %xmm2, (%rsi)
        ret
..B1.17:
        testl     $8388607, -20(%rsp)
        jne       ..B1.16
..B1.18:
        movl      $1, %eax
        pxor      %xmm1, %xmm1
        pxor      %xmm0, %xmm0
        divss     %xmm0, %xmm1
        movss     %xmm1, (%rsi)
        ret
        .align    16,0x90
	.cfi_endproc
	.type	__svml_slog1p_ha_cout_rare_internal,@function
	.size	__svml_slog1p_ha_cout_rare_internal,.-__svml_slog1p_ha_cout_rare_internal
..LN__svml_slog1p_ha_cout_rare_internal.0:
	.data
# -- End  __svml_slog1p_ha_cout_rare_internal
	.section .rodata, "a"
	.align 32
	.align 32
_vmldLnHATab:
	.long	1065353216
	.long	0
	.long	0
	.long	1065091072
	.long	1015087104
	.long	900509991
	.long	1064828928
	.long	1023541248
	.long	925811956
	.long	1064566784
	.long	1027915776
	.long	3084221144
	.long	1064304640
	.long	1032073216
	.long	3066991812
	.long	1064173568
	.long	1033195520
	.long	882149603
	.long	1063911424
	.long	1035468800
	.long	928189163
	.long	1063649280
	.long	1037783040
	.long	927501741
	.long	1063518208
	.long	1038958592
	.long	3076037756
	.long	1063256064
	.long	1040759808
	.long	904405630
	.long	1063124992
	.long	1041361920
	.long	3052231524
	.long	1062862848
	.long	1042581504
	.long	922094799
	.long	1062731776
	.long	1043201024
	.long	3070120623
	.long	1062469632
	.long	1044455424
	.long	3069864633
	.long	1062338560
	.long	1045091328
	.long	3063188516
	.long	1062207488
	.long	1045733376
	.long	3054902185
	.long	1061945344
	.long	1047035904
	.long	920635797
	.long	1061814272
	.long	1047697408
	.long	904920689
	.long	1061683200
	.long	1048365056
	.long	912483742
	.long	1061552128
	.long	1048807936
	.long	3052664405
	.long	1061421056
	.long	1049148416
	.long	912794238
	.long	1061158912
	.long	1049840384
	.long	889474359
	.long	1061027840
	.long	1050191872
	.long	3059868362
	.long	1060896768
	.long	1050546944
	.long	3059256525
	.long	1060765696
	.long	1050905600
	.long	912008988
	.long	1060634624
	.long	1051268352
	.long	912290698
	.long	1060503552
	.long	1051635200
	.long	3037211048
	.long	1060372480
	.long	1052005888
	.long	906226119
	.long	1060241408
	.long	1052380928
	.long	3052480305
	.long	1060110336
	.long	1052760064
	.long	3048768765
	.long	1059979264
	.long	1053143552
	.long	3049975450
	.long	1059848192
	.long	1053531392
	.long	894485718
	.long	1059717120
	.long	1053923840
	.long	897598623
	.long	1059586048
	.long	1054320896
	.long	907355277
	.long	1059586048
	.long	1054320896
	.long	907355277
	.long	1059454976
	.long	1054722816
	.long	881705073
	.long	1059323904
	.long	1055129600
	.long	3049723733
	.long	1059192832
	.long	1055541248
	.long	890353599
	.long	1059061760
	.long	1055958016
	.long	908173938
	.long	1059061760
	.long	1055958016
	.long	908173938
	.long	1058930688
	.long	1056380160
	.long	883644938
	.long	1058799616
	.long	1056807680
	.long	3052015799
	.long	1058668544
	.long	1057102592
	.long	884897284
	.long	1058668544
	.long	1057102592
	.long	884897284
	.long	1058537472
	.long	1057321920
	.long	3037632470
	.long	1058406400
	.long	1057544128
	.long	865017195
	.long	1058275328
	.long	1057769344
	.long	3042936546
	.long	1058275328
	.long	1057769344
	.long	3042936546
	.long	1058144256
	.long	1057997568
	.long	903344518
	.long	1058013184
	.long	1058228992
	.long	897862967
	.long	1058013184
	.long	1058228992
	.long	897862967
	.long	1057882112
	.long	1058463680
	.long	3047822280
	.long	1057882112
	.long	1058463680
	.long	3047822280
	.long	1057751040
	.long	1058701632
	.long	883793293
	.long	1057619968
	.long	1058943040
	.long	851667963
	.long	1057619968
	.long	1058943040
	.long	851667963
	.long	1057488896
	.long	1059187968
	.long	3000004036
	.long	1057488896
	.long	1059187968
	.long	3000004036
	.long	1057357824
	.long	1059436544
	.long	3047430717
	.long	1057357824
	.long	1059436544
	.long	3047430717
	.long	1057226752
	.long	1059688832
	.long	3043802308
	.long	1057226752
	.long	1059688832
	.long	3043802308
	.long	1057095680
	.long	1059944960
	.long	876113044
	.long	1057095680
	.long	1059944960
	.long	876113044
	.long	1056964608
	.long	1060205056
	.long	901758606
	.long	1060205056
	.long	901758606
	.long	1207959616
	.long	1174405120
	.long	1008730112
	.long	1400897536
	.long	0
	.long	1065353216
	.long	3204448256
	.long	1051372203
	.long	3196059648
	.long	1045220557
	.long	3190467243
	.long	1041387009
	.long	3187672480
	.type	_vmldLnHATab,@object
	.size	_vmldLnHATab,840
	.align 8
.L_2il0floatpacket.86:
	.long	0x00000000,0x3ff00000
	.type	.L_2il0floatpacket.86,@object
	.size	.L_2il0floatpacket.86,8
	.align 4
.L_2il0floatpacket.71:
	.long	0x53800000
	.type	.L_2il0floatpacket.71,@object
	.size	.L_2il0floatpacket.71,4
	.align 4
.L_2il0floatpacket.72:
	.long	0x3c200000
	.type	.L_2il0floatpacket.72,@object
	.size	.L_2il0floatpacket.72,4
	.align 4
.L_2il0floatpacket.73:
	.long	0xbe0005a0
	.type	.L_2il0floatpacket.73,@object
	.size	.L_2il0floatpacket.73,4
	.align 4
.L_2il0floatpacket.74:
	.long	0x3e124e01
	.type	.L_2il0floatpacket.74,@object
	.size	.L_2il0floatpacket.74,4
	.align 4
.L_2il0floatpacket.75:
	.long	0xbe2aaaab
	.type	.L_2il0floatpacket.75,@object
	.size	.L_2il0floatpacket.75,4
	.align 4
.L_2il0floatpacket.76:
	.long	0x3e4ccccd
	.type	.L_2il0floatpacket.76,@object
	.size	.L_2il0floatpacket.76,4
	.align 4
.L_2il0floatpacket.77:
	.long	0xbe800000
	.type	.L_2il0floatpacket.77,@object
	.size	.L_2il0floatpacket.77,4
	.align 4
.L_2il0floatpacket.78:
	.long	0x3eaaaaab
	.type	.L_2il0floatpacket.78,@object
	.size	.L_2il0floatpacket.78,4
	.align 4
.L_2il0floatpacket.79:
	.long	0xbf000000
	.type	.L_2il0floatpacket.79,@object
	.size	.L_2il0floatpacket.79,4
	.align 4
.L_2il0floatpacket.80:
	.long	0xbf800000
	.type	.L_2il0floatpacket.80,@object
	.size	.L_2il0floatpacket.80,4
	.align 4
.L_2il0floatpacket.81:
	.long	0x3f317218
	.type	.L_2il0floatpacket.81,@object
	.size	.L_2il0floatpacket.81,4
	.align 4
.L_2il0floatpacket.82:
	.long	0x3f317200
	.type	.L_2il0floatpacket.82,@object
	.size	.L_2il0floatpacket.82,4
	.align 4
.L_2il0floatpacket.83:
	.long	0x35bfbe8e
	.type	.L_2il0floatpacket.83,@object
	.size	.L_2il0floatpacket.83,4
	.align 4
.L_2il0floatpacket.84:
	.long	0x48000040
	.type	.L_2il0floatpacket.84,@object
	.size	.L_2il0floatpacket.84,4
	.align 4
.L_2il0floatpacket.85:
	.long	0x46000000
	.type	.L_2il0floatpacket.85,@object
	.size	.L_2il0floatpacket.85,4
	.align 4
.L_2il0floatpacket.87:
	.long	0x3f800000
	.type	.L_2il0floatpacket.87,@object
	.size	.L_2il0floatpacket.87,4
	.data
	.section .note.GNU-stack, ""
# End
