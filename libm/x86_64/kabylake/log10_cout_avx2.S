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
.L_2__routine_start___svml_dlog10_ha_cout_rare_internal_0:
# -- Begin  __svml_dlog10_ha_cout_rare_internal
	.text
       .align    16,0x90
	.hidden __svml_dlog10_ha_cout_rare_internal
	.globl __svml_dlog10_ha_cout_rare_internal
__svml_dlog10_ha_cout_rare_internal:
# parameter 1: %rdi
# parameter 2: %rsi
..B1.1:
       .cfi_startproc
..L1:

        movq      %rdi, %r8
        xorl      %eax, %eax
        xorl      %edi, %edi
        movzwl    6(%r8), %ecx
        movl      %ecx, %edx
        andl      $32752, %edx
        cmpl      $32752, %edx
        je        ..B1.12
..B1.2:
        movsd     (%r8), %xmm1
        movsd     %xmm1, -8(%rsp)
        testl     $32752, %ecx
        jne       ..B1.4
..B1.3:
        movsd     1600+_vmldLgHATab(%rip), %xmm0
        movl      $-60, %edi
        mulsd     %xmm0, %xmm1
        movsd     %xmm1, -8(%rsp)
..B1.4:
        movsd     1608+_vmldLgHATab(%rip), %xmm0
        comisd    %xmm0, %xmm1
        jbe       ..B1.8
..B1.5:
        movaps    %xmm1, %xmm2
        subsd     .L_2il0floatpacket.77(%rip), %xmm2
        movsd     %xmm2, -16(%rsp)
        andb      $127, -9(%rsp)
        movsd     -16(%rsp), %xmm0
        comisd    1592+_vmldLgHATab(%rip), %xmm0
        jbe       ..B1.7
..B1.6:
        movzwl    -2(%rsp), %edx
        pxor      %xmm6, %xmm6
        andl      $32752, %edx
        lea       _vmldLgHATab(%rip), %r10
        shrl      $4, %edx
        movsd     %xmm1, -16(%rsp)
        movsd     1688+_vmldLgHATab(%rip), %xmm7
        movsd     1560+_vmldLgHATab(%rip), %xmm10
        movsd     1568+_vmldLgHATab(%rip), %xmm0
        lea       -1023(%rdi,%rdx), %ecx
        movzwl    -10(%rsp), %edi
        andl      $-32753, %edi
        addl      $16368, %edi
        movw      %di, -10(%rsp)
        movsd     -16(%rsp), %xmm3
        movaps    %xmm3, %xmm1
        movaps    %xmm3, %xmm2
        cvtsi2sd  %ecx, %xmm6
        addsd     1576+_vmldLgHATab(%rip), %xmm1
        addsd     1584+_vmldLgHATab(%rip), %xmm2
        mulsd     %xmm6, %xmm10
        mulsd     %xmm0, %xmm6
        movsd     %xmm1, -24(%rsp)
        movl      -24(%rsp), %r8d
        movsd     %xmm2, -24(%rsp)
        andl      $127, %r8d
        movsd     -24(%rsp), %xmm8
        subsd     1584+_vmldLgHATab(%rip), %xmm8
        lea       (%r8,%r8,2), %r9d
        movsd     (%r10,%r9,8), %xmm9
        subsd     %xmm8, %xmm3
        mulsd     %xmm9, %xmm8
        addsd     16(%r10,%r9,8), %xmm6
        addsd     8(%r10,%r9,8), %xmm10
        mulsd     %xmm3, %xmm9
        subsd     1624+_vmldLgHATab(%rip), %xmm8
        movaps    %xmm8, %xmm4
        movaps    %xmm9, %xmm5
        addsd     %xmm9, %xmm4
        addsd     %xmm8, %xmm10
        mulsd     %xmm4, %xmm7
        addsd     1680+_vmldLgHATab(%rip), %xmm7
        mulsd     %xmm4, %xmm7
        addsd     1672+_vmldLgHATab(%rip), %xmm7
        mulsd     %xmm4, %xmm7
        addsd     1664+_vmldLgHATab(%rip), %xmm7
        mulsd     %xmm4, %xmm7
        addsd     1656+_vmldLgHATab(%rip), %xmm7
        mulsd     %xmm4, %xmm7
        addsd     1648+_vmldLgHATab(%rip), %xmm7
        mulsd     %xmm4, %xmm7
        addsd     1640+_vmldLgHATab(%rip), %xmm7
        mulsd     %xmm4, %xmm7
        addsd     1632+_vmldLgHATab(%rip), %xmm7
        mulsd     %xmm7, %xmm5
        mulsd     %xmm7, %xmm8
        addsd     %xmm5, %xmm6
        addsd     %xmm6, %xmm9
        addsd     %xmm8, %xmm9
        addsd     %xmm9, %xmm10
        movsd     %xmm10, (%rsi)
        ret
..B1.7:
        movsd     1624+_vmldLgHATab(%rip), %xmm0
        mulsd     %xmm0, %xmm2
        movsd     1688+_vmldLgHATab(%rip), %xmm1
        mulsd     %xmm2, %xmm1
        addsd     1680+_vmldLgHATab(%rip), %xmm1
        mulsd     %xmm2, %xmm1
        addsd     1672+_vmldLgHATab(%rip), %xmm1
        mulsd     %xmm2, %xmm1
        addsd     1664+_vmldLgHATab(%rip), %xmm1
        mulsd     %xmm2, %xmm1
        addsd     1656+_vmldLgHATab(%rip), %xmm1
        mulsd     %xmm2, %xmm1
        addsd     1648+_vmldLgHATab(%rip), %xmm1
        mulsd     %xmm2, %xmm1
        addsd     1640+_vmldLgHATab(%rip), %xmm1
        mulsd     %xmm2, %xmm1
        addsd     1632+_vmldLgHATab(%rip), %xmm1
        mulsd     %xmm2, %xmm1
        addsd     %xmm1, %xmm2
        movsd     %xmm2, (%rsi)
        ret
..B1.8:
        ucomisd   %xmm0, %xmm1
        jp        ..B1.9
        je        ..B1.11
..B1.9:
        divsd     %xmm0, %xmm0
        movsd     %xmm0, (%rsi)
        movl      $1, %eax
..B1.10:
        ret
..B1.11:
        movsd     1616+_vmldLgHATab(%rip), %xmm1
        movl      $2, %eax
        xorps     .L_2il0floatpacket.76(%rip), %xmm1
        divsd     %xmm0, %xmm1
        movsd     %xmm1, (%rsi)
        ret
..B1.12:
        movb      7(%r8), %dl
        andb      $-128, %dl
        cmpb      $-128, %dl
        je        ..B1.14
..B1.13:
        movsd     (%r8), %xmm0
        mulsd     %xmm0, %xmm0
        movsd     %xmm0, (%rsi)
        ret
..B1.14:
        testl     $1048575, 4(%r8)
        jne       ..B1.13
..B1.15:
        cmpl      $0, (%r8)
        jne       ..B1.13
..B1.16:
        movsd     1608+_vmldLgHATab(%rip), %xmm0
        movl      $1, %eax
        divsd     %xmm0, %xmm0
        movsd     %xmm0, (%rsi)
        ret
        .align    16,0x90
	.cfi_endproc
	.type	__svml_dlog10_ha_cout_rare_internal,@function
	.size	__svml_dlog10_ha_cout_rare_internal,.-__svml_dlog10_ha_cout_rare_internal
..LN__svml_dlog10_ha_cout_rare_internal.0:
	.data
# -- End  __svml_dlog10_ha_cout_rare_internal
	.section .rodata, "a"
	.align 32
	.align 32
_vmldLgHATab:
	.long	0
	.long	1071366144
	.long	0
	.long	0
	.long	0
	.long	0
	.long	0
	.long	1071337728
	.long	184549376
	.long	1065092008
	.long	2099961998
	.long	3178897324
	.long	0
	.long	1071309312
	.long	931135488
	.long	1066155272
	.long	2365712557
	.long	3178155773
	.long	0
	.long	1071280896
	.long	603979776
	.long	1066752445
	.long	709057215
	.long	1031474920
	.long	0
	.long	1071252480
	.long	3437232128
	.long	1067234191
	.long	1515412199
	.long	3179085970
	.long	0
	.long	1071238272
	.long	1105723392
	.long	1067464226
	.long	153915826
	.long	3178000698
	.long	0
	.long	1071209856
	.long	3328442368
	.long	1067711223
	.long	3899912278
	.long	3177135692
	.long	0
	.long	1071181440
	.long	341835776
	.long	1067962480
	.long	2509208190
	.long	3176531222
	.long	0
	.long	1071167232
	.long	2884632576
	.long	1068089751
	.long	1030636902
	.long	1025224143
	.long	0
	.long	1071138816
	.long	3613917184
	.long	1068347678
	.long	3527163461
	.long	3177529532
	.long	0
	.long	1071124608
	.long	3549954048
	.long	1068478374
	.long	3498894081
	.long	3173000425
	.long	0
	.long	1071096192
	.long	1623785472
	.long	1068621140
	.long	2889825554
	.long	3176375375
	.long	0
	.long	1071081984
	.long	1085800448
	.long	1068688295
	.long	4015256301
	.long	3177184346
	.long	0
	.long	1071053568
	.long	3652976640
	.long	1068824490
	.long	3600693529
	.long	3175753877
	.long	0
	.long	1071039360
	.long	1592393728
	.long	1068893555
	.long	231073830
	.long	3177087939
	.long	0
	.long	1071025152
	.long	3459645440
	.long	1068963280
	.long	1740576090
	.long	1029619435
	.long	0
	.long	1070996736
	.long	3774611456
	.long	1069104765
	.long	3858552785
	.long	1028603845
	.long	0
	.long	1070982528
	.long	845086720
	.long	1069176552
	.long	3138879731
	.long	1029120443
	.long	0
	.long	1070968320
	.long	3513843712
	.long	1069249052
	.long	2107125367
	.long	1029044389
	.long	0
	.long	1070954112
	.long	434503680
	.long	1069322282
	.long	3827602229
	.long	1028932700
	.long	0
	.long	1070939904
	.long	3613851648
	.long	1069396254
	.long	1223751955
	.long	3176465139
	.long	0
	.long	1070911488
	.long	733741056
	.long	1069546492
	.long	1625232067
	.long	1029570781
	.long	0
	.long	1070897280
	.long	1511620608
	.long	1069585154
	.long	3044605139
	.long	1028090775
	.long	0
	.long	1070883072
	.long	1337196544
	.long	1069623706
	.long	2602639001
	.long	3175938675
	.long	0
	.long	1070868864
	.long	2572533760
	.long	1069662670
	.long	3067107955
	.long	1022933137
	.long	0
	.long	1070854656
	.long	559611904
	.long	1069702056
	.long	764145786
	.long	3174041535
	.long	0
	.long	1070840448
	.long	485818368
	.long	1069741872
	.long	2037567072
	.long	3175580956
	.long	0
	.long	1070826240
	.long	259604480
	.long	1069782128
	.long	4012068429
	.long	1027865895
	.long	0
	.long	1070812032
	.long	3454042112
	.long	1069822833
	.long	2867680007
	.long	3174202478
	.long	0
	.long	1070797824
	.long	2188754944
	.long	1069863999
	.long	2538655286
	.long	3175840981
	.long	0
	.long	1070783616
	.long	2965241856
	.long	1069905635
	.long	1338936972
	.long	3176093950
	.long	0
	.long	1070769408
	.long	966279168
	.long	1069947753
	.long	1774547674
	.long	3175051484
	.long	0
	.long	1070755200
	.long	1604042752
	.long	1069990363
	.long	2557470738
	.long	3174667448
	.long	0
	.long	1070740992
	.long	3417833472
	.long	1070033477
	.long	2268255117
	.long	3175678264
	.long	0
	.long	1070740992
	.long	3417833472
	.long	1070033477
	.long	2268255117
	.long	3175678264
	.long	0
	.long	1070726784
	.long	2451292160
	.long	1070077108
	.long	3757728941
	.long	1027943275
	.long	0
	.long	1070712576
	.long	929644544
	.long	1070121268
	.long	899045708
	.long	1027944939
	.long	0
	.long	1070698368
	.long	3057254400
	.long	1070165969
	.long	3880649376
	.long	3172972504
	.long	0
	.long	1070684160
	.long	2231091200
	.long	1070211226
	.long	521319256
	.long	1027600177
	.long	0
	.long	1070684160
	.long	2231091200
	.long	1070211226
	.long	521319256
	.long	1027600177
	.long	0
	.long	1070669952
	.long	2620162048
	.long	1070257052
	.long	1385613369
	.long	3176104036
	.long	0
	.long	1070655744
	.long	2096726016
	.long	1070303462
	.long	3138305819
	.long	3173646777
	.long	0
	.long	1070641536
	.long	944717824
	.long	1070350471
	.long	1065120110
	.long	1027539054
	.long	0
	.long	1070641536
	.long	944717824
	.long	1070350471
	.long	1065120110
	.long	1027539054
	.long	0
	.long	1070627328
	.long	1985789952
	.long	1070398094
	.long	3635943864
	.long	3173136490
	.long	0
	.long	1070613120
	.long	2123825152
	.long	1070446348
	.long	1125219725
	.long	3175615738
	.long	0
	.long	1070598912
	.long	1078378496
	.long	1070495250
	.long	603852726
	.long	3174570526
	.long	0
	.long	1070598912
	.long	1078378496
	.long	1070495250
	.long	603852726
	.long	3174570526
	.long	0
	.long	1070573312
	.long	1537933312
	.long	1070544817
	.long	998069198
	.long	1026662908
	.long	0
	.long	1070544896
	.long	733773824
	.long	1070595068
	.long	4061058002
	.long	3174036009
	.long	0
	.long	1070544896
	.long	733773824
	.long	1070595068
	.long	4061058002
	.long	3174036009
	.long	0
	.long	1070516480
	.long	3897544704
	.long	1070621058
	.long	951856294
	.long	1026731877
	.long	0
	.long	1070516480
	.long	3897544704
	.long	1070621058
	.long	951856294
	.long	1026731877
	.long	0
	.long	1070488064
	.long	493535232
	.long	1070646897
	.long	3852369308
	.long	3173264746
	.long	0
	.long	1070459648
	.long	463249408
	.long	1070673107
	.long	2853152111
	.long	3174564937
	.long	0
	.long	1070459648
	.long	463249408
	.long	1070673107
	.long	2853152111
	.long	3174564937
	.long	0
	.long	1070431232
	.long	3186585600
	.long	1070699699
	.long	1874718356
	.long	3174139933
	.long	0
	.long	1070431232
	.long	3186585600
	.long	1070699699
	.long	1874718356
	.long	3174139933
	.long	0
	.long	1070402816
	.long	1525858304
	.long	1070726686
	.long	3039843523
	.long	1024724665
	.long	0
	.long	1070402816
	.long	1525858304
	.long	1070726686
	.long	3039843523
	.long	1024724665
	.long	0
	.long	1070374400
	.long	3425300480
	.long	1070754078
	.long	1303046649
	.long	1022401701
	.long	0
	.long	1070374400
	.long	3425300480
	.long	1070754078
	.long	1303046649
	.long	1022401701
	.long	0
	.long	1070345984
	.long	1980465152
	.long	1070781889
	.long	3188656319
	.long	1027271390
	.long	0
	.long	1070345984
	.long	1980465152
	.long	1070781889
	.long	3188656319
	.long	1027271390
	.long	0
	.long	1070317568
	.long	1352630272
	.long	1070810131
	.long	3090895658
	.long	3174564915
	.long	1352630272
	.long	1070810131
	.long	3090895658
	.long	3174564915
	.long	64
	.long	1120927744
	.long	0
	.long	1096810496
	.long	0
	.long	1064828928
	.long	0
	.long	1135607808
	.long	0
	.long	0
	.long	0
	.long	1072693248
	.long	0
	.long	1071366144
	.long	3207479559
	.long	1062894188
	.long	3698831637
	.long	3220339442
	.long	3700832817
	.long	1073506818
	.long	1691624569
	.long	3221787401
	.long	2065628764
	.long	1075227551
	.long	1770847080
	.long	3223701774
	.long	3786517112
	.long	1077250450
	.long	1316351650
	.long	3225793313
	.type	_vmldLgHATab,@object
	.size	_vmldLgHATab,1696
	.align 16
.L_2il0floatpacket.76:
	.long	0x00000000,0x80000000,0x00000000,0x00000000
	.type	.L_2il0floatpacket.76,@object
	.size	.L_2il0floatpacket.76,16
	.align 8
.L_2il0floatpacket.77:
	.long	0x00000000,0x3ff00000
	.type	.L_2il0floatpacket.77,@object
	.size	.L_2il0floatpacket.77,8
	.data
	.section .note.GNU-stack, ""
# End
