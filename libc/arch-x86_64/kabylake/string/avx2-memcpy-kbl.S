/*
 * Copyright (C) 2021 The Android Open Source Project
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 *  * Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 *  * Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in
 *    the documentation and/or other materials provided with the
 *    distribution.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
 * FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
 * COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
 * BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS
 * OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED
 * AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
 * OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT
 * OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
 * SUCH DAMAGE.
 */


#define ENTRY(f) \
    .text; \
    .globl f; \
    .p2align    4, 0x90; \
    .type f,@function; \
    f: \

#define END(f)
    .size f, .-f; \
    .section        .rodata,"a",@progbits; \
    .p2align        2 \

ENTRY(memcpy_avx2)
	.cfi_startproc
# %bb.0:
	movq	%rdi, %rax
	cmpq	$256, %rdx              # imm = 0x100
	ja	.LBB0_259
# %bb.1:
	leaq	-1(%rdx), %rdi
	cmpq	$255, %rdi
	ja	.LBB0_526
# %bb.2:
	leaq	(%rax,%rdx), %rcx
	addq	%rdx, %rsi
	leaq	.LJTI0_1(%rip), %rdx
	movslq	(%rdx,%rdi,4), %rdi
	addq	%rdx, %rdi
	jmpq	*%rdi
.LBB0_11:
	vmovups	-131(%rsi), %ymm0
	vmovups	%ymm0, -131(%rcx)
	vmovups	-99(%rsi), %ymm0
	vmovups	%ymm0, -99(%rcx)
	vmovups	-67(%rsi), %ymm0
	vmovups	%ymm0, -67(%rcx)
	vmovups	-35(%rsi), %ymm0
	vmovups	%ymm0, -35(%rcx)
.LBB0_12:
	movzwl	-3(%rsi), %edx
	movw	%dx, -3(%rcx)
	movb	-1(%rsi), %dl
	movb	%dl, -1(%rcx)
	vzeroupper
	retq
.LBB0_259:
	movl	%eax, %ecx
	negl	%ecx
	andl	$31, %ecx
	vmovups	(%rsi), %ymm0
	vmovups	%ymm0, (%rax)
	leaq	(%rax,%rcx), %r8
	addq	%rcx, %rsi
	movq	%rdx, %rdi
	subq	%rcx, %rdi
	cmpq	$2097152, %rdi          # imm = 0x200000
	ja	.LBB0_264
# %bb.260:
	cmpq	$256, %rdi              # imm = 0x100
	jb	.LBB0_268
# %bb.261:
	subq	%rcx, %rdx
	.p2align	4, 0x90
.LBB0_262:                              # =>This Inner Loop Header: Depth=1
	vmovups	(%rsi), %ymm0
	vmovups	32(%rsi), %ymm1
	vmovups	64(%rsi), %ymm2
	vmovups	96(%rsi), %ymm3
	vmovups	128(%rsi), %ymm4
	vmovups	160(%rsi), %ymm5
	vmovups	192(%rsi), %ymm6
	vmovups	224(%rsi), %ymm7
	prefetchnta	512(%rsi)
	addq	$256, %rsi              # imm = 0x100
	vmovups	%ymm0, (%r8)
	vmovups	%ymm1, 32(%r8)
	vmovups	%ymm2, 64(%r8)
	vmovups	%ymm3, 96(%r8)
	vmovups	%ymm4, 128(%r8)
	vmovups	%ymm5, 160(%r8)
	vmovups	%ymm6, 192(%r8)
	vmovups	%ymm7, 224(%r8)
	addq	$256, %r8               # imm = 0x100
	addq	$-256, %rdi
	cmpq	$255, %rdi
	ja	.LBB0_262
# %bb.263:
	movzbl	%dl, %edi
	leaq	-1(%rdi), %rcx
	cmpq	$255, %rcx
	jbe	.LBB0_269
	jmp	.LBB0_526
.LBB0_264:
	prefetchnta	(%rsi)
	subq	%rcx, %rdx
	testb	$31, %sil
	je	.LBB0_265
	.p2align	4, 0x90
.LBB0_266:                              # =>This Inner Loop Header: Depth=1
	vmovups	(%rsi), %ymm0
	vmovups	32(%rsi), %ymm1
	vmovups	64(%rsi), %ymm2
	vmovups	96(%rsi), %ymm3
	vmovups	128(%rsi), %ymm4
	vmovups	160(%rsi), %ymm5
	vmovups	192(%rsi), %ymm6
	vmovups	224(%rsi), %ymm7
	prefetchnta	512(%rsi)
	addq	$256, %rsi              # imm = 0x100
	vmovntps	%ymm0, (%r8)
	vmovntps	%ymm1, 32(%r8)
	vmovntps	%ymm2, 64(%r8)
	vmovntps	%ymm3, 96(%r8)
	vmovntps	%ymm4, 128(%r8)
	vmovntps	%ymm5, 160(%r8)
	vmovntps	%ymm6, 192(%r8)
	vmovntps	%ymm7, 224(%r8)
	addq	$256, %r8               # imm = 0x100
	addq	$-256, %rdi
	cmpq	$255, %rdi
	ja	.LBB0_266
	jmp	.LBB0_267
	.p2align	4, 0x90
.LBB0_265:                              # =>This Inner Loop Header: Depth=1
	vmovaps	(%rsi), %ymm0
	vmovaps	32(%rsi), %ymm1
	vmovaps	64(%rsi), %ymm2
	vmovaps	96(%rsi), %ymm3
	vmovaps	128(%rsi), %ymm4
	vmovaps	160(%rsi), %ymm5
	vmovaps	192(%rsi), %ymm6
	vmovaps	224(%rsi), %ymm7
	prefetchnta	512(%rsi)
	addq	$256, %rsi              # imm = 0x100
	vmovntps	%ymm0, (%r8)
	vmovntps	%ymm1, 32(%r8)
	vmovntps	%ymm2, 64(%r8)
	vmovntps	%ymm3, 96(%r8)
	vmovntps	%ymm4, 128(%r8)
	vmovntps	%ymm5, 160(%r8)
	vmovntps	%ymm6, 192(%r8)
	vmovntps	%ymm7, 224(%r8)
	addq	$256, %r8               # imm = 0x100
	addq	$-256, %rdi
	cmpq	$255, %rdi
	ja	.LBB0_265
.LBB0_267:
	movzbl	%dl, %edi
	sfence
.LBB0_268:
	leaq	-1(%rdi), %rcx
	cmpq	$255, %rcx
	ja	.LBB0_526
.LBB0_269:
	addq	%rdi, %r8
	addq	%rdi, %rsi
	leaq	.LJTI0_0(%rip), %rdx
	movslq	(%rdx,%rcx,4), %rcx
	addq	%rdx, %rcx
	jmpq	*%rcx
.LBB0_278:
	vmovups	-131(%rsi), %ymm0
	vmovups	%ymm0, -131(%r8)
	vmovups	-99(%rsi), %ymm0
	vmovups	%ymm0, -99(%r8)
	vmovups	-67(%rsi), %ymm0
	vmovups	%ymm0, -67(%r8)
	vmovups	-35(%rsi), %ymm0
	vmovups	%ymm0, -35(%r8)
.LBB0_279:
	movzwl	-3(%rsi), %ecx
	movw	%cx, -3(%r8)
	movb	-1(%rsi), %cl
	movb	%cl, -1(%r8)
	vzeroupper
	retq
.LBB0_17:
	vmovups	-133(%rsi), %ymm0
	vmovups	%ymm0, -133(%rcx)
	vmovups	-101(%rsi), %ymm0
	vmovups	%ymm0, -101(%rcx)
	vmovups	-69(%rsi), %ymm0
	vmovups	%ymm0, -69(%rcx)
	vmovups	-37(%rsi), %ymm0
	vmovups	%ymm0, -37(%rcx)
.LBB0_18:
	movl	-5(%rsi), %edx
	movl	%edx, -5(%rcx)
	movb	-1(%rsi), %dl
	movb	%dl, -1(%rcx)
	vzeroupper
	retq
.LBB0_19:
	vmovups	-134(%rsi), %ymm0
	vmovups	%ymm0, -134(%rcx)
	vmovups	-102(%rsi), %ymm0
	vmovups	%ymm0, -102(%rcx)
	vmovups	-70(%rsi), %ymm0
	vmovups	%ymm0, -70(%rcx)
	vmovups	-38(%rsi), %ymm0
	vmovups	%ymm0, -38(%rcx)
.LBB0_20:
	movl	-6(%rsi), %edx
	movl	%edx, -6(%rcx)
	movzwl	-2(%rsi), %edx
	movw	%dx, -2(%rcx)
	vzeroupper
	retq
.LBB0_21:
	vmovups	-135(%rsi), %ymm0
	vmovups	%ymm0, -135(%rcx)
	vmovups	-103(%rsi), %ymm0
	vmovups	%ymm0, -103(%rcx)
	vmovups	-71(%rsi), %ymm0
	vmovups	%ymm0, -71(%rcx)
	vmovups	-39(%rsi), %ymm0
	vmovups	%ymm0, -39(%rcx)
.LBB0_22:
	movl	-7(%rsi), %edx
	movl	%edx, -7(%rcx)
	movl	-4(%rsi), %edx
	movl	%edx, -4(%rcx)
	vzeroupper
	retq
.LBB0_27:
	vmovups	-137(%rsi), %ymm0
	vmovups	%ymm0, -137(%rcx)
	vmovups	-105(%rsi), %ymm0
	vmovups	%ymm0, -105(%rcx)
	vmovups	-73(%rsi), %ymm0
	vmovups	%ymm0, -73(%rcx)
	vmovups	-41(%rsi), %ymm0
	vmovups	%ymm0, -41(%rcx)
.LBB0_28:
	movq	-9(%rsi), %rdx
	movq	%rdx, -9(%rcx)
	movb	-1(%rsi), %dl
	movb	%dl, -1(%rcx)
	vzeroupper
	retq
.LBB0_29:
	vmovups	-138(%rsi), %ymm0
	vmovups	%ymm0, -138(%rcx)
	vmovups	-106(%rsi), %ymm0
	vmovups	%ymm0, -106(%rcx)
	vmovups	-74(%rsi), %ymm0
	vmovups	%ymm0, -74(%rcx)
	vmovups	-42(%rsi), %ymm0
	vmovups	%ymm0, -42(%rcx)
.LBB0_30:
	movq	-10(%rsi), %rdx
	movq	%rdx, -10(%rcx)
	movzwl	-2(%rsi), %edx
	movw	%dx, -2(%rcx)
	vzeroupper
	retq
.LBB0_31:
	vmovups	-139(%rsi), %ymm0
	vmovups	%ymm0, -139(%rcx)
	vmovups	-107(%rsi), %ymm0
	vmovups	%ymm0, -107(%rcx)
	vmovups	-75(%rsi), %ymm0
	vmovups	%ymm0, -75(%rcx)
	vmovups	-43(%rsi), %ymm0
	vmovups	%ymm0, -43(%rcx)
.LBB0_32:
	movq	-11(%rsi), %rdx
	movq	%rdx, -11(%rcx)
	movl	-4(%rsi), %edx
	movl	%edx, -4(%rcx)
	vzeroupper
	retq
.LBB0_33:
	vmovups	-140(%rsi), %ymm0
	vmovups	%ymm0, -140(%rcx)
	vmovups	-108(%rsi), %ymm0
	vmovups	%ymm0, -108(%rcx)
	vmovups	-76(%rsi), %ymm0
	vmovups	%ymm0, -76(%rcx)
	vmovups	-44(%rsi), %ymm0
	vmovups	%ymm0, -44(%rcx)
.LBB0_34:
	movq	-12(%rsi), %rdx
	movq	%rdx, -12(%rcx)
	movl	-4(%rsi), %edx
	movl	%edx, -4(%rcx)
	vzeroupper
	retq
.LBB0_35:
	vmovups	-141(%rsi), %ymm0
	vmovups	%ymm0, -141(%rcx)
	vmovups	-109(%rsi), %ymm0
	vmovups	%ymm0, -109(%rcx)
	vmovups	-77(%rsi), %ymm0
	vmovups	%ymm0, -77(%rcx)
	vmovups	-45(%rsi), %ymm0
	vmovups	%ymm0, -45(%rcx)
.LBB0_36:
	movq	-13(%rsi), %rdx
	movq	%rdx, -13(%rcx)
	movq	-8(%rsi), %rdx
	movq	%rdx, -8(%rcx)
	vzeroupper
	retq
.LBB0_37:
	vmovups	-142(%rsi), %ymm0
	vmovups	%ymm0, -142(%rcx)
	vmovups	-110(%rsi), %ymm0
	vmovups	%ymm0, -110(%rcx)
	vmovups	-78(%rsi), %ymm0
	vmovups	%ymm0, -78(%rcx)
	vmovups	-46(%rsi), %ymm0
	vmovups	%ymm0, -46(%rcx)
.LBB0_38:
	movq	-14(%rsi), %rdx
	movq	%rdx, -14(%rcx)
	movq	-8(%rsi), %rdx
	movq	%rdx, -8(%rcx)
	vzeroupper
	retq
.LBB0_39:
	vmovups	-143(%rsi), %ymm0
	vmovups	%ymm0, -143(%rcx)
	vmovups	-111(%rsi), %ymm0
	vmovups	%ymm0, -111(%rcx)
	vmovups	-79(%rsi), %ymm0
	vmovups	%ymm0, -79(%rcx)
	vmovups	-47(%rsi), %ymm0
	vmovups	%ymm0, -47(%rcx)
.LBB0_40:
	movq	-15(%rsi), %rdx
	movq	%rdx, -15(%rcx)
	movq	-8(%rsi), %rdx
	movq	%rdx, -8(%rcx)
	vzeroupper
	retq
.LBB0_45:
	vmovups	-145(%rsi), %ymm0
	vmovups	%ymm0, -145(%rcx)
	vmovups	-113(%rsi), %ymm0
	vmovups	%ymm0, -113(%rcx)
	vmovups	-81(%rsi), %ymm0
	vmovups	%ymm0, -81(%rcx)
	vmovups	-49(%rsi), %ymm0
	vmovups	%ymm0, -49(%rcx)
.LBB0_46:
	vmovups	-17(%rsi), %xmm0
	vmovups	%xmm0, -17(%rcx)
	movb	-1(%rsi), %dl
	movb	%dl, -1(%rcx)
	vzeroupper
	retq
.LBB0_47:
	vmovups	-146(%rsi), %ymm0
	vmovups	%ymm0, -146(%rcx)
	vmovups	-114(%rsi), %ymm0
	vmovups	%ymm0, -114(%rcx)
	vmovups	-82(%rsi), %ymm0
	vmovups	%ymm0, -82(%rcx)
	vmovups	-50(%rsi), %ymm0
	vmovups	%ymm0, -50(%rcx)
.LBB0_48:
	vmovups	-18(%rsi), %xmm0
	vmovups	%xmm0, -18(%rcx)
	movzwl	-2(%rsi), %edx
	movw	%dx, -2(%rcx)
	vzeroupper
	retq
.LBB0_49:
	vmovups	-147(%rsi), %ymm0
	vmovups	%ymm0, -147(%rcx)
	vmovups	-115(%rsi), %ymm0
	vmovups	%ymm0, -115(%rcx)
	vmovups	-83(%rsi), %ymm0
	vmovups	%ymm0, -83(%rcx)
	vmovups	-51(%rsi), %ymm0
	vmovups	%ymm0, -51(%rcx)
.LBB0_50:
	vmovups	-19(%rsi), %xmm0
	vmovups	%xmm0, -19(%rcx)
	movl	-4(%rsi), %edx
	movl	%edx, -4(%rcx)
	vzeroupper
	retq
.LBB0_51:
	vmovups	-148(%rsi), %ymm0
	vmovups	%ymm0, -148(%rcx)
	vmovups	-116(%rsi), %ymm0
	vmovups	%ymm0, -116(%rcx)
	vmovups	-84(%rsi), %ymm0
	vmovups	%ymm0, -84(%rcx)
	vmovups	-52(%rsi), %ymm0
	vmovups	%ymm0, -52(%rcx)
.LBB0_52:
	vmovups	-20(%rsi), %xmm0
	vmovups	%xmm0, -20(%rcx)
	movl	-4(%rsi), %edx
	movl	%edx, -4(%rcx)
	vzeroupper
	retq
.LBB0_53:
	vmovups	-149(%rsi), %ymm0
	vmovups	%ymm0, -149(%rcx)
	vmovups	-117(%rsi), %ymm0
	vmovups	%ymm0, -117(%rcx)
	vmovups	-85(%rsi), %ymm0
	vmovups	%ymm0, -85(%rcx)
	vmovups	-53(%rsi), %ymm0
	vmovups	%ymm0, -53(%rcx)
.LBB0_54:
	vmovups	-21(%rsi), %xmm0
	vmovups	%xmm0, -21(%rcx)
	movq	-8(%rsi), %rdx
	movq	%rdx, -8(%rcx)
	vzeroupper
	retq
.LBB0_55:
	vmovups	-150(%rsi), %ymm0
	vmovups	%ymm0, -150(%rcx)
	vmovups	-118(%rsi), %ymm0
	vmovups	%ymm0, -118(%rcx)
	vmovups	-86(%rsi), %ymm0
	vmovups	%ymm0, -86(%rcx)
	vmovups	-54(%rsi), %ymm0
	vmovups	%ymm0, -54(%rcx)
.LBB0_56:
	vmovups	-22(%rsi), %xmm0
	vmovups	%xmm0, -22(%rcx)
	movq	-8(%rsi), %rdx
	movq	%rdx, -8(%rcx)
	vzeroupper
	retq
.LBB0_57:
	vmovups	-151(%rsi), %ymm0
	vmovups	%ymm0, -151(%rcx)
	vmovups	-119(%rsi), %ymm0
	vmovups	%ymm0, -119(%rcx)
	vmovups	-87(%rsi), %ymm0
	vmovups	%ymm0, -87(%rcx)
	vmovups	-55(%rsi), %ymm0
	vmovups	%ymm0, -55(%rcx)
.LBB0_58:
	vmovups	-23(%rsi), %xmm0
	vmovups	%xmm0, -23(%rcx)
	movq	-8(%rsi), %rdx
	movq	%rdx, -8(%rcx)
	vzeroupper
	retq
.LBB0_59:
	vmovups	-152(%rsi), %ymm0
	vmovups	%ymm0, -152(%rcx)
	vmovups	-120(%rsi), %ymm0
	vmovups	%ymm0, -120(%rcx)
	vmovups	-88(%rsi), %ymm0
	vmovups	%ymm0, -88(%rcx)
	vmovups	-56(%rsi), %ymm0
	vmovups	%ymm0, -56(%rcx)
.LBB0_60:
	vmovups	-24(%rsi), %xmm0
	vmovups	%xmm0, -24(%rcx)
	movq	-8(%rsi), %rdx
	movq	%rdx, -8(%rcx)
	vzeroupper
	retq
.LBB0_61:
	vmovups	-153(%rsi), %ymm0
	vmovups	%ymm0, -153(%rcx)
	vmovups	-121(%rsi), %ymm0
	vmovups	%ymm0, -121(%rcx)
	vmovups	-89(%rsi), %ymm0
	vmovups	%ymm0, -89(%rcx)
	vmovups	-57(%rsi), %ymm0
	vmovups	%ymm0, -57(%rcx)
.LBB0_62:
	vmovups	-25(%rsi), %xmm0
	vmovups	%xmm0, -25(%rcx)
	vmovups	-16(%rsi), %xmm0
	vmovups	%xmm0, -16(%rcx)
	vzeroupper
	retq
.LBB0_63:
	vmovups	-154(%rsi), %ymm0
	vmovups	%ymm0, -154(%rcx)
	vmovups	-122(%rsi), %ymm0
	vmovups	%ymm0, -122(%rcx)
	vmovups	-90(%rsi), %ymm0
	vmovups	%ymm0, -90(%rcx)
	vmovups	-58(%rsi), %ymm0
	vmovups	%ymm0, -58(%rcx)
.LBB0_64:
	vmovups	-26(%rsi), %xmm0
	vmovups	%xmm0, -26(%rcx)
	vmovups	-16(%rsi), %xmm0
	vmovups	%xmm0, -16(%rcx)
	vzeroupper
	retq
.LBB0_65:
	vmovups	-155(%rsi), %ymm0
	vmovups	%ymm0, -155(%rcx)
	vmovups	-123(%rsi), %ymm0
	vmovups	%ymm0, -123(%rcx)
	vmovups	-91(%rsi), %ymm0
	vmovups	%ymm0, -91(%rcx)
	vmovups	-59(%rsi), %ymm0
	vmovups	%ymm0, -59(%rcx)
.LBB0_66:
	vmovups	-27(%rsi), %xmm0
	vmovups	%xmm0, -27(%rcx)
	vmovups	-16(%rsi), %xmm0
	vmovups	%xmm0, -16(%rcx)
	vzeroupper
	retq
.LBB0_67:
	vmovups	-156(%rsi), %ymm0
	vmovups	%ymm0, -156(%rcx)
	vmovups	-124(%rsi), %ymm0
	vmovups	%ymm0, -124(%rcx)
	vmovups	-92(%rsi), %ymm0
	vmovups	%ymm0, -92(%rcx)
	vmovups	-60(%rsi), %ymm0
	vmovups	%ymm0, -60(%rcx)
.LBB0_68:
	vmovups	-28(%rsi), %xmm0
	vmovups	%xmm0, -28(%rcx)
	vmovups	-16(%rsi), %xmm0
	vmovups	%xmm0, -16(%rcx)
	vzeroupper
	retq
.LBB0_69:
	vmovups	-157(%rsi), %ymm0
	vmovups	%ymm0, -157(%rcx)
	vmovups	-125(%rsi), %ymm0
	vmovups	%ymm0, -125(%rcx)
	vmovups	-93(%rsi), %ymm0
	vmovups	%ymm0, -93(%rcx)
	vmovups	-61(%rsi), %ymm0
	vmovups	%ymm0, -61(%rcx)
.LBB0_70:
	vmovups	-29(%rsi), %xmm0
	vmovups	%xmm0, -29(%rcx)
	vmovups	-16(%rsi), %xmm0
	vmovups	%xmm0, -16(%rcx)
	vzeroupper
	retq
.LBB0_71:
	vmovups	-158(%rsi), %ymm0
	vmovups	%ymm0, -158(%rcx)
	vmovups	-126(%rsi), %ymm0
	vmovups	%ymm0, -126(%rcx)
	vmovups	-94(%rsi), %ymm0
	vmovups	%ymm0, -94(%rcx)
	vmovups	-62(%rsi), %ymm0
	vmovups	%ymm0, -62(%rcx)
.LBB0_72:
	vmovups	-30(%rsi), %xmm0
	vmovups	%xmm0, -30(%rcx)
	vmovups	-16(%rsi), %xmm0
	vmovups	%xmm0, -16(%rcx)
	vzeroupper
	retq
.LBB0_73:
	vmovups	-159(%rsi), %ymm0
	vmovups	%ymm0, -159(%rcx)
	vmovups	-127(%rsi), %ymm0
	vmovups	%ymm0, -127(%rcx)
	vmovups	-95(%rsi), %ymm0
	vmovups	%ymm0, -95(%rcx)
	vmovups	-63(%rsi), %ymm0
	vmovups	%ymm0, -63(%rcx)
.LBB0_74:
	vmovups	-31(%rsi), %xmm0
	vmovups	%xmm0, -31(%rcx)
	vmovups	-16(%rsi), %xmm0
	vmovups	%xmm0, -16(%rcx)
	vzeroupper
	retq
.LBB0_75:
	vmovups	-193(%rsi), %ymm0
	vmovups	%ymm0, -193(%rcx)
.LBB0_76:
	vmovups	-161(%rsi), %ymm0
	vmovups	%ymm0, -161(%rcx)
.LBB0_3:
	vmovups	-129(%rsi), %ymm0
	vmovups	%ymm0, -129(%rcx)
	vmovups	-97(%rsi), %ymm0
	vmovups	%ymm0, -97(%rcx)
.LBB0_4:
	vmovups	-65(%rsi), %ymm0
	vmovups	%ymm0, -65(%rcx)
.LBB0_5:
	vmovups	-33(%rsi), %ymm0
	vmovups	%ymm0, -33(%rcx)
.LBB0_6:
	movb	-1(%rsi), %dl
	movb	%dl, -1(%rcx)
	vzeroupper
	retq
.LBB0_77:
	vmovups	-194(%rsi), %ymm0
	vmovups	%ymm0, -194(%rcx)
.LBB0_78:
	vmovups	-162(%rsi), %ymm0
	vmovups	%ymm0, -162(%rcx)
.LBB0_7:
	vmovups	-130(%rsi), %ymm0
	vmovups	%ymm0, -130(%rcx)
	vmovups	-98(%rsi), %ymm0
	vmovups	%ymm0, -98(%rcx)
.LBB0_8:
	vmovups	-66(%rsi), %ymm0
	vmovups	%ymm0, -66(%rcx)
.LBB0_9:
	vmovups	-34(%rsi), %ymm0
	vmovups	%ymm0, -34(%rcx)
.LBB0_10:
	movzwl	-2(%rsi), %edx
	movw	%dx, -2(%rcx)
	vzeroupper
	retq
.LBB0_79:
	vmovups	-195(%rsi), %ymm0
	vmovups	%ymm0, -195(%rcx)
.LBB0_80:
	vmovups	-163(%rsi), %ymm0
	vmovups	%ymm0, -163(%rcx)
	vmovups	-131(%rsi), %ymm0
	vmovups	%ymm0, -131(%rcx)
	vmovups	-99(%rsi), %ymm0
	vmovups	%ymm0, -99(%rcx)
.LBB0_81:
	vmovups	-67(%rsi), %ymm0
	vmovups	%ymm0, -67(%rcx)
.LBB0_82:
	vmovups	-35(%rsi), %ymm0
	vmovups	%ymm0, -35(%rcx)
	movl	-4(%rsi), %edx
	movl	%edx, -4(%rcx)
	vzeroupper
	retq
.LBB0_83:
	vmovups	-196(%rsi), %ymm0
	vmovups	%ymm0, -196(%rcx)
.LBB0_84:
	vmovups	-164(%rsi), %ymm0
	vmovups	%ymm0, -164(%rcx)
.LBB0_13:
	vmovups	-132(%rsi), %ymm0
	vmovups	%ymm0, -132(%rcx)
	vmovups	-100(%rsi), %ymm0
	vmovups	%ymm0, -100(%rcx)
.LBB0_14:
	vmovups	-68(%rsi), %ymm0
	vmovups	%ymm0, -68(%rcx)
.LBB0_15:
	vmovups	-36(%rsi), %ymm0
	vmovups	%ymm0, -36(%rcx)
.LBB0_16:
	movl	-4(%rsi), %edx
	movl	%edx, -4(%rcx)
	vzeroupper
	retq
.LBB0_85:
	vmovups	-197(%rsi), %ymm0
	vmovups	%ymm0, -197(%rcx)
.LBB0_86:
	vmovups	-165(%rsi), %ymm0
	vmovups	%ymm0, -165(%rcx)
	vmovups	-133(%rsi), %ymm0
	vmovups	%ymm0, -133(%rcx)
	vmovups	-101(%rsi), %ymm0
	vmovups	%ymm0, -101(%rcx)
.LBB0_87:
	vmovups	-69(%rsi), %ymm0
	vmovups	%ymm0, -69(%rcx)
.LBB0_88:
	vmovups	-37(%rsi), %ymm0
	vmovups	%ymm0, -37(%rcx)
	movq	-8(%rsi), %rdx
	movq	%rdx, -8(%rcx)
	vzeroupper
	retq
.LBB0_89:
	vmovups	-198(%rsi), %ymm0
	vmovups	%ymm0, -198(%rcx)
.LBB0_90:
	vmovups	-166(%rsi), %ymm0
	vmovups	%ymm0, -166(%rcx)
	vmovups	-134(%rsi), %ymm0
	vmovups	%ymm0, -134(%rcx)
	vmovups	-102(%rsi), %ymm0
	vmovups	%ymm0, -102(%rcx)
.LBB0_91:
	vmovups	-70(%rsi), %ymm0
	vmovups	%ymm0, -70(%rcx)
.LBB0_92:
	vmovups	-38(%rsi), %ymm0
	vmovups	%ymm0, -38(%rcx)
	movq	-8(%rsi), %rdx
	movq	%rdx, -8(%rcx)
	vzeroupper
	retq
.LBB0_93:
	vmovups	-199(%rsi), %ymm0
	vmovups	%ymm0, -199(%rcx)
.LBB0_94:
	vmovups	-167(%rsi), %ymm0
	vmovups	%ymm0, -167(%rcx)
	vmovups	-135(%rsi), %ymm0
	vmovups	%ymm0, -135(%rcx)
	vmovups	-103(%rsi), %ymm0
	vmovups	%ymm0, -103(%rcx)
.LBB0_95:
	vmovups	-71(%rsi), %ymm0
	vmovups	%ymm0, -71(%rcx)
.LBB0_96:
	vmovups	-39(%rsi), %ymm0
	vmovups	%ymm0, -39(%rcx)
	movq	-8(%rsi), %rdx
	movq	%rdx, -8(%rcx)
	vzeroupper
	retq
.LBB0_97:
	vmovups	-200(%rsi), %ymm0
	vmovups	%ymm0, -200(%rcx)
.LBB0_98:
	vmovups	-168(%rsi), %ymm0
	vmovups	%ymm0, -168(%rcx)
.LBB0_23:
	vmovups	-136(%rsi), %ymm0
	vmovups	%ymm0, -136(%rcx)
	vmovups	-104(%rsi), %ymm0
	vmovups	%ymm0, -104(%rcx)
.LBB0_24:
	vmovups	-72(%rsi), %ymm0
	vmovups	%ymm0, -72(%rcx)
.LBB0_25:
	vmovups	-40(%rsi), %ymm0
	vmovups	%ymm0, -40(%rcx)
.LBB0_26:
	movq	-8(%rsi), %rdx
	movq	%rdx, -8(%rcx)
	vzeroupper
	retq
.LBB0_99:
	vmovups	-201(%rsi), %ymm0
	vmovups	%ymm0, -201(%rcx)
.LBB0_100:
	vmovups	-169(%rsi), %ymm0
	vmovups	%ymm0, -169(%rcx)
	vmovups	-137(%rsi), %ymm0
	vmovups	%ymm0, -137(%rcx)
	vmovups	-105(%rsi), %ymm0
	vmovups	%ymm0, -105(%rcx)
.LBB0_101:
	vmovups	-73(%rsi), %ymm0
	vmovups	%ymm0, -73(%rcx)
.LBB0_102:
	vmovups	-41(%rsi), %ymm0
	vmovups	%ymm0, -41(%rcx)
	vmovups	-16(%rsi), %xmm0
	vmovups	%xmm0, -16(%rcx)
	vzeroupper
	retq
.LBB0_103:
	vmovups	-202(%rsi), %ymm0
	vmovups	%ymm0, -202(%rcx)
.LBB0_104:
	vmovups	-170(%rsi), %ymm0
	vmovups	%ymm0, -170(%rcx)
	vmovups	-138(%rsi), %ymm0
	vmovups	%ymm0, -138(%rcx)
	vmovups	-106(%rsi), %ymm0
	vmovups	%ymm0, -106(%rcx)
.LBB0_105:
	vmovups	-74(%rsi), %ymm0
	vmovups	%ymm0, -74(%rcx)
.LBB0_106:
	vmovups	-42(%rsi), %ymm0
	vmovups	%ymm0, -42(%rcx)
	vmovups	-16(%rsi), %xmm0
	vmovups	%xmm0, -16(%rcx)
	vzeroupper
	retq
.LBB0_107:
	vmovups	-203(%rsi), %ymm0
	vmovups	%ymm0, -203(%rcx)
.LBB0_108:
	vmovups	-171(%rsi), %ymm0
	vmovups	%ymm0, -171(%rcx)
	vmovups	-139(%rsi), %ymm0
	vmovups	%ymm0, -139(%rcx)
	vmovups	-107(%rsi), %ymm0
	vmovups	%ymm0, -107(%rcx)
.LBB0_109:
	vmovups	-75(%rsi), %ymm0
	vmovups	%ymm0, -75(%rcx)
.LBB0_110:
	vmovups	-43(%rsi), %ymm0
	vmovups	%ymm0, -43(%rcx)
	vmovups	-16(%rsi), %xmm0
	vmovups	%xmm0, -16(%rcx)
	vzeroupper
	retq
.LBB0_111:
	vmovups	-204(%rsi), %ymm0
	vmovups	%ymm0, -204(%rcx)
.LBB0_112:
	vmovups	-172(%rsi), %ymm0
	vmovups	%ymm0, -172(%rcx)
	vmovups	-140(%rsi), %ymm0
	vmovups	%ymm0, -140(%rcx)
	vmovups	-108(%rsi), %ymm0
	vmovups	%ymm0, -108(%rcx)
.LBB0_113:
	vmovups	-76(%rsi), %ymm0
	vmovups	%ymm0, -76(%rcx)
.LBB0_114:
	vmovups	-44(%rsi), %ymm0
	vmovups	%ymm0, -44(%rcx)
	vmovups	-16(%rsi), %xmm0
	vmovups	%xmm0, -16(%rcx)
	vzeroupper
	retq
.LBB0_115:
	vmovups	-205(%rsi), %ymm0
	vmovups	%ymm0, -205(%rcx)
.LBB0_116:
	vmovups	-173(%rsi), %ymm0
	vmovups	%ymm0, -173(%rcx)
	vmovups	-141(%rsi), %ymm0
	vmovups	%ymm0, -141(%rcx)
	vmovups	-109(%rsi), %ymm0
	vmovups	%ymm0, -109(%rcx)
.LBB0_117:
	vmovups	-77(%rsi), %ymm0
	vmovups	%ymm0, -77(%rcx)
.LBB0_118:
	vmovups	-45(%rsi), %ymm0
	vmovups	%ymm0, -45(%rcx)
	vmovups	-16(%rsi), %xmm0
	vmovups	%xmm0, -16(%rcx)
	vzeroupper
	retq
.LBB0_119:
	vmovups	-206(%rsi), %ymm0
	vmovups	%ymm0, -206(%rcx)
.LBB0_120:
	vmovups	-174(%rsi), %ymm0
	vmovups	%ymm0, -174(%rcx)
	vmovups	-142(%rsi), %ymm0
	vmovups	%ymm0, -142(%rcx)
	vmovups	-110(%rsi), %ymm0
	vmovups	%ymm0, -110(%rcx)
.LBB0_121:
	vmovups	-78(%rsi), %ymm0
	vmovups	%ymm0, -78(%rcx)
.LBB0_122:
	vmovups	-46(%rsi), %ymm0
	vmovups	%ymm0, -46(%rcx)
	vmovups	-16(%rsi), %xmm0
	vmovups	%xmm0, -16(%rcx)
	vzeroupper
	retq
.LBB0_123:
	vmovups	-207(%rsi), %ymm0
	vmovups	%ymm0, -207(%rcx)
.LBB0_124:
	vmovups	-175(%rsi), %ymm0
	vmovups	%ymm0, -175(%rcx)
	vmovups	-143(%rsi), %ymm0
	vmovups	%ymm0, -143(%rcx)
	vmovups	-111(%rsi), %ymm0
	vmovups	%ymm0, -111(%rcx)
.LBB0_125:
	vmovups	-79(%rsi), %ymm0
	vmovups	%ymm0, -79(%rcx)
.LBB0_126:
	vmovups	-47(%rsi), %ymm0
	vmovups	%ymm0, -47(%rcx)
	vmovups	-16(%rsi), %xmm0
	vmovups	%xmm0, -16(%rcx)
	vzeroupper
	retq
.LBB0_127:
	vmovups	-208(%rsi), %ymm0
	vmovups	%ymm0, -208(%rcx)
.LBB0_128:
	vmovups	-176(%rsi), %ymm0
	vmovups	%ymm0, -176(%rcx)
.LBB0_41:
	vmovups	-144(%rsi), %ymm0
	vmovups	%ymm0, -144(%rcx)
	vmovups	-112(%rsi), %ymm0
	vmovups	%ymm0, -112(%rcx)
.LBB0_42:
	vmovups	-80(%rsi), %ymm0
	vmovups	%ymm0, -80(%rcx)
.LBB0_43:
	vmovups	-48(%rsi), %ymm0
	vmovups	%ymm0, -48(%rcx)
.LBB0_44:
	vmovups	-16(%rsi), %xmm0
	vmovups	%xmm0, -16(%rcx)
	vzeroupper
	retq
.LBB0_129:
	vmovups	-209(%rsi), %ymm0
	vmovups	%ymm0, -209(%rcx)
.LBB0_130:
	vmovups	-177(%rsi), %ymm0
	vmovups	%ymm0, -177(%rcx)
	vmovups	-145(%rsi), %ymm0
	vmovups	%ymm0, -145(%rcx)
	vmovups	-113(%rsi), %ymm0
	vmovups	%ymm0, -113(%rcx)
.LBB0_131:
	vmovups	-81(%rsi), %ymm0
	vmovups	%ymm0, -81(%rcx)
.LBB0_132:
	vmovups	-49(%rsi), %ymm0
	vmovups	%ymm0, -49(%rcx)
	vmovups	-32(%rsi), %ymm0
	vmovups	%ymm0, -32(%rcx)
	vzeroupper
	retq
.LBB0_133:
	vmovups	-210(%rsi), %ymm0
	vmovups	%ymm0, -210(%rcx)
.LBB0_134:
	vmovups	-178(%rsi), %ymm0
	vmovups	%ymm0, -178(%rcx)
	vmovups	-146(%rsi), %ymm0
	vmovups	%ymm0, -146(%rcx)
	vmovups	-114(%rsi), %ymm0
	vmovups	%ymm0, -114(%rcx)
.LBB0_135:
	vmovups	-82(%rsi), %ymm0
	vmovups	%ymm0, -82(%rcx)
.LBB0_136:
	vmovups	-50(%rsi), %ymm0
	vmovups	%ymm0, -50(%rcx)
	vmovups	-32(%rsi), %ymm0
	vmovups	%ymm0, -32(%rcx)
	vzeroupper
	retq
.LBB0_137:
	vmovups	-211(%rsi), %ymm0
	vmovups	%ymm0, -211(%rcx)
.LBB0_138:
	vmovups	-179(%rsi), %ymm0
	vmovups	%ymm0, -179(%rcx)
	vmovups	-147(%rsi), %ymm0
	vmovups	%ymm0, -147(%rcx)
	vmovups	-115(%rsi), %ymm0
	vmovups	%ymm0, -115(%rcx)
.LBB0_139:
	vmovups	-83(%rsi), %ymm0
	vmovups	%ymm0, -83(%rcx)
.LBB0_140:
	vmovups	-51(%rsi), %ymm0
	vmovups	%ymm0, -51(%rcx)
	vmovups	-32(%rsi), %ymm0
	vmovups	%ymm0, -32(%rcx)
	vzeroupper
	retq
.LBB0_141:
	vmovups	-212(%rsi), %ymm0
	vmovups	%ymm0, -212(%rcx)
.LBB0_142:
	vmovups	-180(%rsi), %ymm0
	vmovups	%ymm0, -180(%rcx)
	vmovups	-148(%rsi), %ymm0
	vmovups	%ymm0, -148(%rcx)
	vmovups	-116(%rsi), %ymm0
	vmovups	%ymm0, -116(%rcx)
.LBB0_143:
	vmovups	-84(%rsi), %ymm0
	vmovups	%ymm0, -84(%rcx)
.LBB0_144:
	vmovups	-52(%rsi), %ymm0
	vmovups	%ymm0, -52(%rcx)
	vmovups	-32(%rsi), %ymm0
	vmovups	%ymm0, -32(%rcx)
	vzeroupper
	retq
.LBB0_145:
	vmovups	-213(%rsi), %ymm0
	vmovups	%ymm0, -213(%rcx)
.LBB0_146:
	vmovups	-181(%rsi), %ymm0
	vmovups	%ymm0, -181(%rcx)
	vmovups	-149(%rsi), %ymm0
	vmovups	%ymm0, -149(%rcx)
	vmovups	-117(%rsi), %ymm0
	vmovups	%ymm0, -117(%rcx)
.LBB0_147:
	vmovups	-85(%rsi), %ymm0
	vmovups	%ymm0, -85(%rcx)
.LBB0_148:
	vmovups	-53(%rsi), %ymm0
	vmovups	%ymm0, -53(%rcx)
	vmovups	-32(%rsi), %ymm0
	vmovups	%ymm0, -32(%rcx)
	vzeroupper
	retq
.LBB0_149:
	vmovups	-214(%rsi), %ymm0
	vmovups	%ymm0, -214(%rcx)
.LBB0_150:
	vmovups	-182(%rsi), %ymm0
	vmovups	%ymm0, -182(%rcx)
	vmovups	-150(%rsi), %ymm0
	vmovups	%ymm0, -150(%rcx)
	vmovups	-118(%rsi), %ymm0
	vmovups	%ymm0, -118(%rcx)
.LBB0_151:
	vmovups	-86(%rsi), %ymm0
	vmovups	%ymm0, -86(%rcx)
.LBB0_152:
	vmovups	-54(%rsi), %ymm0
	vmovups	%ymm0, -54(%rcx)
	vmovups	-32(%rsi), %ymm0
	vmovups	%ymm0, -32(%rcx)
	vzeroupper
	retq
.LBB0_153:
	vmovups	-215(%rsi), %ymm0
	vmovups	%ymm0, -215(%rcx)
.LBB0_154:
	vmovups	-183(%rsi), %ymm0
	vmovups	%ymm0, -183(%rcx)
	vmovups	-151(%rsi), %ymm0
	vmovups	%ymm0, -151(%rcx)
	vmovups	-119(%rsi), %ymm0
	vmovups	%ymm0, -119(%rcx)
.LBB0_155:
	vmovups	-87(%rsi), %ymm0
	vmovups	%ymm0, -87(%rcx)
.LBB0_156:
	vmovups	-55(%rsi), %ymm0
	vmovups	%ymm0, -55(%rcx)
	vmovups	-32(%rsi), %ymm0
	vmovups	%ymm0, -32(%rcx)
	vzeroupper
	retq
.LBB0_157:
	vmovups	-216(%rsi), %ymm0
	vmovups	%ymm0, -216(%rcx)
.LBB0_158:
	vmovups	-184(%rsi), %ymm0
	vmovups	%ymm0, -184(%rcx)
	vmovups	-152(%rsi), %ymm0
	vmovups	%ymm0, -152(%rcx)
	vmovups	-120(%rsi), %ymm0
	vmovups	%ymm0, -120(%rcx)
.LBB0_159:
	vmovups	-88(%rsi), %ymm0
	vmovups	%ymm0, -88(%rcx)
.LBB0_160:
	vmovups	-56(%rsi), %ymm0
	vmovups	%ymm0, -56(%rcx)
	vmovups	-32(%rsi), %ymm0
	vmovups	%ymm0, -32(%rcx)
	vzeroupper
	retq
.LBB0_161:
	vmovups	-217(%rsi), %ymm0
	vmovups	%ymm0, -217(%rcx)
.LBB0_162:
	vmovups	-185(%rsi), %ymm0
	vmovups	%ymm0, -185(%rcx)
	vmovups	-153(%rsi), %ymm0
	vmovups	%ymm0, -153(%rcx)
	vmovups	-121(%rsi), %ymm0
	vmovups	%ymm0, -121(%rcx)
.LBB0_163:
	vmovups	-89(%rsi), %ymm0
	vmovups	%ymm0, -89(%rcx)
.LBB0_164:
	vmovups	-57(%rsi), %ymm0
	vmovups	%ymm0, -57(%rcx)
	vmovups	-32(%rsi), %ymm0
	vmovups	%ymm0, -32(%rcx)
	vzeroupper
	retq
.LBB0_165:
	vmovups	-218(%rsi), %ymm0
	vmovups	%ymm0, -218(%rcx)
.LBB0_166:
	vmovups	-186(%rsi), %ymm0
	vmovups	%ymm0, -186(%rcx)
	vmovups	-154(%rsi), %ymm0
	vmovups	%ymm0, -154(%rcx)
	vmovups	-122(%rsi), %ymm0
	vmovups	%ymm0, -122(%rcx)
.LBB0_167:
	vmovups	-90(%rsi), %ymm0
	vmovups	%ymm0, -90(%rcx)
.LBB0_168:
	vmovups	-58(%rsi), %ymm0
	vmovups	%ymm0, -58(%rcx)
	vmovups	-32(%rsi), %ymm0
	vmovups	%ymm0, -32(%rcx)
	vzeroupper
	retq
.LBB0_169:
	vmovups	-219(%rsi), %ymm0
	vmovups	%ymm0, -219(%rcx)
.LBB0_170:
	vmovups	-187(%rsi), %ymm0
	vmovups	%ymm0, -187(%rcx)
	vmovups	-155(%rsi), %ymm0
	vmovups	%ymm0, -155(%rcx)
	vmovups	-123(%rsi), %ymm0
	vmovups	%ymm0, -123(%rcx)
.LBB0_171:
	vmovups	-91(%rsi), %ymm0
	vmovups	%ymm0, -91(%rcx)
.LBB0_172:
	vmovups	-59(%rsi), %ymm0
	vmovups	%ymm0, -59(%rcx)
	vmovups	-32(%rsi), %ymm0
	vmovups	%ymm0, -32(%rcx)
	vzeroupper
	retq
.LBB0_173:
	vmovups	-220(%rsi), %ymm0
	vmovups	%ymm0, -220(%rcx)
.LBB0_174:
	vmovups	-188(%rsi), %ymm0
	vmovups	%ymm0, -188(%rcx)
	vmovups	-156(%rsi), %ymm0
	vmovups	%ymm0, -156(%rcx)
	vmovups	-124(%rsi), %ymm0
	vmovups	%ymm0, -124(%rcx)
.LBB0_175:
	vmovups	-92(%rsi), %ymm0
	vmovups	%ymm0, -92(%rcx)
.LBB0_176:
	vmovups	-60(%rsi), %ymm0
	vmovups	%ymm0, -60(%rcx)
	vmovups	-32(%rsi), %ymm0
	vmovups	%ymm0, -32(%rcx)
	vzeroupper
	retq
.LBB0_177:
	vmovups	-221(%rsi), %ymm0
	vmovups	%ymm0, -221(%rcx)
.LBB0_178:
	vmovups	-189(%rsi), %ymm0
	vmovups	%ymm0, -189(%rcx)
	vmovups	-157(%rsi), %ymm0
	vmovups	%ymm0, -157(%rcx)
	vmovups	-125(%rsi), %ymm0
	vmovups	%ymm0, -125(%rcx)
.LBB0_179:
	vmovups	-93(%rsi), %ymm0
	vmovups	%ymm0, -93(%rcx)
.LBB0_180:
	vmovups	-61(%rsi), %ymm0
	vmovups	%ymm0, -61(%rcx)
	vmovups	-32(%rsi), %ymm0
	vmovups	%ymm0, -32(%rcx)
	vzeroupper
	retq
.LBB0_181:
	vmovups	-222(%rsi), %ymm0
	vmovups	%ymm0, -222(%rcx)
.LBB0_182:
	vmovups	-190(%rsi), %ymm0
	vmovups	%ymm0, -190(%rcx)
	vmovups	-158(%rsi), %ymm0
	vmovups	%ymm0, -158(%rcx)
	vmovups	-126(%rsi), %ymm0
	vmovups	%ymm0, -126(%rcx)
.LBB0_183:
	vmovups	-94(%rsi), %ymm0
	vmovups	%ymm0, -94(%rcx)
.LBB0_184:
	vmovups	-62(%rsi), %ymm0
	vmovups	%ymm0, -62(%rcx)
	vmovups	-32(%rsi), %ymm0
	vmovups	%ymm0, -32(%rcx)
	vzeroupper
	retq
.LBB0_185:
	vmovups	-223(%rsi), %ymm0
	vmovups	%ymm0, -223(%rcx)
.LBB0_186:
	vmovups	-191(%rsi), %ymm0
	vmovups	%ymm0, -191(%rcx)
	vmovups	-159(%rsi), %ymm0
	vmovups	%ymm0, -159(%rcx)
	vmovups	-127(%rsi), %ymm0
	vmovups	%ymm0, -127(%rcx)
.LBB0_187:
	vmovups	-95(%rsi), %ymm0
	vmovups	%ymm0, -95(%rcx)
.LBB0_188:
	vmovups	-63(%rsi), %ymm0
	vmovups	%ymm0, -63(%rcx)
	vmovups	-32(%rsi), %ymm0
	vmovups	%ymm0, -32(%rcx)
	vzeroupper
	retq
.LBB0_189:
	vmovups	-225(%rsi), %ymm0
	vmovups	%ymm0, -225(%rcx)
	vmovups	-193(%rsi), %ymm0
	vmovups	%ymm0, -193(%rcx)
	vmovups	-161(%rsi), %ymm0
	vmovups	%ymm0, -161(%rcx)
	vmovups	-129(%rsi), %ymm0
	vmovups	%ymm0, -129(%rcx)
.LBB0_190:
	vmovups	-97(%rsi), %ymm0
	vmovups	%ymm0, -97(%rcx)
	vmovups	-65(%rsi), %ymm0
	vmovups	%ymm0, -65(%rcx)
	jmp	.LBB0_257
.LBB0_191:
	vmovups	-226(%rsi), %ymm0
	vmovups	%ymm0, -226(%rcx)
	vmovups	-194(%rsi), %ymm0
	vmovups	%ymm0, -194(%rcx)
	vmovups	-162(%rsi), %ymm0
	vmovups	%ymm0, -162(%rcx)
	vmovups	-130(%rsi), %ymm0
	vmovups	%ymm0, -130(%rcx)
.LBB0_192:
	vmovups	-98(%rsi), %ymm0
	vmovups	%ymm0, -98(%rcx)
	vmovups	-66(%rsi), %ymm0
	vmovups	%ymm0, -66(%rcx)
	jmp	.LBB0_257
.LBB0_193:
	vmovups	-227(%rsi), %ymm0
	vmovups	%ymm0, -227(%rcx)
	vmovups	-195(%rsi), %ymm0
	vmovups	%ymm0, -195(%rcx)
	vmovups	-163(%rsi), %ymm0
	vmovups	%ymm0, -163(%rcx)
	vmovups	-131(%rsi), %ymm0
	vmovups	%ymm0, -131(%rcx)
.LBB0_194:
	vmovups	-99(%rsi), %ymm0
	vmovups	%ymm0, -99(%rcx)
	vmovups	-67(%rsi), %ymm0
	vmovups	%ymm0, -67(%rcx)
	jmp	.LBB0_257
.LBB0_195:
	vmovups	-228(%rsi), %ymm0
	vmovups	%ymm0, -228(%rcx)
	vmovups	-196(%rsi), %ymm0
	vmovups	%ymm0, -196(%rcx)
	vmovups	-164(%rsi), %ymm0
	vmovups	%ymm0, -164(%rcx)
	vmovups	-132(%rsi), %ymm0
	vmovups	%ymm0, -132(%rcx)
.LBB0_196:
	vmovups	-100(%rsi), %ymm0
	vmovups	%ymm0, -100(%rcx)
	vmovups	-68(%rsi), %ymm0
	vmovups	%ymm0, -68(%rcx)
	jmp	.LBB0_257
.LBB0_197:
	vmovups	-229(%rsi), %ymm0
	vmovups	%ymm0, -229(%rcx)
	vmovups	-197(%rsi), %ymm0
	vmovups	%ymm0, -197(%rcx)
	vmovups	-165(%rsi), %ymm0
	vmovups	%ymm0, -165(%rcx)
	vmovups	-133(%rsi), %ymm0
	vmovups	%ymm0, -133(%rcx)
.LBB0_198:
	vmovups	-101(%rsi), %ymm0
	vmovups	%ymm0, -101(%rcx)
	vmovups	-69(%rsi), %ymm0
	vmovups	%ymm0, -69(%rcx)
	jmp	.LBB0_257
.LBB0_199:
	vmovups	-230(%rsi), %ymm0
	vmovups	%ymm0, -230(%rcx)
	vmovups	-198(%rsi), %ymm0
	vmovups	%ymm0, -198(%rcx)
	vmovups	-166(%rsi), %ymm0
	vmovups	%ymm0, -166(%rcx)
	vmovups	-134(%rsi), %ymm0
	vmovups	%ymm0, -134(%rcx)
.LBB0_200:
	vmovups	-102(%rsi), %ymm0
	vmovups	%ymm0, -102(%rcx)
	vmovups	-70(%rsi), %ymm0
	vmovups	%ymm0, -70(%rcx)
	jmp	.LBB0_257
.LBB0_201:
	vmovups	-231(%rsi), %ymm0
	vmovups	%ymm0, -231(%rcx)
	vmovups	-199(%rsi), %ymm0
	vmovups	%ymm0, -199(%rcx)
	vmovups	-167(%rsi), %ymm0
	vmovups	%ymm0, -167(%rcx)
	vmovups	-135(%rsi), %ymm0
	vmovups	%ymm0, -135(%rcx)
.LBB0_202:
	vmovups	-103(%rsi), %ymm0
	vmovups	%ymm0, -103(%rcx)
	vmovups	-71(%rsi), %ymm0
	vmovups	%ymm0, -71(%rcx)
	jmp	.LBB0_257
.LBB0_203:
	vmovups	-232(%rsi), %ymm0
	vmovups	%ymm0, -232(%rcx)
	vmovups	-200(%rsi), %ymm0
	vmovups	%ymm0, -200(%rcx)
	vmovups	-168(%rsi), %ymm0
	vmovups	%ymm0, -168(%rcx)
	vmovups	-136(%rsi), %ymm0
	vmovups	%ymm0, -136(%rcx)
.LBB0_204:
	vmovups	-104(%rsi), %ymm0
	vmovups	%ymm0, -104(%rcx)
	vmovups	-72(%rsi), %ymm0
	vmovups	%ymm0, -72(%rcx)
	jmp	.LBB0_257
.LBB0_205:
	vmovups	-233(%rsi), %ymm0
	vmovups	%ymm0, -233(%rcx)
	vmovups	-201(%rsi), %ymm0
	vmovups	%ymm0, -201(%rcx)
	vmovups	-169(%rsi), %ymm0
	vmovups	%ymm0, -169(%rcx)
	vmovups	-137(%rsi), %ymm0
	vmovups	%ymm0, -137(%rcx)
.LBB0_206:
	vmovups	-105(%rsi), %ymm0
	vmovups	%ymm0, -105(%rcx)
	vmovups	-73(%rsi), %ymm0
	vmovups	%ymm0, -73(%rcx)
	jmp	.LBB0_257
.LBB0_207:
	vmovups	-234(%rsi), %ymm0
	vmovups	%ymm0, -234(%rcx)
	vmovups	-202(%rsi), %ymm0
	vmovups	%ymm0, -202(%rcx)
	vmovups	-170(%rsi), %ymm0
	vmovups	%ymm0, -170(%rcx)
	vmovups	-138(%rsi), %ymm0
	vmovups	%ymm0, -138(%rcx)
.LBB0_208:
	vmovups	-106(%rsi), %ymm0
	vmovups	%ymm0, -106(%rcx)
	vmovups	-74(%rsi), %ymm0
	vmovups	%ymm0, -74(%rcx)
	jmp	.LBB0_257
.LBB0_209:
	vmovups	-235(%rsi), %ymm0
	vmovups	%ymm0, -235(%rcx)
	vmovups	-203(%rsi), %ymm0
	vmovups	%ymm0, -203(%rcx)
	vmovups	-171(%rsi), %ymm0
	vmovups	%ymm0, -171(%rcx)
	vmovups	-139(%rsi), %ymm0
	vmovups	%ymm0, -139(%rcx)
.LBB0_210:
	vmovups	-107(%rsi), %ymm0
	vmovups	%ymm0, -107(%rcx)
	vmovups	-75(%rsi), %ymm0
	vmovups	%ymm0, -75(%rcx)
	jmp	.LBB0_257
.LBB0_211:
	vmovups	-236(%rsi), %ymm0
	vmovups	%ymm0, -236(%rcx)
	vmovups	-204(%rsi), %ymm0
	vmovups	%ymm0, -204(%rcx)
	vmovups	-172(%rsi), %ymm0
	vmovups	%ymm0, -172(%rcx)
	vmovups	-140(%rsi), %ymm0
	vmovups	%ymm0, -140(%rcx)
.LBB0_212:
	vmovups	-108(%rsi), %ymm0
	vmovups	%ymm0, -108(%rcx)
	vmovups	-76(%rsi), %ymm0
	vmovups	%ymm0, -76(%rcx)
	jmp	.LBB0_257
.LBB0_213:
	vmovups	-237(%rsi), %ymm0
	vmovups	%ymm0, -237(%rcx)
	vmovups	-205(%rsi), %ymm0
	vmovups	%ymm0, -205(%rcx)
	vmovups	-173(%rsi), %ymm0
	vmovups	%ymm0, -173(%rcx)
	vmovups	-141(%rsi), %ymm0
	vmovups	%ymm0, -141(%rcx)
.LBB0_214:
	vmovups	-109(%rsi), %ymm0
	vmovups	%ymm0, -109(%rcx)
	vmovups	-77(%rsi), %ymm0
	vmovups	%ymm0, -77(%rcx)
	jmp	.LBB0_257
.LBB0_215:
	vmovups	-238(%rsi), %ymm0
	vmovups	%ymm0, -238(%rcx)
	vmovups	-206(%rsi), %ymm0
	vmovups	%ymm0, -206(%rcx)
	vmovups	-174(%rsi), %ymm0
	vmovups	%ymm0, -174(%rcx)
	vmovups	-142(%rsi), %ymm0
	vmovups	%ymm0, -142(%rcx)
.LBB0_216:
	vmovups	-110(%rsi), %ymm0
	vmovups	%ymm0, -110(%rcx)
	vmovups	-78(%rsi), %ymm0
	vmovups	%ymm0, -78(%rcx)
	jmp	.LBB0_257
.LBB0_217:
	vmovups	-239(%rsi), %ymm0
	vmovups	%ymm0, -239(%rcx)
	vmovups	-207(%rsi), %ymm0
	vmovups	%ymm0, -207(%rcx)
	vmovups	-175(%rsi), %ymm0
	vmovups	%ymm0, -175(%rcx)
	vmovups	-143(%rsi), %ymm0
	vmovups	%ymm0, -143(%rcx)
.LBB0_218:
	vmovups	-111(%rsi), %ymm0
	vmovups	%ymm0, -111(%rcx)
	vmovups	-79(%rsi), %ymm0
	vmovups	%ymm0, -79(%rcx)
	jmp	.LBB0_257
.LBB0_219:
	vmovups	-240(%rsi), %ymm0
	vmovups	%ymm0, -240(%rcx)
	vmovups	-208(%rsi), %ymm0
	vmovups	%ymm0, -208(%rcx)
	vmovups	-176(%rsi), %ymm0
	vmovups	%ymm0, -176(%rcx)
	vmovups	-144(%rsi), %ymm0
	vmovups	%ymm0, -144(%rcx)
.LBB0_220:
	vmovups	-112(%rsi), %ymm0
	vmovups	%ymm0, -112(%rcx)
	vmovups	-80(%rsi), %ymm0
	vmovups	%ymm0, -80(%rcx)
	jmp	.LBB0_257
.LBB0_221:
	vmovups	-241(%rsi), %ymm0
	vmovups	%ymm0, -241(%rcx)
	vmovups	-209(%rsi), %ymm0
	vmovups	%ymm0, -209(%rcx)
	vmovups	-177(%rsi), %ymm0
	vmovups	%ymm0, -177(%rcx)
	vmovups	-145(%rsi), %ymm0
	vmovups	%ymm0, -145(%rcx)
.LBB0_222:
	vmovups	-113(%rsi), %ymm0
	vmovups	%ymm0, -113(%rcx)
	vmovups	-81(%rsi), %ymm0
	vmovups	%ymm0, -81(%rcx)
	jmp	.LBB0_257
.LBB0_223:
	vmovups	-242(%rsi), %ymm0
	vmovups	%ymm0, -242(%rcx)
	vmovups	-210(%rsi), %ymm0
	vmovups	%ymm0, -210(%rcx)
	vmovups	-178(%rsi), %ymm0
	vmovups	%ymm0, -178(%rcx)
	vmovups	-146(%rsi), %ymm0
	vmovups	%ymm0, -146(%rcx)
.LBB0_224:
	vmovups	-114(%rsi), %ymm0
	vmovups	%ymm0, -114(%rcx)
	vmovups	-82(%rsi), %ymm0
	vmovups	%ymm0, -82(%rcx)
	jmp	.LBB0_257
.LBB0_225:
	vmovups	-243(%rsi), %ymm0
	vmovups	%ymm0, -243(%rcx)
	vmovups	-211(%rsi), %ymm0
	vmovups	%ymm0, -211(%rcx)
	vmovups	-179(%rsi), %ymm0
	vmovups	%ymm0, -179(%rcx)
	vmovups	-147(%rsi), %ymm0
	vmovups	%ymm0, -147(%rcx)
.LBB0_226:
	vmovups	-115(%rsi), %ymm0
	vmovups	%ymm0, -115(%rcx)
	vmovups	-83(%rsi), %ymm0
	vmovups	%ymm0, -83(%rcx)
	jmp	.LBB0_257
.LBB0_227:
	vmovups	-244(%rsi), %ymm0
	vmovups	%ymm0, -244(%rcx)
	vmovups	-212(%rsi), %ymm0
	vmovups	%ymm0, -212(%rcx)
	vmovups	-180(%rsi), %ymm0
	vmovups	%ymm0, -180(%rcx)
	vmovups	-148(%rsi), %ymm0
	vmovups	%ymm0, -148(%rcx)
.LBB0_228:
	vmovups	-116(%rsi), %ymm0
	vmovups	%ymm0, -116(%rcx)
	vmovups	-84(%rsi), %ymm0
	vmovups	%ymm0, -84(%rcx)
	jmp	.LBB0_257
.LBB0_229:
	vmovups	-245(%rsi), %ymm0
	vmovups	%ymm0, -245(%rcx)
	vmovups	-213(%rsi), %ymm0
	vmovups	%ymm0, -213(%rcx)
	vmovups	-181(%rsi), %ymm0
	vmovups	%ymm0, -181(%rcx)
	vmovups	-149(%rsi), %ymm0
	vmovups	%ymm0, -149(%rcx)
.LBB0_230:
	vmovups	-117(%rsi), %ymm0
	vmovups	%ymm0, -117(%rcx)
	vmovups	-85(%rsi), %ymm0
	vmovups	%ymm0, -85(%rcx)
	jmp	.LBB0_257
.LBB0_231:
	vmovups	-246(%rsi), %ymm0
	vmovups	%ymm0, -246(%rcx)
	vmovups	-214(%rsi), %ymm0
	vmovups	%ymm0, -214(%rcx)
	vmovups	-182(%rsi), %ymm0
	vmovups	%ymm0, -182(%rcx)
	vmovups	-150(%rsi), %ymm0
	vmovups	%ymm0, -150(%rcx)
.LBB0_232:
	vmovups	-118(%rsi), %ymm0
	vmovups	%ymm0, -118(%rcx)
	vmovups	-86(%rsi), %ymm0
	vmovups	%ymm0, -86(%rcx)
	jmp	.LBB0_257
.LBB0_233:
	vmovups	-247(%rsi), %ymm0
	vmovups	%ymm0, -247(%rcx)
	vmovups	-215(%rsi), %ymm0
	vmovups	%ymm0, -215(%rcx)
	vmovups	-183(%rsi), %ymm0
	vmovups	%ymm0, -183(%rcx)
	vmovups	-151(%rsi), %ymm0
	vmovups	%ymm0, -151(%rcx)
.LBB0_234:
	vmovups	-119(%rsi), %ymm0
	vmovups	%ymm0, -119(%rcx)
	vmovups	-87(%rsi), %ymm0
	vmovups	%ymm0, -87(%rcx)
	jmp	.LBB0_257
.LBB0_235:
	vmovups	-248(%rsi), %ymm0
	vmovups	%ymm0, -248(%rcx)
	vmovups	-216(%rsi), %ymm0
	vmovups	%ymm0, -216(%rcx)
	vmovups	-184(%rsi), %ymm0
	vmovups	%ymm0, -184(%rcx)
	vmovups	-152(%rsi), %ymm0
	vmovups	%ymm0, -152(%rcx)
.LBB0_236:
	vmovups	-120(%rsi), %ymm0
	vmovups	%ymm0, -120(%rcx)
	vmovups	-88(%rsi), %ymm0
	vmovups	%ymm0, -88(%rcx)
	jmp	.LBB0_257
.LBB0_237:
	vmovups	-249(%rsi), %ymm0
	vmovups	%ymm0, -249(%rcx)
	vmovups	-217(%rsi), %ymm0
	vmovups	%ymm0, -217(%rcx)
	vmovups	-185(%rsi), %ymm0
	vmovups	%ymm0, -185(%rcx)
	vmovups	-153(%rsi), %ymm0
	vmovups	%ymm0, -153(%rcx)
.LBB0_238:
	vmovups	-121(%rsi), %ymm0
	vmovups	%ymm0, -121(%rcx)
	vmovups	-89(%rsi), %ymm0
	vmovups	%ymm0, -89(%rcx)
	jmp	.LBB0_257
.LBB0_239:
	vmovups	-250(%rsi), %ymm0
	vmovups	%ymm0, -250(%rcx)
	vmovups	-218(%rsi), %ymm0
	vmovups	%ymm0, -218(%rcx)
	vmovups	-186(%rsi), %ymm0
	vmovups	%ymm0, -186(%rcx)
	vmovups	-154(%rsi), %ymm0
	vmovups	%ymm0, -154(%rcx)
.LBB0_240:
	vmovups	-122(%rsi), %ymm0
	vmovups	%ymm0, -122(%rcx)
	vmovups	-90(%rsi), %ymm0
	vmovups	%ymm0, -90(%rcx)
	jmp	.LBB0_257
.LBB0_241:
	vmovups	-251(%rsi), %ymm0
	vmovups	%ymm0, -251(%rcx)
	vmovups	-219(%rsi), %ymm0
	vmovups	%ymm0, -219(%rcx)
	vmovups	-187(%rsi), %ymm0
	vmovups	%ymm0, -187(%rcx)
	vmovups	-155(%rsi), %ymm0
	vmovups	%ymm0, -155(%rcx)
.LBB0_242:
	vmovups	-123(%rsi), %ymm0
	vmovups	%ymm0, -123(%rcx)
	vmovups	-91(%rsi), %ymm0
	vmovups	%ymm0, -91(%rcx)
	jmp	.LBB0_257
.LBB0_243:
	vmovups	-252(%rsi), %ymm0
	vmovups	%ymm0, -252(%rcx)
	vmovups	-220(%rsi), %ymm0
	vmovups	%ymm0, -220(%rcx)
	vmovups	-188(%rsi), %ymm0
	vmovups	%ymm0, -188(%rcx)
	vmovups	-156(%rsi), %ymm0
	vmovups	%ymm0, -156(%rcx)
.LBB0_244:
	vmovups	-124(%rsi), %ymm0
	vmovups	%ymm0, -124(%rcx)
	vmovups	-92(%rsi), %ymm0
	vmovups	%ymm0, -92(%rcx)
	jmp	.LBB0_257
.LBB0_245:
	vmovups	-253(%rsi), %ymm0
	vmovups	%ymm0, -253(%rcx)
	vmovups	-221(%rsi), %ymm0
	vmovups	%ymm0, -221(%rcx)
	vmovups	-189(%rsi), %ymm0
	vmovups	%ymm0, -189(%rcx)
	vmovups	-157(%rsi), %ymm0
	vmovups	%ymm0, -157(%rcx)
.LBB0_246:
	vmovups	-125(%rsi), %ymm0
	vmovups	%ymm0, -125(%rcx)
	vmovups	-93(%rsi), %ymm0
	vmovups	%ymm0, -93(%rcx)
	jmp	.LBB0_257
.LBB0_247:
	vmovups	-254(%rsi), %ymm0
	vmovups	%ymm0, -254(%rcx)
	vmovups	-222(%rsi), %ymm0
	vmovups	%ymm0, -222(%rcx)
	vmovups	-190(%rsi), %ymm0
	vmovups	%ymm0, -190(%rcx)
	vmovups	-158(%rsi), %ymm0
	vmovups	%ymm0, -158(%rcx)
.LBB0_248:
	vmovups	-126(%rsi), %ymm0
	vmovups	%ymm0, -126(%rcx)
	vmovups	-94(%rsi), %ymm0
	vmovups	%ymm0, -94(%rcx)
	jmp	.LBB0_257
.LBB0_249:
	vmovups	-255(%rsi), %ymm0
	vmovups	%ymm0, -255(%rcx)
	vmovups	-223(%rsi), %ymm0
	vmovups	%ymm0, -223(%rcx)
	vmovups	-191(%rsi), %ymm0
	vmovups	%ymm0, -191(%rcx)
	vmovups	-159(%rsi), %ymm0
	vmovups	%ymm0, -159(%rcx)
.LBB0_250:
	vmovups	-127(%rsi), %ymm0
	vmovups	%ymm0, -127(%rcx)
	vmovups	-95(%rsi), %ymm0
	vmovups	%ymm0, -95(%rcx)
	jmp	.LBB0_257
.LBB0_251:
	vmovups	-256(%rsi), %ymm0
	vmovups	%ymm0, -256(%rcx)
.LBB0_252:
	vmovups	-224(%rsi), %ymm0
	vmovups	%ymm0, -224(%rcx)
.LBB0_253:
	vmovups	-192(%rsi), %ymm0
	vmovups	%ymm0, -192(%rcx)
.LBB0_254:
	vmovups	-160(%rsi), %ymm0
	vmovups	%ymm0, -160(%rcx)
.LBB0_255:
	vmovups	-128(%rsi), %ymm0
	vmovups	%ymm0, -128(%rcx)
.LBB0_256:
	vmovups	-96(%rsi), %ymm0
	vmovups	%ymm0, -96(%rcx)
.LBB0_257:
	vmovups	-64(%rsi), %ymm0
	vmovups	%ymm0, -64(%rcx)
.LBB0_258:
	vmovups	-32(%rsi), %ymm0
	vmovups	%ymm0, -32(%rcx)
	vzeroupper
	retq
.LBB0_284:
	vmovups	-133(%rsi), %ymm0
	vmovups	%ymm0, -133(%r8)
	vmovups	-101(%rsi), %ymm0
	vmovups	%ymm0, -101(%r8)
	vmovups	-69(%rsi), %ymm0
	vmovups	%ymm0, -69(%r8)
	vmovups	-37(%rsi), %ymm0
	vmovups	%ymm0, -37(%r8)
.LBB0_285:
	movl	-5(%rsi), %ecx
	movl	%ecx, -5(%r8)
	movb	-1(%rsi), %cl
	movb	%cl, -1(%r8)
	vzeroupper
	retq
.LBB0_286:
	vmovups	-134(%rsi), %ymm0
	vmovups	%ymm0, -134(%r8)
	vmovups	-102(%rsi), %ymm0
	vmovups	%ymm0, -102(%r8)
	vmovups	-70(%rsi), %ymm0
	vmovups	%ymm0, -70(%r8)
	vmovups	-38(%rsi), %ymm0
	vmovups	%ymm0, -38(%r8)
.LBB0_287:
	movl	-6(%rsi), %ecx
	movl	%ecx, -6(%r8)
	movzwl	-2(%rsi), %ecx
	movw	%cx, -2(%r8)
	vzeroupper
	retq
.LBB0_288:
	vmovups	-135(%rsi), %ymm0
	vmovups	%ymm0, -135(%r8)
	vmovups	-103(%rsi), %ymm0
	vmovups	%ymm0, -103(%r8)
	vmovups	-71(%rsi), %ymm0
	vmovups	%ymm0, -71(%r8)
	vmovups	-39(%rsi), %ymm0
	vmovups	%ymm0, -39(%r8)
.LBB0_289:
	movl	-7(%rsi), %ecx
	movl	%ecx, -7(%r8)
	movl	-4(%rsi), %ecx
	movl	%ecx, -4(%r8)
	vzeroupper
	retq
.LBB0_294:
	vmovups	-137(%rsi), %ymm0
	vmovups	%ymm0, -137(%r8)
	vmovups	-105(%rsi), %ymm0
	vmovups	%ymm0, -105(%r8)
	vmovups	-73(%rsi), %ymm0
	vmovups	%ymm0, -73(%r8)
	vmovups	-41(%rsi), %ymm0
	vmovups	%ymm0, -41(%r8)
.LBB0_295:
	movq	-9(%rsi), %rcx
	movq	%rcx, -9(%r8)
	movb	-1(%rsi), %cl
	movb	%cl, -1(%r8)
	vzeroupper
	retq
.LBB0_296:
	vmovups	-138(%rsi), %ymm0
	vmovups	%ymm0, -138(%r8)
	vmovups	-106(%rsi), %ymm0
	vmovups	%ymm0, -106(%r8)
	vmovups	-74(%rsi), %ymm0
	vmovups	%ymm0, -74(%r8)
	vmovups	-42(%rsi), %ymm0
	vmovups	%ymm0, -42(%r8)
.LBB0_297:
	movq	-10(%rsi), %rcx
	movq	%rcx, -10(%r8)
	movzwl	-2(%rsi), %ecx
	movw	%cx, -2(%r8)
	vzeroupper
	retq
.LBB0_298:
	vmovups	-139(%rsi), %ymm0
	vmovups	%ymm0, -139(%r8)
	vmovups	-107(%rsi), %ymm0
	vmovups	%ymm0, -107(%r8)
	vmovups	-75(%rsi), %ymm0
	vmovups	%ymm0, -75(%r8)
	vmovups	-43(%rsi), %ymm0
	vmovups	%ymm0, -43(%r8)
.LBB0_299:
	movq	-11(%rsi), %rcx
	movq	%rcx, -11(%r8)
	movl	-4(%rsi), %ecx
	movl	%ecx, -4(%r8)
	vzeroupper
	retq
.LBB0_300:
	vmovups	-140(%rsi), %ymm0
	vmovups	%ymm0, -140(%r8)
	vmovups	-108(%rsi), %ymm0
	vmovups	%ymm0, -108(%r8)
	vmovups	-76(%rsi), %ymm0
	vmovups	%ymm0, -76(%r8)
	vmovups	-44(%rsi), %ymm0
	vmovups	%ymm0, -44(%r8)
.LBB0_301:
	movq	-12(%rsi), %rcx
	movq	%rcx, -12(%r8)
	movl	-4(%rsi), %ecx
	movl	%ecx, -4(%r8)
	vzeroupper
	retq
.LBB0_302:
	vmovups	-141(%rsi), %ymm0
	vmovups	%ymm0, -141(%r8)
	vmovups	-109(%rsi), %ymm0
	vmovups	%ymm0, -109(%r8)
	vmovups	-77(%rsi), %ymm0
	vmovups	%ymm0, -77(%r8)
	vmovups	-45(%rsi), %ymm0
	vmovups	%ymm0, -45(%r8)
.LBB0_303:
	movq	-13(%rsi), %rcx
	movq	%rcx, -13(%r8)
	movq	-8(%rsi), %rcx
	movq	%rcx, -8(%r8)
	vzeroupper
	retq
.LBB0_304:
	vmovups	-142(%rsi), %ymm0
	vmovups	%ymm0, -142(%r8)
	vmovups	-110(%rsi), %ymm0
	vmovups	%ymm0, -110(%r8)
	vmovups	-78(%rsi), %ymm0
	vmovups	%ymm0, -78(%r8)
	vmovups	-46(%rsi), %ymm0
	vmovups	%ymm0, -46(%r8)
.LBB0_305:
	movq	-14(%rsi), %rcx
	movq	%rcx, -14(%r8)
	movq	-8(%rsi), %rcx
	movq	%rcx, -8(%r8)
	vzeroupper
	retq
.LBB0_306:
	vmovups	-143(%rsi), %ymm0
	vmovups	%ymm0, -143(%r8)
	vmovups	-111(%rsi), %ymm0
	vmovups	%ymm0, -111(%r8)
	vmovups	-79(%rsi), %ymm0
	vmovups	%ymm0, -79(%r8)
	vmovups	-47(%rsi), %ymm0
	vmovups	%ymm0, -47(%r8)
.LBB0_307:
	movq	-15(%rsi), %rcx
	movq	%rcx, -15(%r8)
	movq	-8(%rsi), %rcx
	movq	%rcx, -8(%r8)
	vzeroupper
	retq
.LBB0_312:
	vmovups	-145(%rsi), %ymm0
	vmovups	%ymm0, -145(%r8)
	vmovups	-113(%rsi), %ymm0
	vmovups	%ymm0, -113(%r8)
	vmovups	-81(%rsi), %ymm0
	vmovups	%ymm0, -81(%r8)
	vmovups	-49(%rsi), %ymm0
	vmovups	%ymm0, -49(%r8)
.LBB0_313:
	vmovups	-17(%rsi), %xmm0
	vmovups	%xmm0, -17(%r8)
	movb	-1(%rsi), %cl
	movb	%cl, -1(%r8)
	vzeroupper
	retq
.LBB0_314:
	vmovups	-146(%rsi), %ymm0
	vmovups	%ymm0, -146(%r8)
	vmovups	-114(%rsi), %ymm0
	vmovups	%ymm0, -114(%r8)
	vmovups	-82(%rsi), %ymm0
	vmovups	%ymm0, -82(%r8)
	vmovups	-50(%rsi), %ymm0
	vmovups	%ymm0, -50(%r8)
.LBB0_315:
	vmovups	-18(%rsi), %xmm0
	vmovups	%xmm0, -18(%r8)
	movzwl	-2(%rsi), %ecx
	movw	%cx, -2(%r8)
	vzeroupper
	retq
.LBB0_316:
	vmovups	-147(%rsi), %ymm0
	vmovups	%ymm0, -147(%r8)
	vmovups	-115(%rsi), %ymm0
	vmovups	%ymm0, -115(%r8)
	vmovups	-83(%rsi), %ymm0
	vmovups	%ymm0, -83(%r8)
	vmovups	-51(%rsi), %ymm0
	vmovups	%ymm0, -51(%r8)
.LBB0_317:
	vmovups	-19(%rsi), %xmm0
	vmovups	%xmm0, -19(%r8)
	movl	-4(%rsi), %ecx
	movl	%ecx, -4(%r8)
	vzeroupper
	retq
.LBB0_318:
	vmovups	-148(%rsi), %ymm0
	vmovups	%ymm0, -148(%r8)
	vmovups	-116(%rsi), %ymm0
	vmovups	%ymm0, -116(%r8)
	vmovups	-84(%rsi), %ymm0
	vmovups	%ymm0, -84(%r8)
	vmovups	-52(%rsi), %ymm0
	vmovups	%ymm0, -52(%r8)
.LBB0_319:
	vmovups	-20(%rsi), %xmm0
	vmovups	%xmm0, -20(%r8)
	movl	-4(%rsi), %ecx
	movl	%ecx, -4(%r8)
	vzeroupper
	retq
.LBB0_320:
	vmovups	-149(%rsi), %ymm0
	vmovups	%ymm0, -149(%r8)
	vmovups	-117(%rsi), %ymm0
	vmovups	%ymm0, -117(%r8)
	vmovups	-85(%rsi), %ymm0
	vmovups	%ymm0, -85(%r8)
	vmovups	-53(%rsi), %ymm0
	vmovups	%ymm0, -53(%r8)
.LBB0_321:
	vmovups	-21(%rsi), %xmm0
	vmovups	%xmm0, -21(%r8)
	movq	-8(%rsi), %rcx
	movq	%rcx, -8(%r8)
	vzeroupper
	retq
.LBB0_322:
	vmovups	-150(%rsi), %ymm0
	vmovups	%ymm0, -150(%r8)
	vmovups	-118(%rsi), %ymm0
	vmovups	%ymm0, -118(%r8)
	vmovups	-86(%rsi), %ymm0
	vmovups	%ymm0, -86(%r8)
	vmovups	-54(%rsi), %ymm0
	vmovups	%ymm0, -54(%r8)
.LBB0_323:
	vmovups	-22(%rsi), %xmm0
	vmovups	%xmm0, -22(%r8)
	movq	-8(%rsi), %rcx
	movq	%rcx, -8(%r8)
	vzeroupper
	retq
.LBB0_324:
	vmovups	-151(%rsi), %ymm0
	vmovups	%ymm0, -151(%r8)
	vmovups	-119(%rsi), %ymm0
	vmovups	%ymm0, -119(%r8)
	vmovups	-87(%rsi), %ymm0
	vmovups	%ymm0, -87(%r8)
	vmovups	-55(%rsi), %ymm0
	vmovups	%ymm0, -55(%r8)
.LBB0_325:
	vmovups	-23(%rsi), %xmm0
	vmovups	%xmm0, -23(%r8)
	movq	-8(%rsi), %rcx
	movq	%rcx, -8(%r8)
	vzeroupper
	retq
.LBB0_326:
	vmovups	-152(%rsi), %ymm0
	vmovups	%ymm0, -152(%r8)
	vmovups	-120(%rsi), %ymm0
	vmovups	%ymm0, -120(%r8)
	vmovups	-88(%rsi), %ymm0
	vmovups	%ymm0, -88(%r8)
	vmovups	-56(%rsi), %ymm0
	vmovups	%ymm0, -56(%r8)
.LBB0_327:
	vmovups	-24(%rsi), %xmm0
	vmovups	%xmm0, -24(%r8)
	movq	-8(%rsi), %rcx
	movq	%rcx, -8(%r8)
	vzeroupper
	retq
.LBB0_328:
	vmovups	-153(%rsi), %ymm0
	vmovups	%ymm0, -153(%r8)
	vmovups	-121(%rsi), %ymm0
	vmovups	%ymm0, -121(%r8)
	vmovups	-89(%rsi), %ymm0
	vmovups	%ymm0, -89(%r8)
	vmovups	-57(%rsi), %ymm0
	vmovups	%ymm0, -57(%r8)
.LBB0_329:
	vmovups	-25(%rsi), %xmm0
	vmovups	%xmm0, -25(%r8)
	vmovups	-16(%rsi), %xmm0
	vmovups	%xmm0, -16(%r8)
	vzeroupper
	retq
.LBB0_330:
	vmovups	-154(%rsi), %ymm0
	vmovups	%ymm0, -154(%r8)
	vmovups	-122(%rsi), %ymm0
	vmovups	%ymm0, -122(%r8)
	vmovups	-90(%rsi), %ymm0
	vmovups	%ymm0, -90(%r8)
	vmovups	-58(%rsi), %ymm0
	vmovups	%ymm0, -58(%r8)
.LBB0_331:
	vmovups	-26(%rsi), %xmm0
	vmovups	%xmm0, -26(%r8)
	vmovups	-16(%rsi), %xmm0
	vmovups	%xmm0, -16(%r8)
	vzeroupper
	retq
.LBB0_332:
	vmovups	-155(%rsi), %ymm0
	vmovups	%ymm0, -155(%r8)
	vmovups	-123(%rsi), %ymm0
	vmovups	%ymm0, -123(%r8)
	vmovups	-91(%rsi), %ymm0
	vmovups	%ymm0, -91(%r8)
	vmovups	-59(%rsi), %ymm0
	vmovups	%ymm0, -59(%r8)
.LBB0_333:
	vmovups	-27(%rsi), %xmm0
	vmovups	%xmm0, -27(%r8)
	vmovups	-16(%rsi), %xmm0
	vmovups	%xmm0, -16(%r8)
	vzeroupper
	retq
.LBB0_334:
	vmovups	-156(%rsi), %ymm0
	vmovups	%ymm0, -156(%r8)
	vmovups	-124(%rsi), %ymm0
	vmovups	%ymm0, -124(%r8)
	vmovups	-92(%rsi), %ymm0
	vmovups	%ymm0, -92(%r8)
	vmovups	-60(%rsi), %ymm0
	vmovups	%ymm0, -60(%r8)
.LBB0_335:
	vmovups	-28(%rsi), %xmm0
	vmovups	%xmm0, -28(%r8)
	vmovups	-16(%rsi), %xmm0
	vmovups	%xmm0, -16(%r8)
	vzeroupper
	retq
.LBB0_336:
	vmovups	-157(%rsi), %ymm0
	vmovups	%ymm0, -157(%r8)
	vmovups	-125(%rsi), %ymm0
	vmovups	%ymm0, -125(%r8)
	vmovups	-93(%rsi), %ymm0
	vmovups	%ymm0, -93(%r8)
	vmovups	-61(%rsi), %ymm0
	vmovups	%ymm0, -61(%r8)
.LBB0_337:
	vmovups	-29(%rsi), %xmm0
	vmovups	%xmm0, -29(%r8)
	vmovups	-16(%rsi), %xmm0
	vmovups	%xmm0, -16(%r8)
	vzeroupper
	retq
.LBB0_338:
	vmovups	-158(%rsi), %ymm0
	vmovups	%ymm0, -158(%r8)
	vmovups	-126(%rsi), %ymm0
	vmovups	%ymm0, -126(%r8)
	vmovups	-94(%rsi), %ymm0
	vmovups	%ymm0, -94(%r8)
	vmovups	-62(%rsi), %ymm0
	vmovups	%ymm0, -62(%r8)
.LBB0_339:
	vmovups	-30(%rsi), %xmm0
	vmovups	%xmm0, -30(%r8)
	vmovups	-16(%rsi), %xmm0
	vmovups	%xmm0, -16(%r8)
	vzeroupper
	retq
.LBB0_340:
	vmovups	-159(%rsi), %ymm0
	vmovups	%ymm0, -159(%r8)
	vmovups	-127(%rsi), %ymm0
	vmovups	%ymm0, -127(%r8)
	vmovups	-95(%rsi), %ymm0
	vmovups	%ymm0, -95(%r8)
	vmovups	-63(%rsi), %ymm0
	vmovups	%ymm0, -63(%r8)
.LBB0_341:
	vmovups	-31(%rsi), %xmm0
	vmovups	%xmm0, -31(%r8)
	vmovups	-16(%rsi), %xmm0
	vmovups	%xmm0, -16(%r8)
	vzeroupper
	retq
.LBB0_342:
	vmovups	-193(%rsi), %ymm0
	vmovups	%ymm0, -193(%r8)
.LBB0_343:
	vmovups	-161(%rsi), %ymm0
	vmovups	%ymm0, -161(%r8)
.LBB0_270:
	vmovups	-129(%rsi), %ymm0
	vmovups	%ymm0, -129(%r8)
	vmovups	-97(%rsi), %ymm0
	vmovups	%ymm0, -97(%r8)
.LBB0_271:
	vmovups	-65(%rsi), %ymm0
	vmovups	%ymm0, -65(%r8)
.LBB0_272:
	vmovups	-33(%rsi), %ymm0
	vmovups	%ymm0, -33(%r8)
.LBB0_273:
	movb	-1(%rsi), %cl
	movb	%cl, -1(%r8)
	vzeroupper
	retq
.LBB0_344:
	vmovups	-194(%rsi), %ymm0
	vmovups	%ymm0, -194(%r8)
.LBB0_345:
	vmovups	-162(%rsi), %ymm0
	vmovups	%ymm0, -162(%r8)
.LBB0_274:
	vmovups	-130(%rsi), %ymm0
	vmovups	%ymm0, -130(%r8)
	vmovups	-98(%rsi), %ymm0
	vmovups	%ymm0, -98(%r8)
.LBB0_275:
	vmovups	-66(%rsi), %ymm0
	vmovups	%ymm0, -66(%r8)
.LBB0_276:
	vmovups	-34(%rsi), %ymm0
	vmovups	%ymm0, -34(%r8)
.LBB0_277:
	movzwl	-2(%rsi), %ecx
	movw	%cx, -2(%r8)
	vzeroupper
	retq
.LBB0_346:
	vmovups	-195(%rsi), %ymm0
	vmovups	%ymm0, -195(%r8)
.LBB0_347:
	vmovups	-163(%rsi), %ymm0
	vmovups	%ymm0, -163(%r8)
	vmovups	-131(%rsi), %ymm0
	vmovups	%ymm0, -131(%r8)
	vmovups	-99(%rsi), %ymm0
	vmovups	%ymm0, -99(%r8)
.LBB0_348:
	vmovups	-67(%rsi), %ymm0
	vmovups	%ymm0, -67(%r8)
.LBB0_349:
	vmovups	-35(%rsi), %ymm0
	vmovups	%ymm0, -35(%r8)
	movl	-4(%rsi), %ecx
	movl	%ecx, -4(%r8)
	vzeroupper
	retq
.LBB0_350:
	vmovups	-196(%rsi), %ymm0
	vmovups	%ymm0, -196(%r8)
.LBB0_351:
	vmovups	-164(%rsi), %ymm0
	vmovups	%ymm0, -164(%r8)
.LBB0_280:
	vmovups	-132(%rsi), %ymm0
	vmovups	%ymm0, -132(%r8)
	vmovups	-100(%rsi), %ymm0
	vmovups	%ymm0, -100(%r8)
.LBB0_281:
	vmovups	-68(%rsi), %ymm0
	vmovups	%ymm0, -68(%r8)
.LBB0_282:
	vmovups	-36(%rsi), %ymm0
	vmovups	%ymm0, -36(%r8)
.LBB0_283:
	movl	-4(%rsi), %ecx
	movl	%ecx, -4(%r8)
	vzeroupper
	retq
.LBB0_352:
	vmovups	-197(%rsi), %ymm0
	vmovups	%ymm0, -197(%r8)
.LBB0_353:
	vmovups	-165(%rsi), %ymm0
	vmovups	%ymm0, -165(%r8)
	vmovups	-133(%rsi), %ymm0
	vmovups	%ymm0, -133(%r8)
	vmovups	-101(%rsi), %ymm0
	vmovups	%ymm0, -101(%r8)
.LBB0_354:
	vmovups	-69(%rsi), %ymm0
	vmovups	%ymm0, -69(%r8)
.LBB0_355:
	vmovups	-37(%rsi), %ymm0
	vmovups	%ymm0, -37(%r8)
	movq	-8(%rsi), %rcx
	movq	%rcx, -8(%r8)
	vzeroupper
	retq
.LBB0_356:
	vmovups	-198(%rsi), %ymm0
	vmovups	%ymm0, -198(%r8)
.LBB0_357:
	vmovups	-166(%rsi), %ymm0
	vmovups	%ymm0, -166(%r8)
	vmovups	-134(%rsi), %ymm0
	vmovups	%ymm0, -134(%r8)
	vmovups	-102(%rsi), %ymm0
	vmovups	%ymm0, -102(%r8)
.LBB0_358:
	vmovups	-70(%rsi), %ymm0
	vmovups	%ymm0, -70(%r8)
.LBB0_359:
	vmovups	-38(%rsi), %ymm0
	vmovups	%ymm0, -38(%r8)
	movq	-8(%rsi), %rcx
	movq	%rcx, -8(%r8)
	vzeroupper
	retq
.LBB0_360:
	vmovups	-199(%rsi), %ymm0
	vmovups	%ymm0, -199(%r8)
.LBB0_361:
	vmovups	-167(%rsi), %ymm0
	vmovups	%ymm0, -167(%r8)
	vmovups	-135(%rsi), %ymm0
	vmovups	%ymm0, -135(%r8)
	vmovups	-103(%rsi), %ymm0
	vmovups	%ymm0, -103(%r8)
.LBB0_362:
	vmovups	-71(%rsi), %ymm0
	vmovups	%ymm0, -71(%r8)
.LBB0_363:
	vmovups	-39(%rsi), %ymm0
	vmovups	%ymm0, -39(%r8)
	movq	-8(%rsi), %rcx
	movq	%rcx, -8(%r8)
	vzeroupper
	retq
.LBB0_364:
	vmovups	-200(%rsi), %ymm0
	vmovups	%ymm0, -200(%r8)
.LBB0_365:
	vmovups	-168(%rsi), %ymm0
	vmovups	%ymm0, -168(%r8)
.LBB0_290:
	vmovups	-136(%rsi), %ymm0
	vmovups	%ymm0, -136(%r8)
	vmovups	-104(%rsi), %ymm0
	vmovups	%ymm0, -104(%r8)
.LBB0_291:
	vmovups	-72(%rsi), %ymm0
	vmovups	%ymm0, -72(%r8)
.LBB0_292:
	vmovups	-40(%rsi), %ymm0
	vmovups	%ymm0, -40(%r8)
.LBB0_293:
	movq	-8(%rsi), %rcx
	movq	%rcx, -8(%r8)
	vzeroupper
	retq
.LBB0_366:
	vmovups	-201(%rsi), %ymm0
	vmovups	%ymm0, -201(%r8)
.LBB0_367:
	vmovups	-169(%rsi), %ymm0
	vmovups	%ymm0, -169(%r8)
	vmovups	-137(%rsi), %ymm0
	vmovups	%ymm0, -137(%r8)
	vmovups	-105(%rsi), %ymm0
	vmovups	%ymm0, -105(%r8)
.LBB0_368:
	vmovups	-73(%rsi), %ymm0
	vmovups	%ymm0, -73(%r8)
.LBB0_369:
	vmovups	-41(%rsi), %ymm0
	vmovups	%ymm0, -41(%r8)
	vmovups	-16(%rsi), %xmm0
	vmovups	%xmm0, -16(%r8)
	vzeroupper
	retq
.LBB0_370:
	vmovups	-202(%rsi), %ymm0
	vmovups	%ymm0, -202(%r8)
.LBB0_371:
	vmovups	-170(%rsi), %ymm0
	vmovups	%ymm0, -170(%r8)
	vmovups	-138(%rsi), %ymm0
	vmovups	%ymm0, -138(%r8)
	vmovups	-106(%rsi), %ymm0
	vmovups	%ymm0, -106(%r8)
.LBB0_372:
	vmovups	-74(%rsi), %ymm0
	vmovups	%ymm0, -74(%r8)
.LBB0_373:
	vmovups	-42(%rsi), %ymm0
	vmovups	%ymm0, -42(%r8)
	vmovups	-16(%rsi), %xmm0
	vmovups	%xmm0, -16(%r8)
	vzeroupper
	retq
.LBB0_374:
	vmovups	-203(%rsi), %ymm0
	vmovups	%ymm0, -203(%r8)
.LBB0_375:
	vmovups	-171(%rsi), %ymm0
	vmovups	%ymm0, -171(%r8)
	vmovups	-139(%rsi), %ymm0
	vmovups	%ymm0, -139(%r8)
	vmovups	-107(%rsi), %ymm0
	vmovups	%ymm0, -107(%r8)
.LBB0_376:
	vmovups	-75(%rsi), %ymm0
	vmovups	%ymm0, -75(%r8)
.LBB0_377:
	vmovups	-43(%rsi), %ymm0
	vmovups	%ymm0, -43(%r8)
	vmovups	-16(%rsi), %xmm0
	vmovups	%xmm0, -16(%r8)
	vzeroupper
	retq
.LBB0_378:
	vmovups	-204(%rsi), %ymm0
	vmovups	%ymm0, -204(%r8)
.LBB0_379:
	vmovups	-172(%rsi), %ymm0
	vmovups	%ymm0, -172(%r8)
	vmovups	-140(%rsi), %ymm0
	vmovups	%ymm0, -140(%r8)
	vmovups	-108(%rsi), %ymm0
	vmovups	%ymm0, -108(%r8)
.LBB0_380:
	vmovups	-76(%rsi), %ymm0
	vmovups	%ymm0, -76(%r8)
.LBB0_381:
	vmovups	-44(%rsi), %ymm0
	vmovups	%ymm0, -44(%r8)
	vmovups	-16(%rsi), %xmm0
	vmovups	%xmm0, -16(%r8)
	vzeroupper
	retq
.LBB0_382:
	vmovups	-205(%rsi), %ymm0
	vmovups	%ymm0, -205(%r8)
.LBB0_383:
	vmovups	-173(%rsi), %ymm0
	vmovups	%ymm0, -173(%r8)
	vmovups	-141(%rsi), %ymm0
	vmovups	%ymm0, -141(%r8)
	vmovups	-109(%rsi), %ymm0
	vmovups	%ymm0, -109(%r8)
.LBB0_384:
	vmovups	-77(%rsi), %ymm0
	vmovups	%ymm0, -77(%r8)
.LBB0_385:
	vmovups	-45(%rsi), %ymm0
	vmovups	%ymm0, -45(%r8)
	vmovups	-16(%rsi), %xmm0
	vmovups	%xmm0, -16(%r8)
	vzeroupper
	retq
.LBB0_386:
	vmovups	-206(%rsi), %ymm0
	vmovups	%ymm0, -206(%r8)
.LBB0_387:
	vmovups	-174(%rsi), %ymm0
	vmovups	%ymm0, -174(%r8)
	vmovups	-142(%rsi), %ymm0
	vmovups	%ymm0, -142(%r8)
	vmovups	-110(%rsi), %ymm0
	vmovups	%ymm0, -110(%r8)
.LBB0_388:
	vmovups	-78(%rsi), %ymm0
	vmovups	%ymm0, -78(%r8)
.LBB0_389:
	vmovups	-46(%rsi), %ymm0
	vmovups	%ymm0, -46(%r8)
	vmovups	-16(%rsi), %xmm0
	vmovups	%xmm0, -16(%r8)
	vzeroupper
	retq
.LBB0_390:
	vmovups	-207(%rsi), %ymm0
	vmovups	%ymm0, -207(%r8)
.LBB0_391:
	vmovups	-175(%rsi), %ymm0
	vmovups	%ymm0, -175(%r8)
	vmovups	-143(%rsi), %ymm0
	vmovups	%ymm0, -143(%r8)
	vmovups	-111(%rsi), %ymm0
	vmovups	%ymm0, -111(%r8)
.LBB0_392:
	vmovups	-79(%rsi), %ymm0
	vmovups	%ymm0, -79(%r8)
.LBB0_393:
	vmovups	-47(%rsi), %ymm0
	vmovups	%ymm0, -47(%r8)
	vmovups	-16(%rsi), %xmm0
	vmovups	%xmm0, -16(%r8)
	vzeroupper
	retq
.LBB0_394:
	vmovups	-208(%rsi), %ymm0
	vmovups	%ymm0, -208(%r8)
.LBB0_395:
	vmovups	-176(%rsi), %ymm0
	vmovups	%ymm0, -176(%r8)
.LBB0_308:
	vmovups	-144(%rsi), %ymm0
	vmovups	%ymm0, -144(%r8)
	vmovups	-112(%rsi), %ymm0
	vmovups	%ymm0, -112(%r8)
.LBB0_309:
	vmovups	-80(%rsi), %ymm0
	vmovups	%ymm0, -80(%r8)
.LBB0_310:
	vmovups	-48(%rsi), %ymm0
	vmovups	%ymm0, -48(%r8)
.LBB0_311:
	vmovups	-16(%rsi), %xmm0
	vmovups	%xmm0, -16(%r8)
	vzeroupper
	retq
.LBB0_396:
	vmovups	-209(%rsi), %ymm0
	vmovups	%ymm0, -209(%r8)
.LBB0_397:
	vmovups	-177(%rsi), %ymm0
	vmovups	%ymm0, -177(%r8)
	vmovups	-145(%rsi), %ymm0
	vmovups	%ymm0, -145(%r8)
	vmovups	-113(%rsi), %ymm0
	vmovups	%ymm0, -113(%r8)
.LBB0_398:
	vmovups	-81(%rsi), %ymm0
	vmovups	%ymm0, -81(%r8)
.LBB0_399:
	vmovups	-49(%rsi), %ymm0
	vmovups	%ymm0, -49(%r8)
	jmp	.LBB0_525
.LBB0_400:
	vmovups	-210(%rsi), %ymm0
	vmovups	%ymm0, -210(%r8)
.LBB0_401:
	vmovups	-178(%rsi), %ymm0
	vmovups	%ymm0, -178(%r8)
	vmovups	-146(%rsi), %ymm0
	vmovups	%ymm0, -146(%r8)
	vmovups	-114(%rsi), %ymm0
	vmovups	%ymm0, -114(%r8)
.LBB0_402:
	vmovups	-82(%rsi), %ymm0
	vmovups	%ymm0, -82(%r8)
.LBB0_403:
	vmovups	-50(%rsi), %ymm0
	vmovups	%ymm0, -50(%r8)
	jmp	.LBB0_525
.LBB0_404:
	vmovups	-211(%rsi), %ymm0
	vmovups	%ymm0, -211(%r8)
.LBB0_405:
	vmovups	-179(%rsi), %ymm0
	vmovups	%ymm0, -179(%r8)
	vmovups	-147(%rsi), %ymm0
	vmovups	%ymm0, -147(%r8)
	vmovups	-115(%rsi), %ymm0
	vmovups	%ymm0, -115(%r8)
.LBB0_406:
	vmovups	-83(%rsi), %ymm0
	vmovups	%ymm0, -83(%r8)
.LBB0_407:
	vmovups	-51(%rsi), %ymm0
	vmovups	%ymm0, -51(%r8)
	jmp	.LBB0_525
.LBB0_408:
	vmovups	-212(%rsi), %ymm0
	vmovups	%ymm0, -212(%r8)
.LBB0_409:
	vmovups	-180(%rsi), %ymm0
	vmovups	%ymm0, -180(%r8)
	vmovups	-148(%rsi), %ymm0
	vmovups	%ymm0, -148(%r8)
	vmovups	-116(%rsi), %ymm0
	vmovups	%ymm0, -116(%r8)
.LBB0_410:
	vmovups	-84(%rsi), %ymm0
	vmovups	%ymm0, -84(%r8)
.LBB0_411:
	vmovups	-52(%rsi), %ymm0
	vmovups	%ymm0, -52(%r8)
	jmp	.LBB0_525
.LBB0_412:
	vmovups	-213(%rsi), %ymm0
	vmovups	%ymm0, -213(%r8)
.LBB0_413:
	vmovups	-181(%rsi), %ymm0
	vmovups	%ymm0, -181(%r8)
	vmovups	-149(%rsi), %ymm0
	vmovups	%ymm0, -149(%r8)
	vmovups	-117(%rsi), %ymm0
	vmovups	%ymm0, -117(%r8)
.LBB0_414:
	vmovups	-85(%rsi), %ymm0
	vmovups	%ymm0, -85(%r8)
.LBB0_415:
	vmovups	-53(%rsi), %ymm0
	vmovups	%ymm0, -53(%r8)
	jmp	.LBB0_525
.LBB0_416:
	vmovups	-214(%rsi), %ymm0
	vmovups	%ymm0, -214(%r8)
.LBB0_417:
	vmovups	-182(%rsi), %ymm0
	vmovups	%ymm0, -182(%r8)
	vmovups	-150(%rsi), %ymm0
	vmovups	%ymm0, -150(%r8)
	vmovups	-118(%rsi), %ymm0
	vmovups	%ymm0, -118(%r8)
.LBB0_418:
	vmovups	-86(%rsi), %ymm0
	vmovups	%ymm0, -86(%r8)
.LBB0_419:
	vmovups	-54(%rsi), %ymm0
	vmovups	%ymm0, -54(%r8)
	jmp	.LBB0_525
.LBB0_420:
	vmovups	-215(%rsi), %ymm0
	vmovups	%ymm0, -215(%r8)
.LBB0_421:
	vmovups	-183(%rsi), %ymm0
	vmovups	%ymm0, -183(%r8)
	vmovups	-151(%rsi), %ymm0
	vmovups	%ymm0, -151(%r8)
	vmovups	-119(%rsi), %ymm0
	vmovups	%ymm0, -119(%r8)
.LBB0_422:
	vmovups	-87(%rsi), %ymm0
	vmovups	%ymm0, -87(%r8)
.LBB0_423:
	vmovups	-55(%rsi), %ymm0
	vmovups	%ymm0, -55(%r8)
	jmp	.LBB0_525
.LBB0_424:
	vmovups	-216(%rsi), %ymm0
	vmovups	%ymm0, -216(%r8)
.LBB0_425:
	vmovups	-184(%rsi), %ymm0
	vmovups	%ymm0, -184(%r8)
	vmovups	-152(%rsi), %ymm0
	vmovups	%ymm0, -152(%r8)
	vmovups	-120(%rsi), %ymm0
	vmovups	%ymm0, -120(%r8)
.LBB0_426:
	vmovups	-88(%rsi), %ymm0
	vmovups	%ymm0, -88(%r8)
.LBB0_427:
	vmovups	-56(%rsi), %ymm0
	vmovups	%ymm0, -56(%r8)
	jmp	.LBB0_525
.LBB0_428:
	vmovups	-217(%rsi), %ymm0
	vmovups	%ymm0, -217(%r8)
.LBB0_429:
	vmovups	-185(%rsi), %ymm0
	vmovups	%ymm0, -185(%r8)
	vmovups	-153(%rsi), %ymm0
	vmovups	%ymm0, -153(%r8)
	vmovups	-121(%rsi), %ymm0
	vmovups	%ymm0, -121(%r8)
.LBB0_430:
	vmovups	-89(%rsi), %ymm0
	vmovups	%ymm0, -89(%r8)
.LBB0_431:
	vmovups	-57(%rsi), %ymm0
	vmovups	%ymm0, -57(%r8)
	jmp	.LBB0_525
.LBB0_432:
	vmovups	-218(%rsi), %ymm0
	vmovups	%ymm0, -218(%r8)
.LBB0_433:
	vmovups	-186(%rsi), %ymm0
	vmovups	%ymm0, -186(%r8)
	vmovups	-154(%rsi), %ymm0
	vmovups	%ymm0, -154(%r8)
	vmovups	-122(%rsi), %ymm0
	vmovups	%ymm0, -122(%r8)
.LBB0_434:
	vmovups	-90(%rsi), %ymm0
	vmovups	%ymm0, -90(%r8)
.LBB0_435:
	vmovups	-58(%rsi), %ymm0
	vmovups	%ymm0, -58(%r8)
	jmp	.LBB0_525
.LBB0_436:
	vmovups	-219(%rsi), %ymm0
	vmovups	%ymm0, -219(%r8)
.LBB0_437:
	vmovups	-187(%rsi), %ymm0
	vmovups	%ymm0, -187(%r8)
	vmovups	-155(%rsi), %ymm0
	vmovups	%ymm0, -155(%r8)
	vmovups	-123(%rsi), %ymm0
	vmovups	%ymm0, -123(%r8)
.LBB0_438:
	vmovups	-91(%rsi), %ymm0
	vmovups	%ymm0, -91(%r8)
.LBB0_439:
	vmovups	-59(%rsi), %ymm0
	vmovups	%ymm0, -59(%r8)
	jmp	.LBB0_525
.LBB0_440:
	vmovups	-220(%rsi), %ymm0
	vmovups	%ymm0, -220(%r8)
.LBB0_441:
	vmovups	-188(%rsi), %ymm0
	vmovups	%ymm0, -188(%r8)
	vmovups	-156(%rsi), %ymm0
	vmovups	%ymm0, -156(%r8)
	vmovups	-124(%rsi), %ymm0
	vmovups	%ymm0, -124(%r8)
.LBB0_442:
	vmovups	-92(%rsi), %ymm0
	vmovups	%ymm0, -92(%r8)
.LBB0_443:
	vmovups	-60(%rsi), %ymm0
	vmovups	%ymm0, -60(%r8)
	jmp	.LBB0_525
.LBB0_444:
	vmovups	-221(%rsi), %ymm0
	vmovups	%ymm0, -221(%r8)
.LBB0_445:
	vmovups	-189(%rsi), %ymm0
	vmovups	%ymm0, -189(%r8)
	vmovups	-157(%rsi), %ymm0
	vmovups	%ymm0, -157(%r8)
	vmovups	-125(%rsi), %ymm0
	vmovups	%ymm0, -125(%r8)
.LBB0_446:
	vmovups	-93(%rsi), %ymm0
	vmovups	%ymm0, -93(%r8)
.LBB0_447:
	vmovups	-61(%rsi), %ymm0
	vmovups	%ymm0, -61(%r8)
	jmp	.LBB0_525
.LBB0_448:
	vmovups	-222(%rsi), %ymm0
	vmovups	%ymm0, -222(%r8)
.LBB0_449:
	vmovups	-190(%rsi), %ymm0
	vmovups	%ymm0, -190(%r8)
	vmovups	-158(%rsi), %ymm0
	vmovups	%ymm0, -158(%r8)
	vmovups	-126(%rsi), %ymm0
	vmovups	%ymm0, -126(%r8)
.LBB0_450:
	vmovups	-94(%rsi), %ymm0
	vmovups	%ymm0, -94(%r8)
.LBB0_451:
	vmovups	-62(%rsi), %ymm0
	vmovups	%ymm0, -62(%r8)
	jmp	.LBB0_525
.LBB0_452:
	vmovups	-223(%rsi), %ymm0
	vmovups	%ymm0, -223(%r8)
.LBB0_453:
	vmovups	-191(%rsi), %ymm0
	vmovups	%ymm0, -191(%r8)
	vmovups	-159(%rsi), %ymm0
	vmovups	%ymm0, -159(%r8)
	vmovups	-127(%rsi), %ymm0
	vmovups	%ymm0, -127(%r8)
.LBB0_454:
	vmovups	-95(%rsi), %ymm0
	vmovups	%ymm0, -95(%r8)
.LBB0_455:
	vmovups	-63(%rsi), %ymm0
	vmovups	%ymm0, -63(%r8)
	jmp	.LBB0_525
.LBB0_456:
	vmovups	-225(%rsi), %ymm0
	vmovups	%ymm0, -225(%r8)
	vmovups	-193(%rsi), %ymm0
	vmovups	%ymm0, -193(%r8)
	vmovups	-161(%rsi), %ymm0
	vmovups	%ymm0, -161(%r8)
	vmovups	-129(%rsi), %ymm0
	vmovups	%ymm0, -129(%r8)
.LBB0_457:
	vmovups	-97(%rsi), %ymm0
	vmovups	%ymm0, -97(%r8)
	vmovups	-65(%rsi), %ymm0
	vmovups	%ymm0, -65(%r8)
	jmp	.LBB0_524
.LBB0_458:
	vmovups	-226(%rsi), %ymm0
	vmovups	%ymm0, -226(%r8)
	vmovups	-194(%rsi), %ymm0
	vmovups	%ymm0, -194(%r8)
	vmovups	-162(%rsi), %ymm0
	vmovups	%ymm0, -162(%r8)
	vmovups	-130(%rsi), %ymm0
	vmovups	%ymm0, -130(%r8)
.LBB0_459:
	vmovups	-98(%rsi), %ymm0
	vmovups	%ymm0, -98(%r8)
	vmovups	-66(%rsi), %ymm0
	vmovups	%ymm0, -66(%r8)
	jmp	.LBB0_524
.LBB0_460:
	vmovups	-227(%rsi), %ymm0
	vmovups	%ymm0, -227(%r8)
	vmovups	-195(%rsi), %ymm0
	vmovups	%ymm0, -195(%r8)
	vmovups	-163(%rsi), %ymm0
	vmovups	%ymm0, -163(%r8)
	vmovups	-131(%rsi), %ymm0
	vmovups	%ymm0, -131(%r8)
.LBB0_461:
	vmovups	-99(%rsi), %ymm0
	vmovups	%ymm0, -99(%r8)
	vmovups	-67(%rsi), %ymm0
	vmovups	%ymm0, -67(%r8)
	jmp	.LBB0_524
.LBB0_462:
	vmovups	-228(%rsi), %ymm0
	vmovups	%ymm0, -228(%r8)
	vmovups	-196(%rsi), %ymm0
	vmovups	%ymm0, -196(%r8)
	vmovups	-164(%rsi), %ymm0
	vmovups	%ymm0, -164(%r8)
	vmovups	-132(%rsi), %ymm0
	vmovups	%ymm0, -132(%r8)
.LBB0_463:
	vmovups	-100(%rsi), %ymm0
	vmovups	%ymm0, -100(%r8)
	vmovups	-68(%rsi), %ymm0
	vmovups	%ymm0, -68(%r8)
	jmp	.LBB0_524
.LBB0_464:
	vmovups	-229(%rsi), %ymm0
	vmovups	%ymm0, -229(%r8)
	vmovups	-197(%rsi), %ymm0
	vmovups	%ymm0, -197(%r8)
	vmovups	-165(%rsi), %ymm0
	vmovups	%ymm0, -165(%r8)
	vmovups	-133(%rsi), %ymm0
	vmovups	%ymm0, -133(%r8)
.LBB0_465:
	vmovups	-101(%rsi), %ymm0
	vmovups	%ymm0, -101(%r8)
	vmovups	-69(%rsi), %ymm0
	vmovups	%ymm0, -69(%r8)
	jmp	.LBB0_524
.LBB0_466:
	vmovups	-230(%rsi), %ymm0
	vmovups	%ymm0, -230(%r8)
	vmovups	-198(%rsi), %ymm0
	vmovups	%ymm0, -198(%r8)
	vmovups	-166(%rsi), %ymm0
	vmovups	%ymm0, -166(%r8)
	vmovups	-134(%rsi), %ymm0
	vmovups	%ymm0, -134(%r8)
.LBB0_467:
	vmovups	-102(%rsi), %ymm0
	vmovups	%ymm0, -102(%r8)
	vmovups	-70(%rsi), %ymm0
	vmovups	%ymm0, -70(%r8)
	jmp	.LBB0_524
.LBB0_468:
	vmovups	-231(%rsi), %ymm0
	vmovups	%ymm0, -231(%r8)
	vmovups	-199(%rsi), %ymm0
	vmovups	%ymm0, -199(%r8)
	vmovups	-167(%rsi), %ymm0
	vmovups	%ymm0, -167(%r8)
	vmovups	-135(%rsi), %ymm0
	vmovups	%ymm0, -135(%r8)
.LBB0_469:
	vmovups	-103(%rsi), %ymm0
	vmovups	%ymm0, -103(%r8)
	vmovups	-71(%rsi), %ymm0
	vmovups	%ymm0, -71(%r8)
	jmp	.LBB0_524
.LBB0_470:
	vmovups	-232(%rsi), %ymm0
	vmovups	%ymm0, -232(%r8)
	vmovups	-200(%rsi), %ymm0
	vmovups	%ymm0, -200(%r8)
	vmovups	-168(%rsi), %ymm0
	vmovups	%ymm0, -168(%r8)
	vmovups	-136(%rsi), %ymm0
	vmovups	%ymm0, -136(%r8)
.LBB0_471:
	vmovups	-104(%rsi), %ymm0
	vmovups	%ymm0, -104(%r8)
	vmovups	-72(%rsi), %ymm0
	vmovups	%ymm0, -72(%r8)
	jmp	.LBB0_524
.LBB0_472:
	vmovups	-233(%rsi), %ymm0
	vmovups	%ymm0, -233(%r8)
	vmovups	-201(%rsi), %ymm0
	vmovups	%ymm0, -201(%r8)
	vmovups	-169(%rsi), %ymm0
	vmovups	%ymm0, -169(%r8)
	vmovups	-137(%rsi), %ymm0
	vmovups	%ymm0, -137(%r8)
.LBB0_473:
	vmovups	-105(%rsi), %ymm0
	vmovups	%ymm0, -105(%r8)
	vmovups	-73(%rsi), %ymm0
	vmovups	%ymm0, -73(%r8)
	jmp	.LBB0_524
.LBB0_474:
	vmovups	-234(%rsi), %ymm0
	vmovups	%ymm0, -234(%r8)
	vmovups	-202(%rsi), %ymm0
	vmovups	%ymm0, -202(%r8)
	vmovups	-170(%rsi), %ymm0
	vmovups	%ymm0, -170(%r8)
	vmovups	-138(%rsi), %ymm0
	vmovups	%ymm0, -138(%r8)
.LBB0_475:
	vmovups	-106(%rsi), %ymm0
	vmovups	%ymm0, -106(%r8)
	vmovups	-74(%rsi), %ymm0
	vmovups	%ymm0, -74(%r8)
	jmp	.LBB0_524
.LBB0_476:
	vmovups	-235(%rsi), %ymm0
	vmovups	%ymm0, -235(%r8)
	vmovups	-203(%rsi), %ymm0
	vmovups	%ymm0, -203(%r8)
	vmovups	-171(%rsi), %ymm0
	vmovups	%ymm0, -171(%r8)
	vmovups	-139(%rsi), %ymm0
	vmovups	%ymm0, -139(%r8)
.LBB0_477:
	vmovups	-107(%rsi), %ymm0
	vmovups	%ymm0, -107(%r8)
	vmovups	-75(%rsi), %ymm0
	vmovups	%ymm0, -75(%r8)
	jmp	.LBB0_524
.LBB0_478:
	vmovups	-236(%rsi), %ymm0
	vmovups	%ymm0, -236(%r8)
	vmovups	-204(%rsi), %ymm0
	vmovups	%ymm0, -204(%r8)
	vmovups	-172(%rsi), %ymm0
	vmovups	%ymm0, -172(%r8)
	vmovups	-140(%rsi), %ymm0
	vmovups	%ymm0, -140(%r8)
.LBB0_479:
	vmovups	-108(%rsi), %ymm0
	vmovups	%ymm0, -108(%r8)
	vmovups	-76(%rsi), %ymm0
	vmovups	%ymm0, -76(%r8)
	jmp	.LBB0_524
.LBB0_480:
	vmovups	-237(%rsi), %ymm0
	vmovups	%ymm0, -237(%r8)
	vmovups	-205(%rsi), %ymm0
	vmovups	%ymm0, -205(%r8)
	vmovups	-173(%rsi), %ymm0
	vmovups	%ymm0, -173(%r8)
	vmovups	-141(%rsi), %ymm0
	vmovups	%ymm0, -141(%r8)
.LBB0_481:
	vmovups	-109(%rsi), %ymm0
	vmovups	%ymm0, -109(%r8)
	vmovups	-77(%rsi), %ymm0
	vmovups	%ymm0, -77(%r8)
	jmp	.LBB0_524
.LBB0_482:
	vmovups	-238(%rsi), %ymm0
	vmovups	%ymm0, -238(%r8)
	vmovups	-206(%rsi), %ymm0
	vmovups	%ymm0, -206(%r8)
	vmovups	-174(%rsi), %ymm0
	vmovups	%ymm0, -174(%r8)
	vmovups	-142(%rsi), %ymm0
	vmovups	%ymm0, -142(%r8)
.LBB0_483:
	vmovups	-110(%rsi), %ymm0
	vmovups	%ymm0, -110(%r8)
	vmovups	-78(%rsi), %ymm0
	vmovups	%ymm0, -78(%r8)
	jmp	.LBB0_524
.LBB0_484:
	vmovups	-239(%rsi), %ymm0
	vmovups	%ymm0, -239(%r8)
	vmovups	-207(%rsi), %ymm0
	vmovups	%ymm0, -207(%r8)
	vmovups	-175(%rsi), %ymm0
	vmovups	%ymm0, -175(%r8)
	vmovups	-143(%rsi), %ymm0
	vmovups	%ymm0, -143(%r8)
.LBB0_485:
	vmovups	-111(%rsi), %ymm0
	vmovups	%ymm0, -111(%r8)
	vmovups	-79(%rsi), %ymm0
	vmovups	%ymm0, -79(%r8)
	jmp	.LBB0_524
.LBB0_486:
	vmovups	-240(%rsi), %ymm0
	vmovups	%ymm0, -240(%r8)
	vmovups	-208(%rsi), %ymm0
	vmovups	%ymm0, -208(%r8)
	vmovups	-176(%rsi), %ymm0
	vmovups	%ymm0, -176(%r8)
	vmovups	-144(%rsi), %ymm0
	vmovups	%ymm0, -144(%r8)
.LBB0_487:
	vmovups	-112(%rsi), %ymm0
	vmovups	%ymm0, -112(%r8)
	vmovups	-80(%rsi), %ymm0
	vmovups	%ymm0, -80(%r8)
	jmp	.LBB0_524
.LBB0_488:
	vmovups	-241(%rsi), %ymm0
	vmovups	%ymm0, -241(%r8)
	vmovups	-209(%rsi), %ymm0
	vmovups	%ymm0, -209(%r8)
	vmovups	-177(%rsi), %ymm0
	vmovups	%ymm0, -177(%r8)
	vmovups	-145(%rsi), %ymm0
	vmovups	%ymm0, -145(%r8)
.LBB0_489:
	vmovups	-113(%rsi), %ymm0
	vmovups	%ymm0, -113(%r8)
	vmovups	-81(%rsi), %ymm0
	vmovups	%ymm0, -81(%r8)
	jmp	.LBB0_524
.LBB0_490:
	vmovups	-242(%rsi), %ymm0
	vmovups	%ymm0, -242(%r8)
	vmovups	-210(%rsi), %ymm0
	vmovups	%ymm0, -210(%r8)
	vmovups	-178(%rsi), %ymm0
	vmovups	%ymm0, -178(%r8)
	vmovups	-146(%rsi), %ymm0
	vmovups	%ymm0, -146(%r8)
.LBB0_491:
	vmovups	-114(%rsi), %ymm0
	vmovups	%ymm0, -114(%r8)
	vmovups	-82(%rsi), %ymm0
	vmovups	%ymm0, -82(%r8)
	jmp	.LBB0_524
.LBB0_492:
	vmovups	-243(%rsi), %ymm0
	vmovups	%ymm0, -243(%r8)
	vmovups	-211(%rsi), %ymm0
	vmovups	%ymm0, -211(%r8)
	vmovups	-179(%rsi), %ymm0
	vmovups	%ymm0, -179(%r8)
	vmovups	-147(%rsi), %ymm0
	vmovups	%ymm0, -147(%r8)
.LBB0_493:
	vmovups	-115(%rsi), %ymm0
	vmovups	%ymm0, -115(%r8)
	vmovups	-83(%rsi), %ymm0
	vmovups	%ymm0, -83(%r8)
	jmp	.LBB0_524
.LBB0_494:
	vmovups	-244(%rsi), %ymm0
	vmovups	%ymm0, -244(%r8)
	vmovups	-212(%rsi), %ymm0
	vmovups	%ymm0, -212(%r8)
	vmovups	-180(%rsi), %ymm0
	vmovups	%ymm0, -180(%r8)
	vmovups	-148(%rsi), %ymm0
	vmovups	%ymm0, -148(%r8)
.LBB0_495:
	vmovups	-116(%rsi), %ymm0
	vmovups	%ymm0, -116(%r8)
	vmovups	-84(%rsi), %ymm0
	vmovups	%ymm0, -84(%r8)
	jmp	.LBB0_524
.LBB0_496:
	vmovups	-245(%rsi), %ymm0
	vmovups	%ymm0, -245(%r8)
	vmovups	-213(%rsi), %ymm0
	vmovups	%ymm0, -213(%r8)
	vmovups	-181(%rsi), %ymm0
	vmovups	%ymm0, -181(%r8)
	vmovups	-149(%rsi), %ymm0
	vmovups	%ymm0, -149(%r8)
.LBB0_497:
	vmovups	-117(%rsi), %ymm0
	vmovups	%ymm0, -117(%r8)
	vmovups	-85(%rsi), %ymm0
	vmovups	%ymm0, -85(%r8)
	jmp	.LBB0_524
.LBB0_498:
	vmovups	-246(%rsi), %ymm0
	vmovups	%ymm0, -246(%r8)
	vmovups	-214(%rsi), %ymm0
	vmovups	%ymm0, -214(%r8)
	vmovups	-182(%rsi), %ymm0
	vmovups	%ymm0, -182(%r8)
	vmovups	-150(%rsi), %ymm0
	vmovups	%ymm0, -150(%r8)
.LBB0_499:
	vmovups	-118(%rsi), %ymm0
	vmovups	%ymm0, -118(%r8)
	vmovups	-86(%rsi), %ymm0
	vmovups	%ymm0, -86(%r8)
	jmp	.LBB0_524
.LBB0_500:
	vmovups	-247(%rsi), %ymm0
	vmovups	%ymm0, -247(%r8)
	vmovups	-215(%rsi), %ymm0
	vmovups	%ymm0, -215(%r8)
	vmovups	-183(%rsi), %ymm0
	vmovups	%ymm0, -183(%r8)
	vmovups	-151(%rsi), %ymm0
	vmovups	%ymm0, -151(%r8)
.LBB0_501:
	vmovups	-119(%rsi), %ymm0
	vmovups	%ymm0, -119(%r8)
	vmovups	-87(%rsi), %ymm0
	vmovups	%ymm0, -87(%r8)
	jmp	.LBB0_524
.LBB0_502:
	vmovups	-248(%rsi), %ymm0
	vmovups	%ymm0, -248(%r8)
	vmovups	-216(%rsi), %ymm0
	vmovups	%ymm0, -216(%r8)
	vmovups	-184(%rsi), %ymm0
	vmovups	%ymm0, -184(%r8)
	vmovups	-152(%rsi), %ymm0
	vmovups	%ymm0, -152(%r8)
.LBB0_503:
	vmovups	-120(%rsi), %ymm0
	vmovups	%ymm0, -120(%r8)
	vmovups	-88(%rsi), %ymm0
	vmovups	%ymm0, -88(%r8)
	jmp	.LBB0_524
.LBB0_504:
	vmovups	-249(%rsi), %ymm0
	vmovups	%ymm0, -249(%r8)
	vmovups	-217(%rsi), %ymm0
	vmovups	%ymm0, -217(%r8)
	vmovups	-185(%rsi), %ymm0
	vmovups	%ymm0, -185(%r8)
	vmovups	-153(%rsi), %ymm0
	vmovups	%ymm0, -153(%r8)
.LBB0_505:
	vmovups	-121(%rsi), %ymm0
	vmovups	%ymm0, -121(%r8)
	vmovups	-89(%rsi), %ymm0
	vmovups	%ymm0, -89(%r8)
	jmp	.LBB0_524
.LBB0_506:
	vmovups	-250(%rsi), %ymm0
	vmovups	%ymm0, -250(%r8)
	vmovups	-218(%rsi), %ymm0
	vmovups	%ymm0, -218(%r8)
	vmovups	-186(%rsi), %ymm0
	vmovups	%ymm0, -186(%r8)
	vmovups	-154(%rsi), %ymm0
	vmovups	%ymm0, -154(%r8)
.LBB0_507:
	vmovups	-122(%rsi), %ymm0
	vmovups	%ymm0, -122(%r8)
	vmovups	-90(%rsi), %ymm0
	vmovups	%ymm0, -90(%r8)
	jmp	.LBB0_524
.LBB0_508:
	vmovups	-251(%rsi), %ymm0
	vmovups	%ymm0, -251(%r8)
	vmovups	-219(%rsi), %ymm0
	vmovups	%ymm0, -219(%r8)
	vmovups	-187(%rsi), %ymm0
	vmovups	%ymm0, -187(%r8)
	vmovups	-155(%rsi), %ymm0
	vmovups	%ymm0, -155(%r8)
.LBB0_509:
	vmovups	-123(%rsi), %ymm0
	vmovups	%ymm0, -123(%r8)
	vmovups	-91(%rsi), %ymm0
	vmovups	%ymm0, -91(%r8)
	jmp	.LBB0_524
.LBB0_510:
	vmovups	-252(%rsi), %ymm0
	vmovups	%ymm0, -252(%r8)
	vmovups	-220(%rsi), %ymm0
	vmovups	%ymm0, -220(%r8)
	vmovups	-188(%rsi), %ymm0
	vmovups	%ymm0, -188(%r8)
	vmovups	-156(%rsi), %ymm0
	vmovups	%ymm0, -156(%r8)
.LBB0_511:
	vmovups	-124(%rsi), %ymm0
	vmovups	%ymm0, -124(%r8)
	vmovups	-92(%rsi), %ymm0
	vmovups	%ymm0, -92(%r8)
	jmp	.LBB0_524
.LBB0_512:
	vmovups	-253(%rsi), %ymm0
	vmovups	%ymm0, -253(%r8)
	vmovups	-221(%rsi), %ymm0
	vmovups	%ymm0, -221(%r8)
	vmovups	-189(%rsi), %ymm0
	vmovups	%ymm0, -189(%r8)
	vmovups	-157(%rsi), %ymm0
	vmovups	%ymm0, -157(%r8)
.LBB0_513:
	vmovups	-125(%rsi), %ymm0
	vmovups	%ymm0, -125(%r8)
	vmovups	-93(%rsi), %ymm0
	vmovups	%ymm0, -93(%r8)
	jmp	.LBB0_524
.LBB0_514:
	vmovups	-254(%rsi), %ymm0
	vmovups	%ymm0, -254(%r8)
	vmovups	-222(%rsi), %ymm0
	vmovups	%ymm0, -222(%r8)
	vmovups	-190(%rsi), %ymm0
	vmovups	%ymm0, -190(%r8)
	vmovups	-158(%rsi), %ymm0
	vmovups	%ymm0, -158(%r8)
.LBB0_515:
	vmovups	-126(%rsi), %ymm0
	vmovups	%ymm0, -126(%r8)
	vmovups	-94(%rsi), %ymm0
	vmovups	%ymm0, -94(%r8)
	jmp	.LBB0_524
.LBB0_516:
	vmovups	-255(%rsi), %ymm0
	vmovups	%ymm0, -255(%r8)
	vmovups	-223(%rsi), %ymm0
	vmovups	%ymm0, -223(%r8)
	vmovups	-191(%rsi), %ymm0
	vmovups	%ymm0, -191(%r8)
	vmovups	-159(%rsi), %ymm0
	vmovups	%ymm0, -159(%r8)
.LBB0_517:
	vmovups	-127(%rsi), %ymm0
	vmovups	%ymm0, -127(%r8)
	vmovups	-95(%rsi), %ymm0
	vmovups	%ymm0, -95(%r8)
	jmp	.LBB0_524
.LBB0_518:
	vmovups	-256(%rsi), %ymm0
	vmovups	%ymm0, -256(%r8)
.LBB0_519:
	vmovups	-224(%rsi), %ymm0
	vmovups	%ymm0, -224(%r8)
.LBB0_520:
	vmovups	-192(%rsi), %ymm0
	vmovups	%ymm0, -192(%r8)
.LBB0_521:
	vmovups	-160(%rsi), %ymm0
	vmovups	%ymm0, -160(%r8)
.LBB0_522:
	vmovups	-128(%rsi), %ymm0
	vmovups	%ymm0, -128(%r8)
.LBB0_523:
	vmovups	-96(%rsi), %ymm0
	vmovups	%ymm0, -96(%r8)
.LBB0_524:
	vmovups	-64(%rsi), %ymm0
	vmovups	%ymm0, -64(%r8)
.LBB0_525:
	vmovups	-32(%rsi), %ymm0
	vmovups	%ymm0, -32(%r8)
.LBB0_526:
	vzeroupper
	retq
.Lfunc_end0:
	.cfi_endproc
END(memcpy_avx2)

.LJTI0_0:
	.long	.LBB0_273-.LJTI0_0
	.long	.LBB0_277-.LJTI0_0
	.long	.LBB0_279-.LJTI0_0
	.long	.LBB0_283-.LJTI0_0
	.long	.LBB0_285-.LJTI0_0
	.long	.LBB0_287-.LJTI0_0
	.long	.LBB0_289-.LJTI0_0
	.long	.LBB0_293-.LJTI0_0
	.long	.LBB0_295-.LJTI0_0
	.long	.LBB0_297-.LJTI0_0
	.long	.LBB0_299-.LJTI0_0
	.long	.LBB0_301-.LJTI0_0
	.long	.LBB0_303-.LJTI0_0
	.long	.LBB0_305-.LJTI0_0
	.long	.LBB0_307-.LJTI0_0
	.long	.LBB0_311-.LJTI0_0
	.long	.LBB0_313-.LJTI0_0
	.long	.LBB0_315-.LJTI0_0
	.long	.LBB0_317-.LJTI0_0
	.long	.LBB0_319-.LJTI0_0
	.long	.LBB0_321-.LJTI0_0
	.long	.LBB0_323-.LJTI0_0
	.long	.LBB0_325-.LJTI0_0
	.long	.LBB0_327-.LJTI0_0
	.long	.LBB0_329-.LJTI0_0
	.long	.LBB0_331-.LJTI0_0
	.long	.LBB0_333-.LJTI0_0
	.long	.LBB0_335-.LJTI0_0
	.long	.LBB0_337-.LJTI0_0
	.long	.LBB0_339-.LJTI0_0
	.long	.LBB0_341-.LJTI0_0
	.long	.LBB0_525-.LJTI0_0
	.long	.LBB0_272-.LJTI0_0
	.long	.LBB0_276-.LJTI0_0
	.long	.LBB0_349-.LJTI0_0
	.long	.LBB0_282-.LJTI0_0
	.long	.LBB0_355-.LJTI0_0
	.long	.LBB0_359-.LJTI0_0
	.long	.LBB0_363-.LJTI0_0
	.long	.LBB0_292-.LJTI0_0
	.long	.LBB0_369-.LJTI0_0
	.long	.LBB0_373-.LJTI0_0
	.long	.LBB0_377-.LJTI0_0
	.long	.LBB0_381-.LJTI0_0
	.long	.LBB0_385-.LJTI0_0
	.long	.LBB0_389-.LJTI0_0
	.long	.LBB0_393-.LJTI0_0
	.long	.LBB0_310-.LJTI0_0
	.long	.LBB0_399-.LJTI0_0
	.long	.LBB0_403-.LJTI0_0
	.long	.LBB0_407-.LJTI0_0
	.long	.LBB0_411-.LJTI0_0
	.long	.LBB0_415-.LJTI0_0
	.long	.LBB0_419-.LJTI0_0
	.long	.LBB0_423-.LJTI0_0
	.long	.LBB0_427-.LJTI0_0
	.long	.LBB0_431-.LJTI0_0
	.long	.LBB0_435-.LJTI0_0
	.long	.LBB0_439-.LJTI0_0
	.long	.LBB0_443-.LJTI0_0
	.long	.LBB0_447-.LJTI0_0
	.long	.LBB0_451-.LJTI0_0
	.long	.LBB0_455-.LJTI0_0
	.long	.LBB0_524-.LJTI0_0
	.long	.LBB0_271-.LJTI0_0
	.long	.LBB0_275-.LJTI0_0
	.long	.LBB0_348-.LJTI0_0
	.long	.LBB0_281-.LJTI0_0
	.long	.LBB0_354-.LJTI0_0
	.long	.LBB0_358-.LJTI0_0
	.long	.LBB0_362-.LJTI0_0
	.long	.LBB0_291-.LJTI0_0
	.long	.LBB0_368-.LJTI0_0
	.long	.LBB0_372-.LJTI0_0
	.long	.LBB0_376-.LJTI0_0
	.long	.LBB0_380-.LJTI0_0
	.long	.LBB0_384-.LJTI0_0
	.long	.LBB0_388-.LJTI0_0
	.long	.LBB0_392-.LJTI0_0
	.long	.LBB0_309-.LJTI0_0
	.long	.LBB0_398-.LJTI0_0
	.long	.LBB0_402-.LJTI0_0
	.long	.LBB0_406-.LJTI0_0
	.long	.LBB0_410-.LJTI0_0
	.long	.LBB0_414-.LJTI0_0
	.long	.LBB0_418-.LJTI0_0
	.long	.LBB0_422-.LJTI0_0
	.long	.LBB0_426-.LJTI0_0
	.long	.LBB0_430-.LJTI0_0
	.long	.LBB0_434-.LJTI0_0
	.long	.LBB0_438-.LJTI0_0
	.long	.LBB0_442-.LJTI0_0
	.long	.LBB0_446-.LJTI0_0
	.long	.LBB0_450-.LJTI0_0
	.long	.LBB0_454-.LJTI0_0
	.long	.LBB0_523-.LJTI0_0
	.long	.LBB0_457-.LJTI0_0
	.long	.LBB0_459-.LJTI0_0
	.long	.LBB0_461-.LJTI0_0
	.long	.LBB0_463-.LJTI0_0
	.long	.LBB0_465-.LJTI0_0
	.long	.LBB0_467-.LJTI0_0
	.long	.LBB0_469-.LJTI0_0
	.long	.LBB0_471-.LJTI0_0
	.long	.LBB0_473-.LJTI0_0
	.long	.LBB0_475-.LJTI0_0
	.long	.LBB0_477-.LJTI0_0
	.long	.LBB0_479-.LJTI0_0
	.long	.LBB0_481-.LJTI0_0
	.long	.LBB0_483-.LJTI0_0
	.long	.LBB0_485-.LJTI0_0
	.long	.LBB0_487-.LJTI0_0
	.long	.LBB0_489-.LJTI0_0
	.long	.LBB0_491-.LJTI0_0
	.long	.LBB0_493-.LJTI0_0
	.long	.LBB0_495-.LJTI0_0
	.long	.LBB0_497-.LJTI0_0
	.long	.LBB0_499-.LJTI0_0
	.long	.LBB0_501-.LJTI0_0
	.long	.LBB0_503-.LJTI0_0
	.long	.LBB0_505-.LJTI0_0
	.long	.LBB0_507-.LJTI0_0
	.long	.LBB0_509-.LJTI0_0
	.long	.LBB0_511-.LJTI0_0
	.long	.LBB0_513-.LJTI0_0
	.long	.LBB0_515-.LJTI0_0
	.long	.LBB0_517-.LJTI0_0
	.long	.LBB0_522-.LJTI0_0
	.long	.LBB0_270-.LJTI0_0
	.long	.LBB0_274-.LJTI0_0
	.long	.LBB0_278-.LJTI0_0
	.long	.LBB0_280-.LJTI0_0
	.long	.LBB0_284-.LJTI0_0
	.long	.LBB0_286-.LJTI0_0
	.long	.LBB0_288-.LJTI0_0
	.long	.LBB0_290-.LJTI0_0
	.long	.LBB0_294-.LJTI0_0
	.long	.LBB0_296-.LJTI0_0
	.long	.LBB0_298-.LJTI0_0
	.long	.LBB0_300-.LJTI0_0
	.long	.LBB0_302-.LJTI0_0
	.long	.LBB0_304-.LJTI0_0
	.long	.LBB0_306-.LJTI0_0
	.long	.LBB0_308-.LJTI0_0
	.long	.LBB0_312-.LJTI0_0
	.long	.LBB0_314-.LJTI0_0
	.long	.LBB0_316-.LJTI0_0
	.long	.LBB0_318-.LJTI0_0
	.long	.LBB0_320-.LJTI0_0
	.long	.LBB0_322-.LJTI0_0
	.long	.LBB0_324-.LJTI0_0
	.long	.LBB0_326-.LJTI0_0
	.long	.LBB0_328-.LJTI0_0
	.long	.LBB0_330-.LJTI0_0
	.long	.LBB0_332-.LJTI0_0
	.long	.LBB0_334-.LJTI0_0
	.long	.LBB0_336-.LJTI0_0
	.long	.LBB0_338-.LJTI0_0
	.long	.LBB0_340-.LJTI0_0
	.long	.LBB0_521-.LJTI0_0
	.long	.LBB0_343-.LJTI0_0
	.long	.LBB0_345-.LJTI0_0
	.long	.LBB0_347-.LJTI0_0
	.long	.LBB0_351-.LJTI0_0
	.long	.LBB0_353-.LJTI0_0
	.long	.LBB0_357-.LJTI0_0
	.long	.LBB0_361-.LJTI0_0
	.long	.LBB0_365-.LJTI0_0
	.long	.LBB0_367-.LJTI0_0
	.long	.LBB0_371-.LJTI0_0
	.long	.LBB0_375-.LJTI0_0
	.long	.LBB0_379-.LJTI0_0
	.long	.LBB0_383-.LJTI0_0
	.long	.LBB0_387-.LJTI0_0
	.long	.LBB0_391-.LJTI0_0
	.long	.LBB0_395-.LJTI0_0
	.long	.LBB0_397-.LJTI0_0
	.long	.LBB0_401-.LJTI0_0
	.long	.LBB0_405-.LJTI0_0
	.long	.LBB0_409-.LJTI0_0
	.long	.LBB0_413-.LJTI0_0
	.long	.LBB0_417-.LJTI0_0
	.long	.LBB0_421-.LJTI0_0
	.long	.LBB0_425-.LJTI0_0
	.long	.LBB0_429-.LJTI0_0
	.long	.LBB0_433-.LJTI0_0
	.long	.LBB0_437-.LJTI0_0
	.long	.LBB0_441-.LJTI0_0
	.long	.LBB0_445-.LJTI0_0
	.long	.LBB0_449-.LJTI0_0
	.long	.LBB0_453-.LJTI0_0
	.long	.LBB0_520-.LJTI0_0
	.long	.LBB0_342-.LJTI0_0
	.long	.LBB0_344-.LJTI0_0
	.long	.LBB0_346-.LJTI0_0
	.long	.LBB0_350-.LJTI0_0
	.long	.LBB0_352-.LJTI0_0
	.long	.LBB0_356-.LJTI0_0
	.long	.LBB0_360-.LJTI0_0
	.long	.LBB0_364-.LJTI0_0
	.long	.LBB0_366-.LJTI0_0
	.long	.LBB0_370-.LJTI0_0
	.long	.LBB0_374-.LJTI0_0
	.long	.LBB0_378-.LJTI0_0
	.long	.LBB0_382-.LJTI0_0
	.long	.LBB0_386-.LJTI0_0
	.long	.LBB0_390-.LJTI0_0
	.long	.LBB0_394-.LJTI0_0
	.long	.LBB0_396-.LJTI0_0
	.long	.LBB0_400-.LJTI0_0
	.long	.LBB0_404-.LJTI0_0
	.long	.LBB0_408-.LJTI0_0
	.long	.LBB0_412-.LJTI0_0
	.long	.LBB0_416-.LJTI0_0
	.long	.LBB0_420-.LJTI0_0
	.long	.LBB0_424-.LJTI0_0
	.long	.LBB0_428-.LJTI0_0
	.long	.LBB0_432-.LJTI0_0
	.long	.LBB0_436-.LJTI0_0
	.long	.LBB0_440-.LJTI0_0
	.long	.LBB0_444-.LJTI0_0
	.long	.LBB0_448-.LJTI0_0
	.long	.LBB0_452-.LJTI0_0
	.long	.LBB0_519-.LJTI0_0
	.long	.LBB0_456-.LJTI0_0
	.long	.LBB0_458-.LJTI0_0
	.long	.LBB0_460-.LJTI0_0
	.long	.LBB0_462-.LJTI0_0
	.long	.LBB0_464-.LJTI0_0
	.long	.LBB0_466-.LJTI0_0
	.long	.LBB0_468-.LJTI0_0
	.long	.LBB0_470-.LJTI0_0
	.long	.LBB0_472-.LJTI0_0
	.long	.LBB0_474-.LJTI0_0
	.long	.LBB0_476-.LJTI0_0
	.long	.LBB0_478-.LJTI0_0
	.long	.LBB0_480-.LJTI0_0
	.long	.LBB0_482-.LJTI0_0
	.long	.LBB0_484-.LJTI0_0
	.long	.LBB0_486-.LJTI0_0
	.long	.LBB0_488-.LJTI0_0
	.long	.LBB0_490-.LJTI0_0
	.long	.LBB0_492-.LJTI0_0
	.long	.LBB0_494-.LJTI0_0
	.long	.LBB0_496-.LJTI0_0
	.long	.LBB0_498-.LJTI0_0
	.long	.LBB0_500-.LJTI0_0
	.long	.LBB0_502-.LJTI0_0
	.long	.LBB0_504-.LJTI0_0
	.long	.LBB0_506-.LJTI0_0
	.long	.LBB0_508-.LJTI0_0
	.long	.LBB0_510-.LJTI0_0
	.long	.LBB0_512-.LJTI0_0
	.long	.LBB0_514-.LJTI0_0
	.long	.LBB0_516-.LJTI0_0
	.long	.LBB0_518-.LJTI0_0
.LJTI0_1:
	.long	.LBB0_6-.LJTI0_1
	.long	.LBB0_10-.LJTI0_1
	.long	.LBB0_12-.LJTI0_1
	.long	.LBB0_16-.LJTI0_1
	.long	.LBB0_18-.LJTI0_1
	.long	.LBB0_20-.LJTI0_1
	.long	.LBB0_22-.LJTI0_1
	.long	.LBB0_26-.LJTI0_1
	.long	.LBB0_28-.LJTI0_1
	.long	.LBB0_30-.LJTI0_1
	.long	.LBB0_32-.LJTI0_1
	.long	.LBB0_34-.LJTI0_1
	.long	.LBB0_36-.LJTI0_1
	.long	.LBB0_38-.LJTI0_1
	.long	.LBB0_40-.LJTI0_1
	.long	.LBB0_44-.LJTI0_1
	.long	.LBB0_46-.LJTI0_1
	.long	.LBB0_48-.LJTI0_1
	.long	.LBB0_50-.LJTI0_1
	.long	.LBB0_52-.LJTI0_1
	.long	.LBB0_54-.LJTI0_1
	.long	.LBB0_56-.LJTI0_1
	.long	.LBB0_58-.LJTI0_1
	.long	.LBB0_60-.LJTI0_1
	.long	.LBB0_62-.LJTI0_1
	.long	.LBB0_64-.LJTI0_1
	.long	.LBB0_66-.LJTI0_1
	.long	.LBB0_68-.LJTI0_1
	.long	.LBB0_70-.LJTI0_1
	.long	.LBB0_72-.LJTI0_1
	.long	.LBB0_74-.LJTI0_1
	.long	.LBB0_258-.LJTI0_1
	.long	.LBB0_5-.LJTI0_1
	.long	.LBB0_9-.LJTI0_1
	.long	.LBB0_82-.LJTI0_1
	.long	.LBB0_15-.LJTI0_1
	.long	.LBB0_88-.LJTI0_1
	.long	.LBB0_92-.LJTI0_1
	.long	.LBB0_96-.LJTI0_1
	.long	.LBB0_25-.LJTI0_1
	.long	.LBB0_102-.LJTI0_1
	.long	.LBB0_106-.LJTI0_1
	.long	.LBB0_110-.LJTI0_1
	.long	.LBB0_114-.LJTI0_1
	.long	.LBB0_118-.LJTI0_1
	.long	.LBB0_122-.LJTI0_1
	.long	.LBB0_126-.LJTI0_1
	.long	.LBB0_43-.LJTI0_1
	.long	.LBB0_132-.LJTI0_1
	.long	.LBB0_136-.LJTI0_1
	.long	.LBB0_140-.LJTI0_1
	.long	.LBB0_144-.LJTI0_1
	.long	.LBB0_148-.LJTI0_1
	.long	.LBB0_152-.LJTI0_1
	.long	.LBB0_156-.LJTI0_1
	.long	.LBB0_160-.LJTI0_1
	.long	.LBB0_164-.LJTI0_1
	.long	.LBB0_168-.LJTI0_1
	.long	.LBB0_172-.LJTI0_1
	.long	.LBB0_176-.LJTI0_1
	.long	.LBB0_180-.LJTI0_1
	.long	.LBB0_184-.LJTI0_1
	.long	.LBB0_188-.LJTI0_1
	.long	.LBB0_257-.LJTI0_1
	.long	.LBB0_4-.LJTI0_1
	.long	.LBB0_8-.LJTI0_1
	.long	.LBB0_81-.LJTI0_1
	.long	.LBB0_14-.LJTI0_1
	.long	.LBB0_87-.LJTI0_1
	.long	.LBB0_91-.LJTI0_1
	.long	.LBB0_95-.LJTI0_1
	.long	.LBB0_24-.LJTI0_1
	.long	.LBB0_101-.LJTI0_1
	.long	.LBB0_105-.LJTI0_1
	.long	.LBB0_109-.LJTI0_1
	.long	.LBB0_113-.LJTI0_1
	.long	.LBB0_117-.LJTI0_1
	.long	.LBB0_121-.LJTI0_1
	.long	.LBB0_125-.LJTI0_1
	.long	.LBB0_42-.LJTI0_1
	.long	.LBB0_131-.LJTI0_1
	.long	.LBB0_135-.LJTI0_1
	.long	.LBB0_139-.LJTI0_1
	.long	.LBB0_143-.LJTI0_1
	.long	.LBB0_147-.LJTI0_1
	.long	.LBB0_151-.LJTI0_1
	.long	.LBB0_155-.LJTI0_1
	.long	.LBB0_159-.LJTI0_1
	.long	.LBB0_163-.LJTI0_1
	.long	.LBB0_167-.LJTI0_1
	.long	.LBB0_171-.LJTI0_1
	.long	.LBB0_175-.LJTI0_1
	.long	.LBB0_179-.LJTI0_1
	.long	.LBB0_183-.LJTI0_1
	.long	.LBB0_187-.LJTI0_1
	.long	.LBB0_256-.LJTI0_1
	.long	.LBB0_190-.LJTI0_1
	.long	.LBB0_192-.LJTI0_1
	.long	.LBB0_194-.LJTI0_1
	.long	.LBB0_196-.LJTI0_1
	.long	.LBB0_198-.LJTI0_1
	.long	.LBB0_200-.LJTI0_1
	.long	.LBB0_202-.LJTI0_1
	.long	.LBB0_204-.LJTI0_1
	.long	.LBB0_206-.LJTI0_1
	.long	.LBB0_208-.LJTI0_1
	.long	.LBB0_210-.LJTI0_1
	.long	.LBB0_212-.LJTI0_1
	.long	.LBB0_214-.LJTI0_1
	.long	.LBB0_216-.LJTI0_1
	.long	.LBB0_218-.LJTI0_1
	.long	.LBB0_220-.LJTI0_1
	.long	.LBB0_222-.LJTI0_1
	.long	.LBB0_224-.LJTI0_1
	.long	.LBB0_226-.LJTI0_1
	.long	.LBB0_228-.LJTI0_1
	.long	.LBB0_230-.LJTI0_1
	.long	.LBB0_232-.LJTI0_1
	.long	.LBB0_234-.LJTI0_1
	.long	.LBB0_236-.LJTI0_1
	.long	.LBB0_238-.LJTI0_1
	.long	.LBB0_240-.LJTI0_1
	.long	.LBB0_242-.LJTI0_1
	.long	.LBB0_244-.LJTI0_1
	.long	.LBB0_246-.LJTI0_1
	.long	.LBB0_248-.LJTI0_1
	.long	.LBB0_250-.LJTI0_1
	.long	.LBB0_255-.LJTI0_1
	.long	.LBB0_3-.LJTI0_1
	.long	.LBB0_7-.LJTI0_1
	.long	.LBB0_11-.LJTI0_1
	.long	.LBB0_13-.LJTI0_1
	.long	.LBB0_17-.LJTI0_1
	.long	.LBB0_19-.LJTI0_1
	.long	.LBB0_21-.LJTI0_1
	.long	.LBB0_23-.LJTI0_1
	.long	.LBB0_27-.LJTI0_1
	.long	.LBB0_29-.LJTI0_1
	.long	.LBB0_31-.LJTI0_1
	.long	.LBB0_33-.LJTI0_1
	.long	.LBB0_35-.LJTI0_1
	.long	.LBB0_37-.LJTI0_1
	.long	.LBB0_39-.LJTI0_1
	.long	.LBB0_41-.LJTI0_1
	.long	.LBB0_45-.LJTI0_1
	.long	.LBB0_47-.LJTI0_1
	.long	.LBB0_49-.LJTI0_1
	.long	.LBB0_51-.LJTI0_1
	.long	.LBB0_53-.LJTI0_1
	.long	.LBB0_55-.LJTI0_1
	.long	.LBB0_57-.LJTI0_1
	.long	.LBB0_59-.LJTI0_1
	.long	.LBB0_61-.LJTI0_1
	.long	.LBB0_63-.LJTI0_1
	.long	.LBB0_65-.LJTI0_1
	.long	.LBB0_67-.LJTI0_1
	.long	.LBB0_69-.LJTI0_1
	.long	.LBB0_71-.LJTI0_1
	.long	.LBB0_73-.LJTI0_1
	.long	.LBB0_254-.LJTI0_1
	.long	.LBB0_76-.LJTI0_1
	.long	.LBB0_78-.LJTI0_1
	.long	.LBB0_80-.LJTI0_1
	.long	.LBB0_84-.LJTI0_1
	.long	.LBB0_86-.LJTI0_1
	.long	.LBB0_90-.LJTI0_1
	.long	.LBB0_94-.LJTI0_1
	.long	.LBB0_98-.LJTI0_1
	.long	.LBB0_100-.LJTI0_1
	.long	.LBB0_104-.LJTI0_1
	.long	.LBB0_108-.LJTI0_1
	.long	.LBB0_112-.LJTI0_1
	.long	.LBB0_116-.LJTI0_1
	.long	.LBB0_120-.LJTI0_1
	.long	.LBB0_124-.LJTI0_1
	.long	.LBB0_128-.LJTI0_1
	.long	.LBB0_130-.LJTI0_1
	.long	.LBB0_134-.LJTI0_1
	.long	.LBB0_138-.LJTI0_1
	.long	.LBB0_142-.LJTI0_1
	.long	.LBB0_146-.LJTI0_1
	.long	.LBB0_150-.LJTI0_1
	.long	.LBB0_154-.LJTI0_1
	.long	.LBB0_158-.LJTI0_1
	.long	.LBB0_162-.LJTI0_1
	.long	.LBB0_166-.LJTI0_1
	.long	.LBB0_170-.LJTI0_1
	.long	.LBB0_174-.LJTI0_1
	.long	.LBB0_178-.LJTI0_1
	.long	.LBB0_182-.LJTI0_1
	.long	.LBB0_186-.LJTI0_1
	.long	.LBB0_253-.LJTI0_1
	.long	.LBB0_75-.LJTI0_1
	.long	.LBB0_77-.LJTI0_1
	.long	.LBB0_79-.LJTI0_1
	.long	.LBB0_83-.LJTI0_1
	.long	.LBB0_85-.LJTI0_1
	.long	.LBB0_89-.LJTI0_1
	.long	.LBB0_93-.LJTI0_1
	.long	.LBB0_97-.LJTI0_1
	.long	.LBB0_99-.LJTI0_1
	.long	.LBB0_103-.LJTI0_1
	.long	.LBB0_107-.LJTI0_1
	.long	.LBB0_111-.LJTI0_1
	.long	.LBB0_115-.LJTI0_1
	.long	.LBB0_119-.LJTI0_1
	.long	.LBB0_123-.LJTI0_1
	.long	.LBB0_127-.LJTI0_1
	.long	.LBB0_129-.LJTI0_1
	.long	.LBB0_133-.LJTI0_1
	.long	.LBB0_137-.LJTI0_1
	.long	.LBB0_141-.LJTI0_1
	.long	.LBB0_145-.LJTI0_1
	.long	.LBB0_149-.LJTI0_1
	.long	.LBB0_153-.LJTI0_1
	.long	.LBB0_157-.LJTI0_1
	.long	.LBB0_161-.LJTI0_1
	.long	.LBB0_165-.LJTI0_1
	.long	.LBB0_169-.LJTI0_1
	.long	.LBB0_173-.LJTI0_1
	.long	.LBB0_177-.LJTI0_1
	.long	.LBB0_181-.LJTI0_1
	.long	.LBB0_185-.LJTI0_1
	.long	.LBB0_252-.LJTI0_1
	.long	.LBB0_189-.LJTI0_1
	.long	.LBB0_191-.LJTI0_1
	.long	.LBB0_193-.LJTI0_1
	.long	.LBB0_195-.LJTI0_1
	.long	.LBB0_197-.LJTI0_1
	.long	.LBB0_199-.LJTI0_1
	.long	.LBB0_201-.LJTI0_1
	.long	.LBB0_203-.LJTI0_1
	.long	.LBB0_205-.LJTI0_1
	.long	.LBB0_207-.LJTI0_1
	.long	.LBB0_209-.LJTI0_1
	.long	.LBB0_211-.LJTI0_1
	.long	.LBB0_213-.LJTI0_1
	.long	.LBB0_215-.LJTI0_1
	.long	.LBB0_217-.LJTI0_1
	.long	.LBB0_219-.LJTI0_1
	.long	.LBB0_221-.LJTI0_1
	.long	.LBB0_223-.LJTI0_1
	.long	.LBB0_225-.LJTI0_1
	.long	.LBB0_227-.LJTI0_1
	.long	.LBB0_229-.LJTI0_1
	.long	.LBB0_231-.LJTI0_1
	.long	.LBB0_233-.LJTI0_1
	.long	.LBB0_235-.LJTI0_1
	.long	.LBB0_237-.LJTI0_1
	.long	.LBB0_239-.LJTI0_1
	.long	.LBB0_241-.LJTI0_1
	.long	.LBB0_243-.LJTI0_1
	.long	.LBB0_245-.LJTI0_1
	.long	.LBB0_247-.LJTI0_1
	.long	.LBB0_249-.LJTI0_1
	.long	.LBB0_251-.LJTI0_1
                                        # -- End function
