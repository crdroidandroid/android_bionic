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
.L_2__routine_start___svml_dsinh_ha_cout_rare_internal_0:
# -- Begin  __svml_dsinh_ha_cout_rare_internal
	.text
       .align    16,0x90
	.hidden __svml_dsinh_ha_cout_rare_internal
	.globl __svml_dsinh_ha_cout_rare_internal
__svml_dsinh_ha_cout_rare_internal:
# parameter 1: %rdi
# parameter 2: %rsi
..B1.1:
	.cfi_startproc
..L1:

        movq      %rsi, %r9
        movzwl    6(%rdi), %ecx
        xorl      %eax, %eax
        andl      $32752, %ecx
        shrl      $4, %ecx
        movsd     (%rdi), %xmm2
        movb      7(%rdi), %dl
        movsd     %xmm2, -8(%rsp)
        cmpl      $2047, %ecx
        je        ..B1.17
..B1.2:
        testl     %ecx, %ecx
        jle       ..B1.16
..B1.3:
        andb      $127, %dl
        movsd     %xmm2, -32(%rsp)
        movb      %dl, -25(%rsp)
        cmpl      $969, %ecx
        jle       ..B1.14
..B1.4:
        movsd     -32(%rsp), %xmm0
        movsd     1136+_vmldSinhHATab(%rip), %xmm1
        comisd    %xmm0, %xmm1
        jbe       ..B1.13
..B1.5:
        movsd     1184+_vmldSinhHATab(%rip), %xmm1
        comisd    %xmm0, %xmm1
        jbe       ..B1.9
..B1.6:
        comisd    1176+_vmldSinhHATab(%rip), %xmm0
        jb        ..B1.8
..B1.7:
        movsd     1112+_vmldSinhHATab(%rip), %xmm5
        lea       _vmldSinhHATab(%rip), %rcx
        mulsd     %xmm0, %xmm5
        movsd     1144+_vmldSinhHATab(%rip), %xmm11
        movsd     1128+_vmldSinhHATab(%rip), %xmm8
        movq      8+_vmldSinhHATab(%rip), %r10
        movq      %r10, %rsi
        shrq      $48, %rsi
        addsd     1120+_vmldSinhHATab(%rip), %xmm5
        movsd     %xmm5, -40(%rsp)
        andl      $-32753, %esi
        movsd     -40(%rsp), %xmm2
        movl      -40(%rsp), %r8d
        movl      %r8d, %r11d
        shrl      $6, %r11d
        andl      $63, %r8d
        movq      %r10, -16(%rsp)
        subsd     1120+_vmldSinhHATab(%rip), %xmm2
        mulsd     %xmm2, %xmm11
        lea       1023(%r11), %edi
        xorps     .L_2il0floatpacket.86(%rip), %xmm2
        addl      $1022, %r11d
        mulsd     1152+_vmldSinhHATab(%rip), %xmm2
        subsd     %xmm11, %xmm0
        movaps    %xmm0, %xmm10
        movaps    %xmm0, %xmm4
        andl      $2047, %r11d
        lea       (%r8,%r8), %edx
        negl      %edi
        lea       1(%r8,%r8), %r8d
        shll      $4, %r11d
        addl      $-4, %edi
        orl       %r11d, %esi
        andl      $2047, %edi
        movw      %si, -10(%rsp)
        andl      $-32753, %esi
        shll      $4, %edi
        addsd     %xmm2, %xmm10
        movsd     %xmm10, -24(%rsp)
        orl       %edi, %esi
        movsd     -24(%rsp), %xmm1
        subsd     %xmm1, %xmm4
        movsd     -16(%rsp), %xmm1
        movsd     %xmm4, -56(%rsp)
        movsd     -24(%rsp), %xmm13
        movsd     -56(%rsp), %xmm12
        movw      %si, -10(%rsp)
        addsd     %xmm12, %xmm13
        movsd     %xmm13, -48(%rsp)
        movsd     -56(%rsp), %xmm14
        movsd     -16(%rsp), %xmm4
        addsd     %xmm14, %xmm2
        movsd     %xmm2, -56(%rsp)
        movsd     -48(%rsp), %xmm15
        movsd     1072+_vmldSinhHATab(%rip), %xmm13
        subsd     %xmm15, %xmm0
        movsd     %xmm0, -48(%rsp)
        movsd     -56(%rsp), %xmm3
        movsd     -48(%rsp), %xmm0
        movsd     1064+_vmldSinhHATab(%rip), %xmm12
        addsd     %xmm0, %xmm3
        movsd     %xmm3, -48(%rsp)
        movsd     -24(%rsp), %xmm14
        mulsd     %xmm14, %xmm8
        movaps    %xmm14, %xmm11
        movsd     -48(%rsp), %xmm15
        movaps    %xmm14, %xmm0
        movsd     %xmm8, -24(%rsp)
        movsd     -24(%rsp), %xmm6
        mulsd     %xmm14, %xmm0
        subsd     %xmm14, %xmm6
        movsd     %xmm6, -56(%rsp)
        movsd     -24(%rsp), %xmm7
        movsd     -56(%rsp), %xmm9
        mulsd     %xmm0, %xmm13
        subsd     %xmm9, %xmm7
        mulsd     %xmm0, %xmm12
        addsd     1056+_vmldSinhHATab(%rip), %xmm13
        addsd     1048+_vmldSinhHATab(%rip), %xmm12
        mulsd     %xmm0, %xmm13
        mulsd     %xmm0, %xmm12
        addsd     1040+_vmldSinhHATab(%rip), %xmm13
        mulsd     %xmm14, %xmm12
        mulsd     %xmm0, %xmm13
        movsd     (%rcx,%rdx,8), %xmm9
        negl      %edx
        movsd     %xmm7, -24(%rsp)
        mulsd     %xmm1, %xmm9
        movsd     -24(%rsp), %xmm5
        lea       128(%rdx), %esi
        movsd     (%rcx,%rsi,8), %xmm7
        movaps    %xmm9, %xmm2
        mulsd     %xmm4, %xmm7
        subsd     %xmm5, %xmm11
        movsd     %xmm11, -56(%rsp)
        movaps    %xmm9, %xmm5
        movsd     -24(%rsp), %xmm11
        addl      $129, %edx
        movsd     -56(%rsp), %xmm10
        subsd     %xmm7, %xmm2
        movsd     %xmm2, -24(%rsp)
        movsd     -24(%rsp), %xmm3
        movsd     (%rcx,%rdx,8), %xmm6
        subsd     %xmm3, %xmm5
        mulsd     %xmm4, %xmm6
        subsd     %xmm7, %xmm5
        movsd     %xmm5, -56(%rsp)
        movsd     -24(%rsp), %xmm5
        movsd     -56(%rsp), %xmm4
        movaps    %xmm5, %xmm0
        movsd     (%rcx,%r8,8), %xmm8
        subsd     %xmm6, %xmm4
        mulsd     %xmm1, %xmm8
        movb      -1(%rsp), %cl
        addsd     %xmm8, %xmm4
        addsd     %xmm6, %xmm8
        addsd     %xmm4, %xmm0
        movsd     %xmm0, -24(%rsp)
        movaps    %xmm9, %xmm0
        movsd     -24(%rsp), %xmm1
        andb      $-128, %cl
        subsd     %xmm1, %xmm5
        movsd     1128+_vmldSinhHATab(%rip), %xmm1
        addsd     %xmm7, %xmm0
        addsd     %xmm4, %xmm5
        movsd     %xmm5, -56(%rsp)
        movsd     -24(%rsp), %xmm5
        movsd     -56(%rsp), %xmm4
        movsd     %xmm0, -24(%rsp)
        movsd     -24(%rsp), %xmm2
        subsd     %xmm2, %xmm9
        addsd     %xmm7, %xmm9
        movsd     %xmm9, -56(%rsp)
        movsd     -24(%rsp), %xmm0
        movsd     -56(%rsp), %xmm9
        movaps    %xmm0, %xmm6
        addsd     %xmm8, %xmm9
        addsd     %xmm9, %xmm6
        movsd     %xmm6, -24(%rsp)
        movsd     -24(%rsp), %xmm8
        subsd     %xmm8, %xmm0
        addsd     %xmm9, %xmm0
        movaps    %xmm15, %xmm9
        movsd     %xmm0, -56(%rsp)
        movsd     -24(%rsp), %xmm2
        mulsd     %xmm2, %xmm1
        mulsd     %xmm2, %xmm15
        movsd     -56(%rsp), %xmm3
        movsd     %xmm1, -24(%rsp)
        movaps    %xmm2, %xmm1
        movsd     -24(%rsp), %xmm6
        mulsd     %xmm3, %xmm9
        subsd     %xmm2, %xmm6
        mulsd     %xmm3, %xmm14
        movsd     %xmm6, -56(%rsp)
        movaps    %xmm3, %xmm6
        mulsd     %xmm12, %xmm6
        mulsd     %xmm2, %xmm12
        addsd     %xmm6, %xmm9
        movsd     -24(%rsp), %xmm8
        movsd     -56(%rsp), %xmm7
        subsd     %xmm7, %xmm8
        movaps    %xmm4, %xmm7
        mulsd     %xmm13, %xmm7
        mulsd     %xmm5, %xmm13
        addsd     %xmm7, %xmm9
        movsd     %xmm8, -24(%rsp)
        addsd     %xmm14, %xmm9
        movsd     -24(%rsp), %xmm0
        movaps    %xmm12, %xmm14
        subsd     %xmm0, %xmm1
        addsd     %xmm13, %xmm14
        addsd     %xmm15, %xmm9
        movsd     %xmm1, -56(%rsp)
        addsd     %xmm9, %xmm4
        movsd     -24(%rsp), %xmm1
        movsd     -56(%rsp), %xmm0
        movsd     %xmm14, -24(%rsp)
        movsd     -24(%rsp), %xmm15
        subsd     %xmm15, %xmm12
        addsd     %xmm13, %xmm12
        movsd     %xmm12, -56(%rsp)
        movaps    %xmm10, %xmm12
        movsd     -24(%rsp), %xmm2
        movsd     -56(%rsp), %xmm3
        mulsd     %xmm0, %xmm12
        addsd     %xmm4, %xmm3
        mulsd     %xmm11, %xmm0
        mulsd     %xmm1, %xmm10
        addsd     %xmm12, %xmm3
        mulsd     %xmm1, %xmm11
        addsd     %xmm0, %xmm3
        movaps    %xmm5, %xmm0
        addsd     %xmm10, %xmm3
        movaps    %xmm11, %xmm10
        addsd     %xmm2, %xmm10
        movsd     %xmm10, -24(%rsp)
        movsd     -24(%rsp), %xmm13
        subsd     %xmm13, %xmm11
        addsd     %xmm2, %xmm11
        movsd     %xmm11, -56(%rsp)
        movsd     -24(%rsp), %xmm4
        movsd     -56(%rsp), %xmm6
        addsd     %xmm4, %xmm0
        addsd     %xmm3, %xmm6
        movsd     %xmm0, -24(%rsp)
        movsd     -24(%rsp), %xmm1
        subsd     %xmm1, %xmm5
        addsd     %xmm4, %xmm5
        movsd     %xmm5, -56(%rsp)
        movsd     -24(%rsp), %xmm5
        movsd     -56(%rsp), %xmm7
        addsd     %xmm6, %xmm7
        addsd     %xmm5, %xmm7
        movsd     %xmm7, -32(%rsp)
        movb      -25(%rsp), %dil
        andb      $127, %dil
        orb       %cl, %dil
        movb      %dil, -25(%rsp)
        movq      -32(%rsp), %r10
        movq      %r10, (%r9)
        ret
..B1.8:
        movaps    %xmm0, %xmm2
        mulsd     %xmm0, %xmm2
        movsd     1104+_vmldSinhHATab(%rip), %xmm1
        mulsd     %xmm2, %xmm1
        movb      -1(%rsp), %dl
        andb      $-128, %dl
        addsd     1096+_vmldSinhHATab(%rip), %xmm1
        mulsd     %xmm2, %xmm1
        addsd     1088+_vmldSinhHATab(%rip), %xmm1
        mulsd     %xmm2, %xmm1
        addsd     1080+_vmldSinhHATab(%rip), %xmm1
        mulsd     %xmm1, %xmm2
        mulsd     %xmm0, %xmm2
        addsd     %xmm2, %xmm0
        movsd     %xmm0, -32(%rsp)
        movb      -25(%rsp), %cl
        andb      $127, %cl
        orb       %dl, %cl
        movb      %cl, -25(%rsp)
        movq      -32(%rsp), %rsi
        movq      %rsi, (%r9)
        ret
..B1.9:
        movsd     1112+_vmldSinhHATab(%rip), %xmm1
        lea       _vmldSinhHATab(%rip), %r8
        mulsd     %xmm0, %xmm1
        movsd     1144+_vmldSinhHATab(%rip), %xmm2
        movsd     1152+_vmldSinhHATab(%rip), %xmm3
        movq      8+_vmldSinhHATab(%rip), %rdx
        movq      %rdx, -16(%rsp)
        addsd     1120+_vmldSinhHATab(%rip), %xmm1
        movsd     %xmm1, -40(%rsp)
        movsd     -40(%rsp), %xmm4
        movsd     1072+_vmldSinhHATab(%rip), %xmm1
        movl      -40(%rsp), %edx
        movl      %edx, %esi
        andl      $63, %esi
        subsd     1120+_vmldSinhHATab(%rip), %xmm4
        mulsd     %xmm4, %xmm2
        lea       (%rsi,%rsi), %ecx
        mulsd     %xmm3, %xmm4
        subsd     %xmm2, %xmm0
        shrl      $6, %edx
        lea       1(%rsi,%rsi), %edi
        addl      $1022, %edx
        subsd     %xmm4, %xmm0
        mulsd     %xmm0, %xmm1
        andl      $2047, %edx
        addsd     1064+_vmldSinhHATab(%rip), %xmm1
        mulsd     %xmm0, %xmm1
        addsd     1056+_vmldSinhHATab(%rip), %xmm1
        mulsd     %xmm0, %xmm1
        addsd     1048+_vmldSinhHATab(%rip), %xmm1
        mulsd     %xmm0, %xmm1
        addsd     1040+_vmldSinhHATab(%rip), %xmm1
        mulsd     %xmm0, %xmm1
        mulsd     %xmm0, %xmm1
        addsd     %xmm0, %xmm1
        movsd     (%r8,%rcx,8), %xmm0
        mulsd     %xmm0, %xmm1
        addsd     (%r8,%rdi,8), %xmm1
        addsd     %xmm0, %xmm1
        cmpl      $2046, %edx
        ja        ..B1.11
..B1.10:
        movq      8+_vmldSinhHATab(%rip), %rcx
        shrq      $48, %rcx
        shll      $4, %edx
        andl      $-32753, %ecx
        orl       %edx, %ecx
        movw      %cx, -10(%rsp)
        movsd     -16(%rsp), %xmm0
        mulsd     %xmm0, %xmm1
        movsd     %xmm1, -32(%rsp)
        jmp       ..B1.12
..B1.11:
        decl      %edx
        andl      $2047, %edx
        movzwl    -10(%rsp), %ecx
        shll      $4, %edx
        andl      $-32753, %ecx
        orl       %edx, %ecx
        movw      %cx, -10(%rsp)
        movsd     -16(%rsp), %xmm0
        mulsd     %xmm0, %xmm1
        mulsd     1024+_vmldSinhHATab(%rip), %xmm1
        movsd     %xmm1, -32(%rsp)
..B1.12:
        movb      -25(%rsp), %cl
        movb      -1(%rsp), %dl
        andb      $127, %cl
        andb      $-128, %dl
        orb       %dl, %cl
        movb      %cl, -25(%rsp)
        movq      -32(%rsp), %rsi
        movq      %rsi, (%r9)
        ret
..B1.13:
        movsd     1168+_vmldSinhHATab(%rip), %xmm0
        movl      $3, %eax
        mulsd     %xmm2, %xmm0
        movsd     %xmm0, (%r9)
        ret
..B1.14:
        movsd     _vmldSinhHATab(%rip), %xmm0
        addsd     1160+_vmldSinhHATab(%rip), %xmm0
        mulsd     %xmm2, %xmm0
        movsd     %xmm0, (%r9)
..B1.15:
        ret
..B1.16:
        movsd     1160+_vmldSinhHATab(%rip), %xmm0
        mulsd     %xmm0, %xmm2
        movsd     %xmm2, -24(%rsp)
        movsd     -24(%rsp), %xmm1
        movq      8+_vmldSinhHATab(%rip), %rdx
        movq      %rdx, -16(%rsp)
        addsd     -8(%rsp), %xmm1
        movsd     %xmm1, (%r9)
        ret
..B1.17:
        addsd     %xmm2, %xmm2
        movsd     %xmm2, (%r9)
        ret
        .align    16,0x90
	.cfi_endproc
	.type	__svml_dsinh_ha_cout_rare_internal,@function
	.size	__svml_dsinh_ha_cout_rare_internal,.-__svml_dsinh_ha_cout_rare_internal
..LN__svml_dsinh_ha_cout_rare_internal.0:
	.data
# -- End  __svml_dsinh_ha_cout_rare_internal
	.section .rodata, "a"
	.align 32
	.align 32
_vmldSinhHATab:
	.long	0
	.long	1072693248
	.long	0
	.long	0
	.long	1048019041
	.long	1072704666
	.long	1398474845
	.long	3161559171
	.long	3541402996
	.long	1072716208
	.long	2759177317
	.long	1015903202
	.long	410360776
	.long	1072727877
	.long	1269990655
	.long	1013024446
	.long	1828292879
	.long	1072739672
	.long	1255956747
	.long	1016636974
	.long	852742562
	.long	1072751596
	.long	667253587
	.long	1010842135
	.long	3490863953
	.long	1072763649
	.long	960797498
	.long	3163997456
	.long	2930322912
	.long	1072775834
	.long	2599499422
	.long	3163762623
	.long	1014845819
	.long	1072788152
	.long	3117910646
	.long	3162607681
	.long	3949972341
	.long	1072800603
	.long	2068408548
	.long	1015962444
	.long	828946858
	.long	1072813191
	.long	10642492
	.long	1016988014
	.long	2288159958
	.long	1072825915
	.long	2169144469
	.long	1015924597
	.long	1853186616
	.long	1072838778
	.long	3066496371
	.long	1016705150
	.long	1709341917
	.long	1072851781
	.long	2571168217
	.long	1015201075
	.long	4112506593
	.long	1072864925
	.long	2947355221
	.long	1015419624
	.long	2799960843
	.long	1072878213
	.long	1423655381
	.long	1016070727
	.long	171030293
	.long	1072891646
	.long	3526460132
	.long	1015477354
	.long	2992903935
	.long	1072905224
	.long	2218154406
	.long	1016276769
	.long	926591435
	.long	1072918951
	.long	3208833762
	.long	3163962090
	.long	887463927
	.long	1072932827
	.long	3596744163
	.long	3161842742
	.long	1276261410
	.long	1072946854
	.long	300981948
	.long	1015732745
	.long	569847338
	.long	1072961034
	.long	472945272
	.long	3160339305
	.long	1617004845
	.long	1072975368
	.long	82804944
	.long	1011391354
	.long	3049340112
	.long	1072989858
	.long	3062915824
	.long	1014219171
	.long	3577096743
	.long	1073004506
	.long	2951496418
	.long	1014842263
	.long	1990012071
	.long	1073019314
	.long	3529070563
	.long	3163861769
	.long	1453150082
	.long	1073034283
	.long	498154669
	.long	3162536638
	.long	917841882
	.long	1073049415
	.long	18715565
	.long	1016707884
	.long	3712504873
	.long	1073064711
	.long	88491949
	.long	1016476236
	.long	363667784
	.long	1073080175
	.long	813753950
	.long	1016833785
	.long	2956612997
	.long	1073095806
	.long	2118169751
	.long	3163784129
	.long	2186617381
	.long	1073111608
	.long	2270764084
	.long	3164321289
	.long	1719614413
	.long	1073127582
	.long	330458198
	.long	3164331316
	.long	1013258799
	.long	1073143730
	.long	1748797611
	.long	3161177658
	.long	3907805044
	.long	1073160053
	.long	2257091225
	.long	3162598983
	.long	1447192521
	.long	1073176555
	.long	1462857171
	.long	3163563097
	.long	1944781191
	.long	1073193236
	.long	3993278767
	.long	3162772855
	.long	919555682
	.long	1073210099
	.long	3121969534
	.long	1013996802
	.long	2571947539
	.long	1073227145
	.long	3558159064
	.long	3164425245
	.long	2604962541
	.long	1073244377
	.long	2614425274
	.long	3164587768
	.long	1110089947
	.long	1073261797
	.long	1451641639
	.long	1016523249
	.long	2568320822
	.long	1073279406
	.long	2732824428
	.long	1015401491
	.long	2966275557
	.long	1073297207
	.long	2176155324
	.long	3160891335
	.long	2682146384
	.long	1073315202
	.long	2082178513
	.long	3164411995
	.long	2191782032
	.long	1073333393
	.long	2960257726
	.long	1014791238
	.long	2069751141
	.long	1073351782
	.long	1562170675
	.long	3163773257
	.long	2990417245
	.long	1073370371
	.long	3683467745
	.long	3164417902
	.long	1434058175
	.long	1073389163
	.long	251133233
	.long	1016134345
	.long	2572866477
	.long	1073408159
	.long	878562433
	.long	1016570317
	.long	3092190715
	.long	1073427362
	.long	814012168
	.long	3160571998
	.long	4076559943
	.long	1073446774
	.long	2119478331
	.long	3161806927
	.long	2420883922
	.long	1073466398
	.long	2049810052
	.long	1015168464
	.long	3716502172
	.long	1073486235
	.long	2303740125
	.long	1015091301
	.long	777507147
	.long	1073506289
	.long	4282924205
	.long	1016236109
	.long	3706687593
	.long	1073526560
	.long	3521726939
	.long	1014301643
	.long	1242007932
	.long	1073547053
	.long	1132034716
	.long	3164388407
	.long	3707479175
	.long	1073567768
	.long	3613079303
	.long	1015213314
	.long	64696965
	.long	1073588710
	.long	1768797490
	.long	1016865536
	.long	863738719
	.long	1073609879
	.long	1326992220
	.long	3163661773
	.long	3884662774
	.long	1073631278
	.long	2158611599
	.long	1015258761
	.long	2728693978
	.long	1073652911
	.long	396109971
	.long	3164511267
	.long	3999357479
	.long	1073674779
	.long	2258941616
	.long	1016973300
	.long	1533953344
	.long	1073696886
	.long	769171851
	.long	1016714209
	.long	2174652632
	.long	1073719233
	.long	4087714590
	.long	1015498835
	.long	0
	.long	1073741824
	.long	0
	.long	0
	.long	0
	.long	1071644672
	.long	1431652600
	.long	1069897045
	.long	1431670732
	.long	1067799893
	.long	984555731
	.long	1065423122
	.long	472530941
	.long	1062650218
	.long	1431655765
	.long	1069897045
	.long	286331153
	.long	1065423121
	.long	436314138
	.long	1059717536
	.long	2773927732
	.long	1053236707
	.long	1697350398
	.long	1079448903
	.long	0
	.long	1127743488
	.long	33554432
	.long	1101004800
	.long	2411329662
	.long	1082536910
	.long	4277796864
	.long	1065758274
	.long	3164486458
	.long	1025308570
	.long	1
	.long	1048576
	.long	4294967295
	.long	2146435071
	.long	3671843104
	.long	1067178892
	.long	3875694624
	.long	1077247184
	.type	_vmldSinhHATab,@object
	.size	_vmldSinhHATab,1192
	.space 8, 0x00 	# pad
	.align 16
.L_2il0floatpacket.86:
	.long	0x00000000,0x80000000,0x00000000,0x00000000
	.type	.L_2il0floatpacket.86,@object
	.size	.L_2il0floatpacket.86,16
	.data
	.section .note.GNU-stack, ""
# End
