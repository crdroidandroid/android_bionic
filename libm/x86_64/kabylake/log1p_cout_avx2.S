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
.L_2__routine_start___svml_dlog1p_ha_cout_rare_internal_0:
# -- Begin  __svml_dlog1p_ha_cout_rare_internal
	.text
       .align    16,0x90
	.hidden __svml_dlog1p_ha_cout_rare_internal
	.globl __svml_dlog1p_ha_cout_rare_internal
__svml_dlog1p_ha_cout_rare_internal:
# parameter 1: %rdi
# parameter 2: %rsi
..B1.1:
        .cfi_startproc
..L1:

        xorl      %eax, %eax
        movsd     .L_2il0floatpacket.69(%rip), %xmm3
        movsd     (%rdi), %xmm2
        addsd     %xmm3, %xmm2
        movsd     %xmm2, -16(%rsp)
        movzwl    -10(%rsp), %edx
        andl      $32752, %edx
        cmpl      $32752, %edx
        je        ..B1.12
..B1.2:
        movsd     %xmm2, -8(%rsp)
        xorl      %ecx, %ecx
        movzwl    -2(%rsp), %edx
        testl     $32752, %edx
        jne       ..B1.4
..B1.3:
        mulsd     1600+_imldLnHATab(%rip), %xmm2
        movl      $-60, %ecx
        movsd     %xmm2, -8(%rsp)
..B1.4:
        movsd     1608+_imldLnHATab(%rip), %xmm0
        comisd    %xmm0, %xmm2
        jbe       ..B1.8
..B1.5:
        movaps    %xmm2, %xmm1
        subsd     %xmm3, %xmm1
        movsd     %xmm1, -16(%rsp)
        andb      $127, -9(%rsp)
        movsd     -16(%rsp), %xmm0
        comisd    1592+_imldLnHATab(%rip), %xmm0
        jbe       ..B1.7
..B1.6:
        movsd     %xmm2, -16(%rsp)
        pxor      %xmm6, %xmm6
        movzwl    -10(%rsp), %edi
        lea       _imldLnHATab(%rip), %r10
        andl      $-32753, %edi
        addl      $16368, %edi
        movw      %di, -10(%rsp)
        movsd     -16(%rsp), %xmm4
        movaps    %xmm4, %xmm1
        movaps    %xmm4, %xmm2
        movsd     1672+_imldLnHATab(%rip), %xmm7
        movzwl    -2(%rsp), %edx
        andl      $32752, %edx
        addsd     1576+_imldLnHATab(%rip), %xmm1
        addsd     1584+_imldLnHATab(%rip), %xmm2
        movsd     %xmm1, -24(%rsp)
        movl      -24(%rsp), %r8d
        movsd     %xmm2, -24(%rsp)
        andl      $127, %r8d
        movsd     -24(%rsp), %xmm9
        movsd     1560+_imldLnHATab(%rip), %xmm5
        movsd     1568+_imldLnHATab(%rip), %xmm0
        shrl      $4, %edx
        subsd     1584+_imldLnHATab(%rip), %xmm9
        lea       (%r8,%r8,2), %r9d
        movsd     (%r10,%r9,8), %xmm8
        lea       -1023(%rcx,%rdx), %ecx
        cvtsi2sd  %ecx, %xmm6
        subsd     %xmm9, %xmm4
        mulsd     %xmm8, %xmm9
        mulsd     %xmm6, %xmm5
        subsd     %xmm3, %xmm9
        mulsd     %xmm4, %xmm8
        mulsd     %xmm0, %xmm6
        addsd     8(%r10,%r9,8), %xmm5
        addsd     16(%r10,%r9,8), %xmm6
        movaps    %xmm9, %xmm3
        addsd     %xmm5, %xmm9
        addsd     %xmm8, %xmm3
        addsd     %xmm6, %xmm8
        mulsd     %xmm3, %xmm7
        addsd     1664+_imldLnHATab(%rip), %xmm7
        mulsd     %xmm3, %xmm7
        addsd     1656+_imldLnHATab(%rip), %xmm7
        mulsd     %xmm3, %xmm7
        addsd     1648+_imldLnHATab(%rip), %xmm7
        mulsd     %xmm3, %xmm7
        addsd     1640+_imldLnHATab(%rip), %xmm7
        mulsd     %xmm3, %xmm7
        addsd     1632+_imldLnHATab(%rip), %xmm7
        mulsd     %xmm3, %xmm7
        addsd     1624+_imldLnHATab(%rip), %xmm7
        mulsd     %xmm3, %xmm7
        mulsd     %xmm3, %xmm7
        addsd     %xmm7, %xmm8
        addsd     %xmm8, %xmm9
        movsd     %xmm9, (%rsi)
        ret
..B1.7:
        movsd     1672+_imldLnHATab(%rip), %xmm0
        mulsd     %xmm1, %xmm0
        addsd     1664+_imldLnHATab(%rip), %xmm0
        mulsd     %xmm1, %xmm0
        addsd     1656+_imldLnHATab(%rip), %xmm0
        mulsd     %xmm1, %xmm0
        addsd     1648+_imldLnHATab(%rip), %xmm0
        mulsd     %xmm1, %xmm0
        addsd     1640+_imldLnHATab(%rip), %xmm0
        mulsd     %xmm1, %xmm0
        addsd     1632+_imldLnHATab(%rip), %xmm0
        mulsd     %xmm1, %xmm0
        addsd     1624+_imldLnHATab(%rip), %xmm0
        mulsd     %xmm1, %xmm0
        mulsd     %xmm1, %xmm0
        addsd     %xmm0, %xmm1
        movsd     %xmm1, (%rsi)
        ret
..B1.8:
        ucomisd   %xmm0, %xmm2
        jp        ..B1.9
        je        ..B1.11
..B1.9:
        divsd     %xmm0, %xmm0
        movsd     %xmm0, (%rsi)
        movl      $1, %eax
..B1.10:
        ret
..B1.11:
        movsd     1616+_imldLnHATab(%rip), %xmm1
        movl      $2, %eax
        xorps     .L_2il0floatpacket.68(%rip), %xmm1
        divsd     %xmm0, %xmm1
        movsd     %xmm1, (%rsi)
        ret
..B1.12:
        movb      -9(%rsp), %dl
        andb      $-128, %dl
        cmpb      $-128, %dl
        je        ..B1.14
..B1.13:
        mulsd     %xmm2, %xmm2
        movsd     %xmm2, (%rsi)
        ret
..B1.14:
        testl     $1048575, -12(%rsp)
        jne       ..B1.13
..B1.15:
        cmpl      $0, -16(%rsp)
        jne       ..B1.13
..B1.16:
        movsd     1608+_imldLnHATab(%rip), %xmm0
        movl      $1, %eax
        divsd     %xmm0, %xmm0
        movsd     %xmm0, (%rsi)
        ret
        .align    16,0x90
	.cfi_endproc
	.type	__svml_dlog1p_ha_cout_rare_internal,@function
	.size	__svml_dlog1p_ha_cout_rare_internal,.-__svml_dlog1p_ha_cout_rare_internal
..LN__svml_dlog1p_ha_cout_rare_internal.0:
	.data
# -- End  __svml_dlog1p_ha_cout_rare_internal
	.section .rodata, "a"
	.align 32
	.align 32
_imldLnHATab:
	.long	0
	.long	1072693248
	.long	0
	.long	0
	.long	0
	.long	0
	.long	0
	.long	1072660480
	.long	1486880768
	.long	1066410070
	.long	1813744607
	.long	3179892593
	.long	0
	.long	1072629760
	.long	377487360
	.long	1067416219
	.long	919019713
	.long	3179241129
	.long	0
	.long	1072599040
	.long	1513619456
	.long	1067944025
	.long	874573033
	.long	3178512940
	.long	0
	.long	1072570368
	.long	3221749760
	.long	1068427825
	.long	4181665006
	.long	3177478212
	.long	0
	.long	1072541696
	.long	4162322432
	.long	1068708823
	.long	627020255
	.long	1028629941
	.long	0
	.long	1072513024
	.long	183107584
	.long	1068957907
	.long	2376703469
	.long	1030233118
	.long	0
	.long	1072486400
	.long	1053425664
	.long	1069192557
	.long	696277142
	.long	1030474863
	.long	0
	.long	1072459776
	.long	3996123136
	.long	1069430535
	.long	2630798680
	.long	1028792016
	.long	0
	.long	1072435200
	.long	3452764160
	.long	1069600382
	.long	624954044
	.long	3177101741
	.long	0
	.long	1072409600
	.long	207650816
	.long	1069717971
	.long	3272735636
	.long	3175176575
	.long	0
	.long	1072386048
	.long	2647228416
	.long	1069827627
	.long	3594228712
	.long	1029303785
	.long	0
	.long	1072362496
	.long	2712010752
	.long	1069938736
	.long	3653242769
	.long	3176839013
	.long	0
	.long	1072338944
	.long	374439936
	.long	1070051337
	.long	4072775574
	.long	3176577495
	.long	0
	.long	1072316416
	.long	3707174912
	.long	1070160474
	.long	1486946159
	.long	1023930920
	.long	0
	.long	1072294912
	.long	1443954688
	.long	1070265993
	.long	293532967
	.long	3176278277
	.long	0
	.long	1072273408
	.long	127762432
	.long	1070372856
	.long	3404145447
	.long	3177023955
	.long	0
	.long	1072252928
	.long	2053832704
	.long	1070475911
	.long	1575076358
	.long	1029048544
	.long	0
	.long	1072232448
	.long	3194093568
	.long	1070580248
	.long	1864169120
	.long	1026866084
	.long	0
	.long	1072212992
	.long	3917201408
	.long	1070638340
	.long	2362145246
	.long	3175606197
	.long	0
	.long	1072193536
	.long	3417112576
	.long	1070689116
	.long	70087871
	.long	3174183577
	.long	0
	.long	1072175104
	.long	4226777088
	.long	1070737793
	.long	1620410586
	.long	3174700065
	.long	0
	.long	1072156672
	.long	3168870400
	.long	1070787042
	.long	311238082
	.long	1025781772
	.long	0
	.long	1072139264
	.long	2150580224
	.long	1070834092
	.long	1664262457
	.long	3175299224
	.long	0
	.long	1072120832
	.long	4095672320
	.long	1070884491
	.long	1657121015
	.long	3174674199
	.long	0
	.long	1072104448
	.long	2595577856
	.long	1070929805
	.long	2014006823
	.long	3175423830
	.long	0
	.long	1072087040
	.long	3747176448
	.long	1070978493
	.long	144991708
	.long	3171552042
	.long	0
	.long	1072070656
	.long	1050435584
	.long	1071024840
	.long	3386227432
	.long	1027876916
	.long	0
	.long	1072055296
	.long	255516672
	.long	1071068760
	.long	2637594316
	.long	1028049573
	.long	0
	.long	1072038912
	.long	1640783872
	.long	1071116120
	.long	893247007
	.long	1028452162
	.long	0
	.long	1072023552
	.long	2940411904
	.long	1071161011
	.long	813240633
	.long	1027664048
	.long	0
	.long	1072009216
	.long	882917376
	.long	1071203348
	.long	2376597551
	.long	3175828767
	.long	0
	.long	1071993856
	.long	213966848
	.long	1071249188
	.long	2977204125
	.long	1028350609
	.long	0
	.long	1071979520
	.long	2921504768
	.long	1071292428
	.long	523218347
	.long	1028007004
	.long	0
	.long	1071965184
	.long	3186655232
	.long	1071336119
	.long	2352907891
	.long	1026967097
	.long	0
	.long	1071951872
	.long	2653364224
	.long	1071377101
	.long	2453418583
	.long	3174349512
	.long	0
	.long	1071938560
	.long	3759783936
	.long	1071418487
	.long	3685870403
	.long	3175415611
	.long	0
	.long	1071925248
	.long	2468364288
	.long	1071460286
	.long	1578908842
	.long	3175510517
	.long	0
	.long	1071911936
	.long	81903616
	.long	1071502506
	.long	770710269
	.long	1026742353
	.long	0
	.long	1071899648
	.long	2799321088
	.long	1071541858
	.long	3822266185
	.long	1028434427
	.long	0
	.long	1071886336
	.long	2142265344
	.long	1071584911
	.long	175901806
	.long	3173871540
	.long	0
	.long	1071874048
	.long	2944024576
	.long	1071625048
	.long	2747360403
	.long	1027672159
	.long	0
	.long	1071862784
	.long	3434301440
	.long	1071653426
	.long	4194662196
	.long	3173893003
	.long	0
	.long	1071850496
	.long	1547755520
	.long	1071673870
	.long	4248764681
	.long	3172759087
	.long	0
	.long	1071839232
	.long	4246986752
	.long	1071692786
	.long	2840205638
	.long	3174430911
	.long	0
	.long	1071826944
	.long	3418390528
	.long	1071713619
	.long	3041880823
	.long	1025440860
	.long	0
	.long	1071816704
	.long	4143093760
	.long	1071731139
	.long	2727587401
	.long	3173965207
	.long	0
	.long	1071805440
	.long	3121326080
	.long	1071750582
	.long	3173887692
	.long	3174190163
	.long	0
	.long	1071794176
	.long	1852893184
	.long	1071770207
	.long	3951060252
	.long	1027348295
	.long	0
	.long	1071783936
	.long	3636379648
	.long	1071788208
	.long	1684924001
	.long	3174777086
	.long	0
	.long	1071773696
	.long	516505600
	.long	1071806366
	.long	429181199
	.long	3173211033
	.long	0
	.long	1071763456
	.long	4186185728
	.long	1071824681
	.long	2044904577
	.long	3174967132
	.long	0
	.long	1071753216
	.long	877596672
	.long	1071843159
	.long	1396318105
	.long	3173959727
	.long	0
	.long	1071742976
	.long	2912784384
	.long	1071861800
	.long	448136789
	.long	3174814192
	.long	0
	.long	1071733760
	.long	3722825728
	.long	1071878720
	.long	714165913
	.long	3173439560
	.long	0
	.long	1071723520
	.long	2522374144
	.long	1071897682
	.long	3227240353
	.long	3173394323
	.long	0
	.long	1071714304
	.long	4165410816
	.long	1071914895
	.long	1365684961
	.long	3174365060
	.long	0
	.long	1071705088
	.long	3477135360
	.long	1071932251
	.long	368482985
	.long	3174140821
	.long	0
	.long	1071695872
	.long	2079455232
	.long	1071949752
	.long	1320576317
	.long	1026822714
	.long	0
	.long	1071687680
	.long	851795968
	.long	1071965432
	.long	3702467026
	.long	1025224125
	.long	0
	.long	1071678464
	.long	647743488
	.long	1071983213
	.long	772992109
	.long	3174038459
	.long	0
	.long	1071670272
	.long	26537984
	.long	1071999146
	.long	2360214276
	.long	3174861275
	.long	0
	.long	1071661056
	.long	1547061248
	.long	1072017216
	.long	2886781435
	.long	1026423395
	.long	0
	.long	1071652864
	.long	2854492160
	.long	1072033410
	.long	215631550
	.long	1025638968
	.long	0
	.long	1071644672
	.long	4277811200
	.long	1072049730
	.long	2479318832
	.long	1026487127
	.long	4277811200
	.long	1072049730
	.long	2479318832
	.long	1026487127
	.long	64
	.long	1120927744
	.long	0
	.long	1094713344
	.long	0
	.long	1065615360
	.long	0
	.long	1135607808
	.long	0
	.long	0
	.long	0
	.long	1072693248
	.long	0
	.long	3219128320
	.long	1431655955
	.long	1070945621
	.long	610
	.long	3218079744
	.long	2545118337
	.long	1070176665
	.long	1378399119
	.long	3217380693
	.long	612435357
	.long	1069697472
	.long	94536557
	.long	3217031348
	.type	_imldLnHATab,@object
	.size	_imldLnHATab,1680
	.align 16
.L_2il0floatpacket.68:
	.long	0x00000000,0x80000000,0x00000000,0x00000000
	.type	.L_2il0floatpacket.68,@object
	.size	.L_2il0floatpacket.68,16
	.align 8
.L_2il0floatpacket.69:
	.long	0x00000000,0x3ff00000
	.type	.L_2il0floatpacket.69,@object
	.size	.L_2il0floatpacket.69,8
	.data
	.section .note.GNU-stack, ""
# End
