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
.L_2__routine_start___svml_dhypot_ha_cout_rare_internal_0:
# -- Begin  __svml_dhypot_ha_cout_rare_internal
	.text
       .align    16,0x90
	.hidden __svml_dhypot_ha_cout_rare_internal
	.globl __svml_dhypot_ha_cout_rare_internal
__svml_dhypot_ha_cout_rare_internal:
# parameter 1: %rdi
# parameter 2: %rsi
# parameter 3: %rdx
..B1.1:
        .cfi_startproc
..L1:

        movq      %rdx, %r8
        movzwl    6(%rdi), %eax
        andl      $32752, %eax
        cmpl      $32752, %eax
        je        ..B1.14
..B1.2:
        movzwl    6(%rsi), %eax
        andl      $32752, %eax
        cmpl      $32752, %eax
        je        ..B1.13
..B1.3:
        movsd     (%rdi), %xmm2
        movsd     4096+_vmldHypotHATab(%rip), %xmm0
        movb      7(%rdi), %dl
        movb      7(%rsi), %al
        movsd     (%rsi), %xmm1
        ucomisd   %xmm0, %xmm2
        jp        ..B1.4
        je        ..B1.11
..B1.4:
        movsd     %xmm2, -16(%rsp)
        andb      $127, %dl
        movsd     %xmm1, -48(%rsp)
        andb      $127, %al
        movb      %dl, -9(%rsp)
        movb      %al, -41(%rsp)
        movsd     -16(%rsp), %xmm8
        movsd     -48(%rsp), %xmm1
        comisd    %xmm8, %xmm1
        jbe       ..B1.6
..B1.5:
        movaps    %xmm8, %xmm2
        movaps    %xmm1, %xmm8
        movsd     %xmm1, -16(%rsp)
        movaps    %xmm2, %xmm1
..B1.6:
        movzwl    -10(%rsp), %edx
        andl      $32752, %edx
        shrl      $4, %edx
        negl      %edx
        movzwl    4102+_vmldHypotHATab(%rip), %edi
        andl      $-32753, %edi
        movsd     %xmm0, -56(%rsp)
        movsd     4128+_vmldHypotHATab(%rip), %xmm3
        lea       1025(%rdx), %esi
        negl      %esi
        addl      $1000, %esi
        shrl      $31, %esi
        imull     $-23, %esi, %eax
        lea       1025(%rax,%rdx), %esi
        lea       1023(%rsi), %ecx
        andl      $2047, %ecx
        shll      $4, %ecx
        orl       %ecx, %edi
        movw      %di, -50(%rsp)
        movsd     -56(%rsp), %xmm2
        mulsd     %xmm2, %xmm8
        mulsd     %xmm2, %xmm1
        mulsd     %xmm8, %xmm3
        movsd     %xmm3, -72(%rsp)
        movsd     -72(%rsp), %xmm4
        movsd     %xmm8, -16(%rsp)
        subsd     %xmm8, %xmm4
        movsd     %xmm4, -64(%rsp)
        movsd     -72(%rsp), %xmm6
        movsd     -64(%rsp), %xmm5
        movsd     %xmm1, -48(%rsp)
        subsd     %xmm5, %xmm6
        movsd     %xmm6, -72(%rsp)
        movsd     -72(%rsp), %xmm7
        movzwl    -10(%rsp), %r10d
        subsd     %xmm7, %xmm8
        movzwl    -42(%rsp), %r9d
        andl      $32752, %r10d
        andl      $32752, %r9d
        shrl      $4, %r10d
        shrl      $4, %r9d
        movsd     %xmm8, -64(%rsp)
        subl      %r9d, %r10d
        movsd     -72(%rsp), %xmm8
        movsd     -64(%rsp), %xmm3
        cmpl      $6, %r10d
        jle       ..B1.8
..B1.7:
        movaps    %xmm1, %xmm6
        jmp       ..B1.9
..B1.8:
        movsd     -48(%rsp), %xmm1
        movsd     4128+_vmldHypotHATab(%rip), %xmm0
        movaps    %xmm1, %xmm7
        mulsd     %xmm1, %xmm0
        movsd     %xmm0, -72(%rsp)
        movsd     -72(%rsp), %xmm2
        subsd     -48(%rsp), %xmm2
        movsd     %xmm2, -64(%rsp)
        movsd     -72(%rsp), %xmm5
        movsd     -64(%rsp), %xmm4
        subsd     %xmm4, %xmm5
        movsd     %xmm5, -72(%rsp)
        movsd     -72(%rsp), %xmm6
        subsd     %xmm6, %xmm7
        movsd     %xmm7, -64(%rsp)
        movsd     -72(%rsp), %xmm0
        movsd     -64(%rsp), %xmm6
..B1.9:
        movsd     -16(%rsp), %xmm5
        movaps    %xmm8, %xmm2
        mulsd     %xmm6, %xmm1
        addsd     %xmm8, %xmm5
        mulsd     %xmm8, %xmm2
        mulsd     %xmm5, %xmm3
        movaps    %xmm0, %xmm4
        negl      %esi
        mulsd     %xmm0, %xmm4
        addsd     %xmm1, %xmm3
        mulsd     %xmm6, %xmm0
        addsd     %xmm4, %xmm2
        addsd     %xmm0, %xmm3
        movaps    %xmm2, %xmm6
        addl      $1023, %esi
        movq      4112+_vmldHypotHATab(%rip), %r11
        movq      %r11, %r9
        lea       _vmldHypotHATab(%rip), %rdx
        addsd     %xmm3, %xmm6
        movsd     %xmm6, -56(%rsp)
        andl      $2047, %esi
        movzwl    -50(%rsp), %ecx
        andl      $32752, %ecx
        shrl      $4, %ecx
        addl      $-1023, %ecx
        movl      %ecx, %eax
        andl      $1, %eax
        subl      %eax, %ecx
        shrl      $1, %ecx
        movsd     %xmm6, -48(%rsp)
        movzwl    -42(%rsp), %edi
        andl      $-32753, %edi
        shrq      $48, %r9
        lea       1023(%rcx), %r10d
        addl      %ecx, %ecx
        addl      $16368, %edi
        negl      %ecx
        andl      $2047, %r10d
        addl      $1023, %ecx
        andl      $2047, %ecx
        andl      $-32753, %r9d
        movw      %di, -42(%rsp)
        shll      $4, %r10d
        shll      $4, %ecx
        orl       %r9d, %r10d
        shll      $4, %esi
        orl       %r9d, %ecx
        movsd     -48(%rsp), %xmm1
        orl       %esi, %r9d
        movl      -44(%rsp), %esi
        mulsd     4112(%rdx,%rax,8), %xmm1
        andl      $1048575, %esi
        shrl      $12, %esi
        shll      $8, %eax
        addl      %eax, %esi
        movsd     4104+_vmldHypotHATab(%rip), %xmm4
        movsd     (%rdx,%rsi,8), %xmm7
        movaps    %xmm4, %xmm0
        mulsd     %xmm7, %xmm1
        movaps    %xmm4, %xmm10
        mulsd     %xmm7, %xmm0
        movaps    %xmm1, %xmm8
        movaps    %xmm4, %xmm13
        mulsd     %xmm0, %xmm8
        movsd     4128+_vmldHypotHATab(%rip), %xmm5
        subsd     %xmm8, %xmm10
        movaps    %xmm10, %xmm9
        mulsd     %xmm1, %xmm10
        mulsd     %xmm0, %xmm9
        addsd     %xmm10, %xmm1
        addsd     %xmm9, %xmm0
        movaps    %xmm1, %xmm11
        movaps    %xmm0, %xmm12
        mulsd     %xmm0, %xmm11
        movq      %r11, -32(%rsp)
        subsd     %xmm11, %xmm13
        mulsd     %xmm13, %xmm12
        mulsd     %xmm1, %xmm13
        addsd     %xmm12, %xmm0
        addsd     %xmm13, %xmm1
        movaps    %xmm1, %xmm14
        movaps    %xmm0, %xmm15
        mulsd     %xmm0, %xmm14
        movw      %cx, -26(%rsp)
        subsd     %xmm14, %xmm4
        mulsd     %xmm4, %xmm15
        mulsd     %xmm1, %xmm4
        addsd     %xmm15, %xmm0
        addsd     %xmm4, %xmm1
        mulsd     %xmm1, %xmm5
        movaps    %xmm1, %xmm10
        movsd     %xmm5, -72(%rsp)
        movsd     -72(%rsp), %xmm6
        movsd     -32(%rsp), %xmm15
        subsd     %xmm1, %xmm6
        mulsd     %xmm15, %xmm2
        mulsd     %xmm15, %xmm3
        movsd     %xmm6, -64(%rsp)
        movsd     -72(%rsp), %xmm8
        movsd     -64(%rsp), %xmm7
        movsd     4120+_vmldHypotHATab(%rip), %xmm13
        subsd     %xmm7, %xmm8
        movsd     %xmm8, -72(%rsp)
        movsd     -72(%rsp), %xmm9
        movq      %r11, -40(%rsp)
        subsd     %xmm9, %xmm10
        movsd     %xmm10, -64(%rsp)
        movsd     -72(%rsp), %xmm12
        movaps    %xmm12, %xmm11
        mulsd     %xmm12, %xmm11
        mulsd     %xmm12, %xmm13
        subsd     %xmm11, %xmm2
        movsd     -64(%rsp), %xmm14
        mulsd     %xmm14, %xmm13
        mulsd     %xmm14, %xmm14
        subsd     %xmm13, %xmm2
        movw      %r10w, -34(%rsp)
        subsd     %xmm14, %xmm2
        movq      %r11, -24(%rsp)
        addsd     %xmm3, %xmm2
        mulsd     %xmm2, %xmm0
        movw      %r9w, -18(%rsp)
        addsd     %xmm0, %xmm1
        mulsd     -40(%rsp), %xmm1
        mulsd     -24(%rsp), %xmm1
        movsd     %xmm1, (%r8)
..B1.10:
        xorl      %eax, %eax
        ret
..B1.11:
        ucomisd   %xmm0, %xmm1
        jne       ..B1.4
        jp        ..B1.4
..B1.12:
        movsd     %xmm0, (%r8)
        jmp       ..B1.10
..B1.13:
        movsd     (%rsi), %xmm0
        mulsd     %xmm0, %xmm0
        movsd     %xmm0, (%r8)
        jmp       ..B1.10
..B1.14:
        movzwl    6(%rsi), %eax
        andl      $32752, %eax
        cmpl      $32752, %eax
        je        ..B1.16
..B1.15:
        movsd     (%rdi), %xmm0
        mulsd     %xmm0, %xmm0
        movsd     %xmm0, (%r8)
        jmp       ..B1.10
..B1.16:
        movl      4(%rdi), %eax
        andl      $1048575, %eax
        jne       ..B1.18
..B1.17:
        cmpl      $0, (%rdi)
        je        ..B1.22
..B1.18:
        testl     $1048575, 4(%rsi)
        jne       ..B1.20
..B1.19:
        cmpl      $0, (%rsi)
        je        ..B1.21
..B1.20:
        movsd     (%rdi), %xmm0
        mulsd     (%rsi), %xmm0
        movsd     %xmm0, (%r8)
        jmp       ..B1.10
..B1.21:
        testl     %eax, %eax
        jne       ..B1.13
..B1.27:
        cmpl      $0, (%rdi)
..B1.22:
        je        ..B1.15
        jmp       ..B1.13
        .align    16,0x90
	.cfi_endproc
	.type	__svml_dhypot_ha_cout_rare_internal,@function
	.size	__svml_dhypot_ha_cout_rare_internal,.-__svml_dhypot_ha_cout_rare_internal
..LN__svml_dhypot_ha_cout_rare_internal.0:
	.data
# -- End  __svml_dhypot_ha_cout_rare_internal
	.section .rodata, "a"
	.align 32
	.align 32
_vmldHypotHATab:
	.long	0
	.long	1072693248
	.long	0
	.long	1072689152
	.long	0
	.long	1072685056
	.long	0
	.long	1072680960
	.long	0
	.long	1072676864
	.long	0
	.long	1072672768
	.long	0
	.long	1072668672
	.long	0
	.long	1072665600
	.long	0
	.long	1072661504
	.long	0
	.long	1072657408
	.long	0
	.long	1072653312
	.long	0
	.long	1072649216
	.long	0
	.long	1072646144
	.long	0
	.long	1072642048
	.long	0
	.long	1072637952
	.long	0
	.long	1072634880
	.long	0
	.long	1072630784
	.long	0
	.long	1072626688
	.long	0
	.long	1072623616
	.long	0
	.long	1072619520
	.long	0
	.long	1072615424
	.long	0
	.long	1072612352
	.long	0
	.long	1072608256
	.long	0
	.long	1072605184
	.long	0
	.long	1072601088
	.long	0
	.long	1072598016
	.long	0
	.long	1072593920
	.long	0
	.long	1072590848
	.long	0
	.long	1072586752
	.long	0
	.long	1072583680
	.long	0
	.long	1072580608
	.long	0
	.long	1072576512
	.long	0
	.long	1072573440
	.long	0
	.long	1072570368
	.long	0
	.long	1072566272
	.long	0
	.long	1072563200
	.long	0
	.long	1072560128
	.long	0
	.long	1072556032
	.long	0
	.long	1072552960
	.long	0
	.long	1072549888
	.long	0
	.long	1072546816
	.long	0
	.long	1072542720
	.long	0
	.long	1072539648
	.long	0
	.long	1072536576
	.long	0
	.long	1072533504
	.long	0
	.long	1072530432
	.long	0
	.long	1072527360
	.long	0
	.long	1072523264
	.long	0
	.long	1072520192
	.long	0
	.long	1072517120
	.long	0
	.long	1072514048
	.long	0
	.long	1072510976
	.long	0
	.long	1072507904
	.long	0
	.long	1072504832
	.long	0
	.long	1072501760
	.long	0
	.long	1072498688
	.long	0
	.long	1072495616
	.long	0
	.long	1072492544
	.long	0
	.long	1072489472
	.long	0
	.long	1072486400
	.long	0
	.long	1072483328
	.long	0
	.long	1072480256
	.long	0
	.long	1072478208
	.long	0
	.long	1072475136
	.long	0
	.long	1072472064
	.long	0
	.long	1072468992
	.long	0
	.long	1072465920
	.long	0
	.long	1072462848
	.long	0
	.long	1072459776
	.long	0
	.long	1072457728
	.long	0
	.long	1072454656
	.long	0
	.long	1072451584
	.long	0
	.long	1072448512
	.long	0
	.long	1072446464
	.long	0
	.long	1072443392
	.long	0
	.long	1072440320
	.long	0
	.long	1072437248
	.long	0
	.long	1072435200
	.long	0
	.long	1072432128
	.long	0
	.long	1072429056
	.long	0
	.long	1072427008
	.long	0
	.long	1072423936
	.long	0
	.long	1072420864
	.long	0
	.long	1072418816
	.long	0
	.long	1072415744
	.long	0
	.long	1072412672
	.long	0
	.long	1072410624
	.long	0
	.long	1072407552
	.long	0
	.long	1072405504
	.long	0
	.long	1072402432
	.long	0
	.long	1072400384
	.long	0
	.long	1072397312
	.long	0
	.long	1072395264
	.long	0
	.long	1072392192
	.long	0
	.long	1072390144
	.long	0
	.long	1072387072
	.long	0
	.long	1072385024
	.long	0
	.long	1072381952
	.long	0
	.long	1072379904
	.long	0
	.long	1072376832
	.long	0
	.long	1072374784
	.long	0
	.long	1072371712
	.long	0
	.long	1072369664
	.long	0
	.long	1072366592
	.long	0
	.long	1072364544
	.long	0
	.long	1072362496
	.long	0
	.long	1072359424
	.long	0
	.long	1072357376
	.long	0
	.long	1072355328
	.long	0
	.long	1072352256
	.long	0
	.long	1072350208
	.long	0
	.long	1072347136
	.long	0
	.long	1072345088
	.long	0
	.long	1072343040
	.long	0
	.long	1072340992
	.long	0
	.long	1072337920
	.long	0
	.long	1072335872
	.long	0
	.long	1072333824
	.long	0
	.long	1072330752
	.long	0
	.long	1072328704
	.long	0
	.long	1072326656
	.long	0
	.long	1072324608
	.long	0
	.long	1072321536
	.long	0
	.long	1072319488
	.long	0
	.long	1072317440
	.long	0
	.long	1072315392
	.long	0
	.long	1072313344
	.long	0
	.long	1072310272
	.long	0
	.long	1072308224
	.long	0
	.long	1072306176
	.long	0
	.long	1072304128
	.long	0
	.long	1072302080
	.long	0
	.long	1072300032
	.long	0
	.long	1072296960
	.long	0
	.long	1072294912
	.long	0
	.long	1072292864
	.long	0
	.long	1072290816
	.long	0
	.long	1072288768
	.long	0
	.long	1072286720
	.long	0
	.long	1072284672
	.long	0
	.long	1072282624
	.long	0
	.long	1072280576
	.long	0
	.long	1072278528
	.long	0
	.long	1072275456
	.long	0
	.long	1072273408
	.long	0
	.long	1072271360
	.long	0
	.long	1072269312
	.long	0
	.long	1072267264
	.long	0
	.long	1072265216
	.long	0
	.long	1072263168
	.long	0
	.long	1072261120
	.long	0
	.long	1072259072
	.long	0
	.long	1072257024
	.long	0
	.long	1072254976
	.long	0
	.long	1072252928
	.long	0
	.long	1072250880
	.long	0
	.long	1072248832
	.long	0
	.long	1072246784
	.long	0
	.long	1072244736
	.long	0
	.long	1072243712
	.long	0
	.long	1072241664
	.long	0
	.long	1072239616
	.long	0
	.long	1072237568
	.long	0
	.long	1072235520
	.long	0
	.long	1072233472
	.long	0
	.long	1072231424
	.long	0
	.long	1072229376
	.long	0
	.long	1072227328
	.long	0
	.long	1072225280
	.long	0
	.long	1072223232
	.long	0
	.long	1072222208
	.long	0
	.long	1072220160
	.long	0
	.long	1072218112
	.long	0
	.long	1072216064
	.long	0
	.long	1072214016
	.long	0
	.long	1072211968
	.long	0
	.long	1072210944
	.long	0
	.long	1072208896
	.long	0
	.long	1072206848
	.long	0
	.long	1072204800
	.long	0
	.long	1072202752
	.long	0
	.long	1072201728
	.long	0
	.long	1072199680
	.long	0
	.long	1072197632
	.long	0
	.long	1072195584
	.long	0
	.long	1072193536
	.long	0
	.long	1072192512
	.long	0
	.long	1072190464
	.long	0
	.long	1072188416
	.long	0
	.long	1072186368
	.long	0
	.long	1072185344
	.long	0
	.long	1072183296
	.long	0
	.long	1072181248
	.long	0
	.long	1072179200
	.long	0
	.long	1072178176
	.long	0
	.long	1072176128
	.long	0
	.long	1072174080
	.long	0
	.long	1072173056
	.long	0
	.long	1072171008
	.long	0
	.long	1072168960
	.long	0
	.long	1072167936
	.long	0
	.long	1072165888
	.long	0
	.long	1072163840
	.long	0
	.long	1072161792
	.long	0
	.long	1072160768
	.long	0
	.long	1072158720
	.long	0
	.long	1072157696
	.long	0
	.long	1072155648
	.long	0
	.long	1072153600
	.long	0
	.long	1072152576
	.long	0
	.long	1072150528
	.long	0
	.long	1072148480
	.long	0
	.long	1072147456
	.long	0
	.long	1072145408
	.long	0
	.long	1072143360
	.long	0
	.long	1072142336
	.long	0
	.long	1072140288
	.long	0
	.long	1072139264
	.long	0
	.long	1072137216
	.long	0
	.long	1072135168
	.long	0
	.long	1072134144
	.long	0
	.long	1072132096
	.long	0
	.long	1072131072
	.long	0
	.long	1072129024
	.long	0
	.long	1072128000
	.long	0
	.long	1072125952
	.long	0
	.long	1072124928
	.long	0
	.long	1072122880
	.long	0
	.long	1072120832
	.long	0
	.long	1072119808
	.long	0
	.long	1072117760
	.long	0
	.long	1072116736
	.long	0
	.long	1072114688
	.long	0
	.long	1072113664
	.long	0
	.long	1072111616
	.long	0
	.long	1072110592
	.long	0
	.long	1072108544
	.long	0
	.long	1072107520
	.long	0
	.long	1072105472
	.long	0
	.long	1072104448
	.long	0
	.long	1072102400
	.long	0
	.long	1072101376
	.long	0
	.long	1072099328
	.long	0
	.long	1072098304
	.long	0
	.long	1072096256
	.long	0
	.long	1072095232
	.long	0
	.long	1072094208
	.long	0
	.long	1072092160
	.long	0
	.long	1072091136
	.long	0
	.long	1072089088
	.long	0
	.long	1072088064
	.long	0
	.long	1072086016
	.long	0
	.long	1072084992
	.long	0
	.long	1072082944
	.long	0
	.long	1072081920
	.long	0
	.long	1072080896
	.long	0
	.long	1072078848
	.long	0
	.long	1072075776
	.long	0
	.long	1072073728
	.long	0
	.long	1072070656
	.long	0
	.long	1072067584
	.long	0
	.long	1072064512
	.long	0
	.long	1072061440
	.long	0
	.long	1072059392
	.long	0
	.long	1072056320
	.long	0
	.long	1072053248
	.long	0
	.long	1072051200
	.long	0
	.long	1072048128
	.long	0
	.long	1072045056
	.long	0
	.long	1072043008
	.long	0
	.long	1072039936
	.long	0
	.long	1072037888
	.long	0
	.long	1072034816
	.long	0
	.long	1072031744
	.long	0
	.long	1072029696
	.long	0
	.long	1072026624
	.long	0
	.long	1072024576
	.long	0
	.long	1072021504
	.long	0
	.long	1072019456
	.long	0
	.long	1072016384
	.long	0
	.long	1072014336
	.long	0
	.long	1072011264
	.long	0
	.long	1072009216
	.long	0
	.long	1072006144
	.long	0
	.long	1072004096
	.long	0
	.long	1072002048
	.long	0
	.long	1071998976
	.long	0
	.long	1071996928
	.long	0
	.long	1071993856
	.long	0
	.long	1071991808
	.long	0
	.long	1071989760
	.long	0
	.long	1071986688
	.long	0
	.long	1071984640
	.long	0
	.long	1071982592
	.long	0
	.long	1071979520
	.long	0
	.long	1071977472
	.long	0
	.long	1071975424
	.long	0
	.long	1071972352
	.long	0
	.long	1071970304
	.long	0
	.long	1071968256
	.long	0
	.long	1071966208
	.long	0
	.long	1071964160
	.long	0
	.long	1071961088
	.long	0
	.long	1071959040
	.long	0
	.long	1071956992
	.long	0
	.long	1071954944
	.long	0
	.long	1071952896
	.long	0
	.long	1071949824
	.long	0
	.long	1071947776
	.long	0
	.long	1071945728
	.long	0
	.long	1071943680
	.long	0
	.long	1071941632
	.long	0
	.long	1071939584
	.long	0
	.long	1071937536
	.long	0
	.long	1071935488
	.long	0
	.long	1071933440
	.long	0
	.long	1071930368
	.long	0
	.long	1071928320
	.long	0
	.long	1071926272
	.long	0
	.long	1071924224
	.long	0
	.long	1071922176
	.long	0
	.long	1071920128
	.long	0
	.long	1071918080
	.long	0
	.long	1071916032
	.long	0
	.long	1071913984
	.long	0
	.long	1071911936
	.long	0
	.long	1071909888
	.long	0
	.long	1071907840
	.long	0
	.long	1071905792
	.long	0
	.long	1071903744
	.long	0
	.long	1071901696
	.long	0
	.long	1071900672
	.long	0
	.long	1071898624
	.long	0
	.long	1071896576
	.long	0
	.long	1071894528
	.long	0
	.long	1071892480
	.long	0
	.long	1071890432
	.long	0
	.long	1071888384
	.long	0
	.long	1071886336
	.long	0
	.long	1071884288
	.long	0
	.long	1071883264
	.long	0
	.long	1071881216
	.long	0
	.long	1071879168
	.long	0
	.long	1071877120
	.long	0
	.long	1071875072
	.long	0
	.long	1071873024
	.long	0
	.long	1071872000
	.long	0
	.long	1071869952
	.long	0
	.long	1071867904
	.long	0
	.long	1071865856
	.long	0
	.long	1071864832
	.long	0
	.long	1071862784
	.long	0
	.long	1071860736
	.long	0
	.long	1071858688
	.long	0
	.long	1071856640
	.long	0
	.long	1071855616
	.long	0
	.long	1071853568
	.long	0
	.long	1071851520
	.long	0
	.long	1071850496
	.long	0
	.long	1071848448
	.long	0
	.long	1071846400
	.long	0
	.long	1071844352
	.long	0
	.long	1071843328
	.long	0
	.long	1071841280
	.long	0
	.long	1071839232
	.long	0
	.long	1071838208
	.long	0
	.long	1071836160
	.long	0
	.long	1071834112
	.long	0
	.long	1071833088
	.long	0
	.long	1071831040
	.long	0
	.long	1071830016
	.long	0
	.long	1071827968
	.long	0
	.long	1071825920
	.long	0
	.long	1071824896
	.long	0
	.long	1071822848
	.long	0
	.long	1071821824
	.long	0
	.long	1071819776
	.long	0
	.long	1071817728
	.long	0
	.long	1071816704
	.long	0
	.long	1071814656
	.long	0
	.long	1071813632
	.long	0
	.long	1071811584
	.long	0
	.long	1071810560
	.long	0
	.long	1071808512
	.long	0
	.long	1071806464
	.long	0
	.long	1071805440
	.long	0
	.long	1071803392
	.long	0
	.long	1071802368
	.long	0
	.long	1071800320
	.long	0
	.long	1071799296
	.long	0
	.long	1071797248
	.long	0
	.long	1071796224
	.long	0
	.long	1071794176
	.long	0
	.long	1071793152
	.long	0
	.long	1071791104
	.long	0
	.long	1071790080
	.long	0
	.long	1071788032
	.long	0
	.long	1071787008
	.long	0
	.long	1071784960
	.long	0
	.long	1071783936
	.long	0
	.long	1071782912
	.long	0
	.long	1071780864
	.long	0
	.long	1071779840
	.long	0
	.long	1071777792
	.long	0
	.long	1071776768
	.long	0
	.long	1071774720
	.long	0
	.long	1071773696
	.long	0
	.long	1071772672
	.long	0
	.long	1071770624
	.long	0
	.long	1071769600
	.long	0
	.long	1071767552
	.long	0
	.long	1071766528
	.long	0
	.long	1071765504
	.long	0
	.long	1071763456
	.long	0
	.long	1071762432
	.long	0
	.long	1071760384
	.long	0
	.long	1071759360
	.long	0
	.long	1071758336
	.long	0
	.long	1071756288
	.long	0
	.long	1071755264
	.long	0
	.long	1071754240
	.long	0
	.long	1071752192
	.long	0
	.long	1071751168
	.long	0
	.long	1071750144
	.long	0
	.long	1071748096
	.long	0
	.long	1071747072
	.long	0
	.long	1071746048
	.long	0
	.long	1071744000
	.long	0
	.long	1071742976
	.long	0
	.long	1071741952
	.long	0
	.long	1071739904
	.long	0
	.long	1071738880
	.long	0
	.long	1071737856
	.long	0
	.long	1071736832
	.long	0
	.long	1071734784
	.long	0
	.long	1071733760
	.long	0
	.long	1071732736
	.long	0
	.long	1071730688
	.long	0
	.long	1071729664
	.long	0
	.long	1071728640
	.long	0
	.long	1071727616
	.long	0
	.long	1071725568
	.long	0
	.long	1071724544
	.long	0
	.long	1071723520
	.long	0
	.long	1071722496
	.long	0
	.long	1071720448
	.long	0
	.long	1071719424
	.long	0
	.long	1071718400
	.long	0
	.long	1071717376
	.long	0
	.long	1071715328
	.long	0
	.long	1071714304
	.long	0
	.long	1071713280
	.long	0
	.long	1071712256
	.long	0
	.long	1071711232
	.long	0
	.long	1071709184
	.long	0
	.long	1071708160
	.long	0
	.long	1071707136
	.long	0
	.long	1071706112
	.long	0
	.long	1071705088
	.long	0
	.long	1071704064
	.long	0
	.long	1071702016
	.long	0
	.long	1071700992
	.long	0
	.long	1071699968
	.long	0
	.long	1071698944
	.long	0
	.long	1071697920
	.long	0
	.long	1071696896
	.long	0
	.long	1071694848
	.long	0
	.long	1071693824
	.long	0
	.long	1071692800
	.long	0
	.long	1071691776
	.long	0
	.long	1071690752
	.long	0
	.long	1071689728
	.long	0
	.long	1071688704
	.long	0
	.long	1071686656
	.long	0
	.long	1071685632
	.long	0
	.long	1071684608
	.long	0
	.long	1071683584
	.long	0
	.long	1071682560
	.long	0
	.long	1071681536
	.long	0
	.long	1071680512
	.long	0
	.long	1071679488
	.long	0
	.long	1071677440
	.long	0
	.long	1071676416
	.long	0
	.long	1071675392
	.long	0
	.long	1071674368
	.long	0
	.long	1071673344
	.long	0
	.long	1071672320
	.long	0
	.long	1071671296
	.long	0
	.long	1071670272
	.long	0
	.long	1071669248
	.long	0
	.long	1071668224
	.long	0
	.long	1071667200
	.long	0
	.long	1071666176
	.long	0
	.long	1071665152
	.long	0
	.long	1071663104
	.long	0
	.long	1071662080
	.long	0
	.long	1071661056
	.long	0
	.long	1071660032
	.long	0
	.long	1071659008
	.long	0
	.long	1071657984
	.long	0
	.long	1071656960
	.long	0
	.long	1071655936
	.long	0
	.long	1071654912
	.long	0
	.long	1071653888
	.long	0
	.long	1071652864
	.long	0
	.long	1071651840
	.long	0
	.long	1071650816
	.long	0
	.long	1071649792
	.long	0
	.long	1071648768
	.long	0
	.long	1071647744
	.long	0
	.long	1071646720
	.long	0
	.long	1071645696
	.long	0
	.long	0
	.long	0
	.long	1071644672
	.long	0
	.long	1072693248
	.long	0
	.long	1073741824
	.long	33554432
	.long	1101004800
	.type	_vmldHypotHATab,@object
	.size	_vmldHypotHATab,4136
	.data
	.section .note.GNU-stack, ""
# End
