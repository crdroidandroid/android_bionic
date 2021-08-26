/*
 * Copyright (C) 2008 The Android Open Source Project
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
# %bb.0:
	pushl	%ebp
	pushl	%ebx
	pushl	%edi
	pushl	%esi
	movl	28(%esp), %ebx
	movl	24(%esp), %ecx
	movl	20(%esp), %eax
	calll	.L0$pb
.L0$pb:
	popl	%esi
.Ltmp0:
	addl	$_GLOBAL_OFFSET_TABLE_+(.Ltmp0-.L0$pb), %esi
	cmpl	$256, %ebx              # imm = 0x100
	ja	.LBB0_251
# %bb.1:
	leal	-1(%ebx), %edi
	cmpl	$255, %edi
	ja	.LBB0_270
# %bb.2:
	addl	.LJTI0_1@GOTOFF(%esi,%edi,4), %esi
	leal	(%eax,%ebx), %edx
	addl	%ebx, %ecx
	jmpl	*%esi
.LBB0_251:
	movl	%eax, %ebp
	vmovups	(%ecx), %ymm0
	movl	%ebx, %edi
	negl	%ebp
	andl	$31, %ebp
	subl	%ebp, %edi
	addl	%ebp, %ecx
	leal	(%eax,%ebp), %edx
	cmpl	$2097152, %edi          # imm = 0x200000
	vmovups	%ymm0, (%eax)
	ja	.LBB0_256
# %bb.252:
	cmpl	$256, %edi              # imm = 0x100
	jb	.LBB0_260
# %bb.253:
	subl	%ebp, %ebx
	.p2align	4, 0x90
.LBB0_254:                              # =>This Inner Loop Header: Depth=1
	vmovups	(%ecx), %ymm0
	vmovups	32(%ecx), %ymm1
	vmovups	64(%ecx), %ymm2
	vmovups	96(%ecx), %ymm3
	vmovups	128(%ecx), %ymm4
	vmovups	160(%ecx), %ymm5
	vmovups	192(%ecx), %ymm6
	vmovups	224(%ecx), %ymm7
	prefetchnta	512(%ecx)
	addl	$-256, %edi
	addl	$256, %ecx              # imm = 0x100
	vmovups	%ymm0, (%edx)
	vmovups	%ymm1, 32(%edx)
	vmovups	%ymm2, 64(%edx)
	vmovups	%ymm3, 96(%edx)
	vmovups	%ymm4, 128(%edx)
	vmovups	%ymm5, 160(%edx)
	vmovups	%ymm6, 192(%edx)
	vmovups	%ymm7, 224(%edx)
	addl	$256, %edx              # imm = 0x100
	cmpl	$255, %edi
	ja	.LBB0_254
# %bb.255:
	movzbl	%bl, %edi
	leal	-1(%edi), %ebx
	cmpl	$255, %ebx
	jbe	.LBB0_261
	jmp	.LBB0_270
.LBB0_256:
	prefetchnta	(%ecx)
	subl	%ebp, %ebx
	testb	$31, %cl
	je	.LBB0_257
	.p2align	4, 0x90
.LBB0_258:                              # =>This Inner Loop Header: Depth=1
	vmovups	(%ecx), %ymm0
	vmovups	32(%ecx), %ymm1
	vmovups	64(%ecx), %ymm2
	vmovups	96(%ecx), %ymm3
	vmovups	128(%ecx), %ymm4
	vmovups	160(%ecx), %ymm5
	vmovups	192(%ecx), %ymm6
	vmovups	224(%ecx), %ymm7
	prefetchnta	512(%ecx)
	addl	$-256, %edi
	addl	$256, %ecx              # imm = 0x100
	vmovntps	%ymm0, (%edx)
	vmovntps	%ymm1, 32(%edx)
	vmovntps	%ymm2, 64(%edx)
	vmovntps	%ymm3, 96(%edx)
	vmovntps	%ymm4, 128(%edx)
	vmovntps	%ymm5, 160(%edx)
	vmovntps	%ymm6, 192(%edx)
	vmovntps	%ymm7, 224(%edx)
	addl	$256, %edx              # imm = 0x100
	cmpl	$255, %edi
	ja	.LBB0_258
	jmp	.LBB0_259
	.p2align	4, 0x90
.LBB0_257:                              # =>This Inner Loop Header: Depth=1
	vmovaps	(%ecx), %ymm0
	vmovaps	32(%ecx), %ymm1
	vmovaps	64(%ecx), %ymm2
	vmovaps	96(%ecx), %ymm3
	vmovaps	128(%ecx), %ymm4
	vmovaps	160(%ecx), %ymm5
	vmovaps	192(%ecx), %ymm6
	vmovaps	224(%ecx), %ymm7
	prefetchnta	512(%ecx)
	addl	$-256, %edi
	addl	$256, %ecx              # imm = 0x100
	vmovntps	%ymm0, (%edx)
	vmovntps	%ymm1, 32(%edx)
	vmovntps	%ymm2, 64(%edx)
	vmovntps	%ymm3, 96(%edx)
	vmovntps	%ymm4, 128(%edx)
	vmovntps	%ymm5, 160(%edx)
	vmovntps	%ymm6, 192(%edx)
	vmovntps	%ymm7, 224(%edx)
	addl	$256, %edx              # imm = 0x100
	cmpl	$255, %edi
	ja	.LBB0_257
.LBB0_259:
	sfence
	movzbl	%bl, %edi
.LBB0_260:
	leal	-1(%edi), %ebx
	cmpl	$255, %ebx
	ja	.LBB0_270
.LBB0_261:
	addl	.LJTI0_0@GOTOFF(%esi,%ebx,4), %esi
	addl	%edi, %edx
	addl	%edi, %ecx
	jmpl	*%esi
.LBB0_11:
	vmovups	-131(%ecx), %ymm0
	vmovups	%ymm0, -131(%edx)
	vmovups	-99(%ecx), %ymm0
	vmovups	%ymm0, -99(%edx)
	vmovups	-67(%ecx), %ymm0
	vmovups	%ymm0, -67(%edx)
	vmovups	-35(%ecx), %ymm0
	vmovups	%ymm0, -35(%edx)
.LBB0_12:
	movzwl	-3(%ecx), %esi
	movw	%si, -3(%edx)
	jmp	.LBB0_6
.LBB0_17:
	vmovups	-133(%ecx), %ymm0
	vmovups	%ymm0, -133(%edx)
	vmovups	-101(%ecx), %ymm0
	vmovups	%ymm0, -101(%edx)
	vmovups	-69(%ecx), %ymm0
	vmovups	%ymm0, -69(%edx)
	vmovups	-37(%ecx), %ymm0
	vmovups	%ymm0, -37(%edx)
.LBB0_18:
	movl	-5(%ecx), %esi
	movl	%esi, -5(%edx)
	jmp	.LBB0_6
.LBB0_19:
	vmovups	-134(%ecx), %ymm0
	vmovups	%ymm0, -134(%edx)
	vmovups	-102(%ecx), %ymm0
	vmovups	%ymm0, -102(%edx)
	vmovups	-70(%ecx), %ymm0
	vmovups	%ymm0, -70(%edx)
	vmovups	-38(%ecx), %ymm0
	vmovups	%ymm0, -38(%edx)
.LBB0_20:
	movl	-6(%ecx), %esi
	movl	%esi, -6(%edx)
	jmp	.LBB0_10
.LBB0_21:
	vmovups	-135(%ecx), %ymm0
	vmovups	%ymm0, -135(%edx)
	vmovups	-103(%ecx), %ymm0
	vmovups	%ymm0, -103(%edx)
	vmovups	-71(%ecx), %ymm0
	vmovups	%ymm0, -71(%edx)
	vmovups	-39(%ecx), %ymm0
	vmovups	%ymm0, -39(%edx)
.LBB0_22:
	movl	-7(%ecx), %esi
	movl	%esi, -7(%edx)
	jmp	.LBB0_16
.LBB0_27:
	vmovups	-137(%ecx), %ymm0
	vmovups	%ymm0, -137(%edx)
	vmovups	-105(%ecx), %ymm0
	vmovups	%ymm0, -105(%edx)
	vmovups	-73(%ecx), %ymm0
	vmovups	%ymm0, -73(%edx)
	vmovups	-41(%ecx), %ymm0
	vmovups	%ymm0, -41(%edx)
.LBB0_28:
	vmovsd	-9(%ecx), %xmm0         # xmm0 = mem[0],zero
	vmovsd	%xmm0, -9(%edx)
	jmp	.LBB0_6
.LBB0_29:
	vmovups	-138(%ecx), %ymm0
	vmovups	%ymm0, -138(%edx)
	vmovups	-106(%ecx), %ymm0
	vmovups	%ymm0, -106(%edx)
	vmovups	-74(%ecx), %ymm0
	vmovups	%ymm0, -74(%edx)
	vmovups	-42(%ecx), %ymm0
	vmovups	%ymm0, -42(%edx)
.LBB0_30:
	vmovsd	-10(%ecx), %xmm0        # xmm0 = mem[0],zero
	vmovsd	%xmm0, -10(%edx)
	jmp	.LBB0_10
.LBB0_31:
	vmovups	-139(%ecx), %ymm0
	vmovups	%ymm0, -139(%edx)
	vmovups	-107(%ecx), %ymm0
	vmovups	%ymm0, -107(%edx)
	vmovups	-75(%ecx), %ymm0
	vmovups	%ymm0, -75(%edx)
	vmovups	-43(%ecx), %ymm0
	vmovups	%ymm0, -43(%edx)
.LBB0_32:
	vmovsd	-11(%ecx), %xmm0        # xmm0 = mem[0],zero
	vmovsd	%xmm0, -11(%edx)
	jmp	.LBB0_16
.LBB0_33:
	vmovups	-140(%ecx), %ymm0
	vmovups	%ymm0, -140(%edx)
	vmovups	-108(%ecx), %ymm0
	vmovups	%ymm0, -108(%edx)
	vmovups	-76(%ecx), %ymm0
	vmovups	%ymm0, -76(%edx)
	vmovups	-44(%ecx), %ymm0
	vmovups	%ymm0, -44(%edx)
.LBB0_34:
	vmovsd	-12(%ecx), %xmm0        # xmm0 = mem[0],zero
	vmovsd	%xmm0, -12(%edx)
	jmp	.LBB0_16
.LBB0_35:
	vmovups	-141(%ecx), %ymm0
	vmovups	%ymm0, -141(%edx)
	vmovups	-109(%ecx), %ymm0
	vmovups	%ymm0, -109(%edx)
	vmovups	-77(%ecx), %ymm0
	vmovups	%ymm0, -77(%edx)
	vmovups	-45(%ecx), %ymm0
	vmovups	%ymm0, -45(%edx)
.LBB0_36:
	vmovsd	-13(%ecx), %xmm0        # xmm0 = mem[0],zero
	vmovsd	%xmm0, -13(%edx)
	jmp	.LBB0_26
.LBB0_37:
	vmovups	-142(%ecx), %ymm0
	vmovups	%ymm0, -142(%edx)
	vmovups	-110(%ecx), %ymm0
	vmovups	%ymm0, -110(%edx)
	vmovups	-78(%ecx), %ymm0
	vmovups	%ymm0, -78(%edx)
	vmovups	-46(%ecx), %ymm0
	vmovups	%ymm0, -46(%edx)
.LBB0_38:
	vmovsd	-14(%ecx), %xmm0        # xmm0 = mem[0],zero
	vmovsd	%xmm0, -14(%edx)
	jmp	.LBB0_26
.LBB0_39:
	vmovups	-143(%ecx), %ymm0
	vmovups	%ymm0, -143(%edx)
	vmovups	-111(%ecx), %ymm0
	vmovups	%ymm0, -111(%edx)
	vmovups	-79(%ecx), %ymm0
	vmovups	%ymm0, -79(%edx)
	vmovups	-47(%ecx), %ymm0
	vmovups	%ymm0, -47(%edx)
.LBB0_40:
	vmovsd	-15(%ecx), %xmm0        # xmm0 = mem[0],zero
	vmovsd	%xmm0, -15(%edx)
	jmp	.LBB0_26
.LBB0_45:
	vmovups	-145(%ecx), %ymm0
	vmovups	%ymm0, -145(%edx)
	vmovups	-113(%ecx), %ymm0
	vmovups	%ymm0, -113(%edx)
	vmovups	-81(%ecx), %ymm0
	vmovups	%ymm0, -81(%edx)
	vmovups	-49(%ecx), %ymm0
	vmovups	%ymm0, -49(%edx)
.LBB0_46:
	vmovups	-17(%ecx), %xmm0
	vmovups	%xmm0, -17(%edx)
	jmp	.LBB0_6
.LBB0_47:
	vmovups	-146(%ecx), %ymm0
	vmovups	%ymm0, -146(%edx)
	vmovups	-114(%ecx), %ymm0
	vmovups	%ymm0, -114(%edx)
	vmovups	-82(%ecx), %ymm0
	vmovups	%ymm0, -82(%edx)
	vmovups	-50(%ecx), %ymm0
	vmovups	%ymm0, -50(%edx)
.LBB0_48:
	vmovups	-18(%ecx), %xmm0
	vmovups	%xmm0, -18(%edx)
	jmp	.LBB0_10
.LBB0_49:
	vmovups	-147(%ecx), %ymm0
	vmovups	%ymm0, -147(%edx)
	vmovups	-115(%ecx), %ymm0
	vmovups	%ymm0, -115(%edx)
	vmovups	-83(%ecx), %ymm0
	vmovups	%ymm0, -83(%edx)
	vmovups	-51(%ecx), %ymm0
	vmovups	%ymm0, -51(%edx)
.LBB0_50:
	vmovups	-19(%ecx), %xmm0
	vmovups	%xmm0, -19(%edx)
	jmp	.LBB0_16
.LBB0_51:
	vmovups	-148(%ecx), %ymm0
	vmovups	%ymm0, -148(%edx)
	vmovups	-116(%ecx), %ymm0
	vmovups	%ymm0, -116(%edx)
	vmovups	-84(%ecx), %ymm0
	vmovups	%ymm0, -84(%edx)
	vmovups	-52(%ecx), %ymm0
	vmovups	%ymm0, -52(%edx)
.LBB0_52:
	vmovups	-20(%ecx), %xmm0
	vmovups	%xmm0, -20(%edx)
	jmp	.LBB0_16
.LBB0_53:
	vmovups	-149(%ecx), %ymm0
	vmovups	%ymm0, -149(%edx)
	vmovups	-117(%ecx), %ymm0
	vmovups	%ymm0, -117(%edx)
	vmovups	-85(%ecx), %ymm0
	vmovups	%ymm0, -85(%edx)
	vmovups	-53(%ecx), %ymm0
	vmovups	%ymm0, -53(%edx)
.LBB0_54:
	vmovups	-21(%ecx), %xmm0
	vmovups	%xmm0, -21(%edx)
	jmp	.LBB0_26
.LBB0_55:
	vmovups	-150(%ecx), %ymm0
	vmovups	%ymm0, -150(%edx)
	vmovups	-118(%ecx), %ymm0
	vmovups	%ymm0, -118(%edx)
	vmovups	-86(%ecx), %ymm0
	vmovups	%ymm0, -86(%edx)
	vmovups	-54(%ecx), %ymm0
	vmovups	%ymm0, -54(%edx)
.LBB0_56:
	vmovups	-22(%ecx), %xmm0
	vmovups	%xmm0, -22(%edx)
	jmp	.LBB0_26
.LBB0_57:
	vmovups	-151(%ecx), %ymm0
	vmovups	%ymm0, -151(%edx)
	vmovups	-119(%ecx), %ymm0
	vmovups	%ymm0, -119(%edx)
	vmovups	-87(%ecx), %ymm0
	vmovups	%ymm0, -87(%edx)
	vmovups	-55(%ecx), %ymm0
	vmovups	%ymm0, -55(%edx)
.LBB0_58:
	vmovups	-23(%ecx), %xmm0
	vmovups	%xmm0, -23(%edx)
	jmp	.LBB0_26
.LBB0_59:
	vmovups	-152(%ecx), %ymm0
	vmovups	%ymm0, -152(%edx)
	vmovups	-120(%ecx), %ymm0
	vmovups	%ymm0, -120(%edx)
	vmovups	-88(%ecx), %ymm0
	vmovups	%ymm0, -88(%edx)
	vmovups	-56(%ecx), %ymm0
	vmovups	%ymm0, -56(%edx)
.LBB0_60:
	vmovups	-24(%ecx), %xmm0
	vmovups	%xmm0, -24(%edx)
	jmp	.LBB0_26
.LBB0_61:
	vmovups	-153(%ecx), %ymm0
	vmovups	%ymm0, -153(%edx)
	vmovups	-121(%ecx), %ymm0
	vmovups	%ymm0, -121(%edx)
	vmovups	-89(%ecx), %ymm0
	vmovups	%ymm0, -89(%edx)
	vmovups	-57(%ecx), %ymm0
	vmovups	%ymm0, -57(%edx)
.LBB0_62:
	vmovups	-25(%ecx), %xmm0
	vmovups	%xmm0, -25(%edx)
	jmp	.LBB0_44
.LBB0_63:
	vmovups	-154(%ecx), %ymm0
	vmovups	%ymm0, -154(%edx)
	vmovups	-122(%ecx), %ymm0
	vmovups	%ymm0, -122(%edx)
	vmovups	-90(%ecx), %ymm0
	vmovups	%ymm0, -90(%edx)
	vmovups	-58(%ecx), %ymm0
	vmovups	%ymm0, -58(%edx)
.LBB0_64:
	vmovups	-26(%ecx), %xmm0
	vmovups	%xmm0, -26(%edx)
	jmp	.LBB0_44
.LBB0_65:
	vmovups	-155(%ecx), %ymm0
	vmovups	%ymm0, -155(%edx)
	vmovups	-123(%ecx), %ymm0
	vmovups	%ymm0, -123(%edx)
	vmovups	-91(%ecx), %ymm0
	vmovups	%ymm0, -91(%edx)
	vmovups	-59(%ecx), %ymm0
	vmovups	%ymm0, -59(%edx)
.LBB0_66:
	vmovups	-27(%ecx), %xmm0
	vmovups	%xmm0, -27(%edx)
	jmp	.LBB0_44
.LBB0_67:
	vmovups	-156(%ecx), %ymm0
	vmovups	%ymm0, -156(%edx)
	vmovups	-124(%ecx), %ymm0
	vmovups	%ymm0, -124(%edx)
	vmovups	-92(%ecx), %ymm0
	vmovups	%ymm0, -92(%edx)
	vmovups	-60(%ecx), %ymm0
	vmovups	%ymm0, -60(%edx)
.LBB0_68:
	vmovups	-28(%ecx), %xmm0
	vmovups	%xmm0, -28(%edx)
	jmp	.LBB0_44
.LBB0_69:
	vmovups	-157(%ecx), %ymm0
	vmovups	%ymm0, -157(%edx)
	vmovups	-125(%ecx), %ymm0
	vmovups	%ymm0, -125(%edx)
	vmovups	-93(%ecx), %ymm0
	vmovups	%ymm0, -93(%edx)
	vmovups	-61(%ecx), %ymm0
	vmovups	%ymm0, -61(%edx)
.LBB0_70:
	vmovups	-29(%ecx), %xmm0
	vmovups	%xmm0, -29(%edx)
	jmp	.LBB0_44
.LBB0_71:
	vmovups	-158(%ecx), %ymm0
	vmovups	%ymm0, -158(%edx)
	vmovups	-126(%ecx), %ymm0
	vmovups	%ymm0, -126(%edx)
	vmovups	-94(%ecx), %ymm0
	vmovups	%ymm0, -94(%edx)
	vmovups	-62(%ecx), %ymm0
	vmovups	%ymm0, -62(%edx)
.LBB0_72:
	vmovups	-30(%ecx), %xmm0
	vmovups	%xmm0, -30(%edx)
	jmp	.LBB0_44
.LBB0_73:
	vmovups	-159(%ecx), %ymm0
	vmovups	%ymm0, -159(%edx)
	vmovups	-127(%ecx), %ymm0
	vmovups	%ymm0, -127(%edx)
	vmovups	-95(%ecx), %ymm0
	vmovups	%ymm0, -95(%edx)
	vmovups	-63(%ecx), %ymm0
	vmovups	%ymm0, -63(%edx)
.LBB0_74:
	vmovups	-31(%ecx), %xmm0
	vmovups	%xmm0, -31(%edx)
	jmp	.LBB0_44
.LBB0_75:
	vmovups	-193(%ecx), %ymm0
	vmovups	%ymm0, -193(%edx)
.LBB0_76:
	vmovups	-161(%ecx), %ymm0
	vmovups	%ymm0, -161(%edx)
.LBB0_3:
	vmovups	-129(%ecx), %ymm0
	vmovups	%ymm0, -129(%edx)
	vmovups	-97(%ecx), %ymm0
	vmovups	%ymm0, -97(%edx)
.LBB0_4:
	vmovups	-65(%ecx), %ymm0
	vmovups	%ymm0, -65(%edx)
.LBB0_5:
	vmovups	-33(%ecx), %ymm0
	vmovups	%ymm0, -33(%edx)
.LBB0_6:
	movb	-1(%ecx), %cl
	movb	%cl, -1(%edx)
	jmp	.LBB0_270
.LBB0_77:
	vmovups	-194(%ecx), %ymm0
	vmovups	%ymm0, -194(%edx)
.LBB0_78:
	vmovups	-162(%ecx), %ymm0
	vmovups	%ymm0, -162(%edx)
.LBB0_7:
	vmovups	-130(%ecx), %ymm0
	vmovups	%ymm0, -130(%edx)
	vmovups	-98(%ecx), %ymm0
	vmovups	%ymm0, -98(%edx)
.LBB0_8:
	vmovups	-66(%ecx), %ymm0
	vmovups	%ymm0, -66(%edx)
.LBB0_9:
	vmovups	-34(%ecx), %ymm0
	vmovups	%ymm0, -34(%edx)
.LBB0_10:
	movzwl	-2(%ecx), %ecx
	movw	%cx, -2(%edx)
	jmp	.LBB0_270
.LBB0_79:
	vmovups	-195(%ecx), %ymm0
	vmovups	%ymm0, -195(%edx)
.LBB0_80:
	vmovups	-163(%ecx), %ymm0
	vmovups	%ymm0, -163(%edx)
	vmovups	-131(%ecx), %ymm0
	vmovups	%ymm0, -131(%edx)
	vmovups	-99(%ecx), %ymm0
	vmovups	%ymm0, -99(%edx)
.LBB0_81:
	vmovups	-67(%ecx), %ymm0
	vmovups	%ymm0, -67(%edx)
.LBB0_82:
	vmovups	-35(%ecx), %ymm0
	vmovups	%ymm0, -35(%edx)
	jmp	.LBB0_16
.LBB0_83:
	vmovups	-196(%ecx), %ymm0
	vmovups	%ymm0, -196(%edx)
.LBB0_84:
	vmovups	-164(%ecx), %ymm0
	vmovups	%ymm0, -164(%edx)
.LBB0_13:
	vmovups	-132(%ecx), %ymm0
	vmovups	%ymm0, -132(%edx)
	vmovups	-100(%ecx), %ymm0
	vmovups	%ymm0, -100(%edx)
.LBB0_14:
	vmovups	-68(%ecx), %ymm0
	vmovups	%ymm0, -68(%edx)
.LBB0_15:
	vmovups	-36(%ecx), %ymm0
	vmovups	%ymm0, -36(%edx)
.LBB0_16:
	movl	-4(%ecx), %ecx
	movl	%ecx, -4(%edx)
	jmp	.LBB0_270
.LBB0_85:
	vmovups	-197(%ecx), %ymm0
	vmovups	%ymm0, -197(%edx)
.LBB0_86:
	vmovups	-165(%ecx), %ymm0
	vmovups	%ymm0, -165(%edx)
	vmovups	-133(%ecx), %ymm0
	vmovups	%ymm0, -133(%edx)
	vmovups	-101(%ecx), %ymm0
	vmovups	%ymm0, -101(%edx)
.LBB0_87:
	vmovups	-69(%ecx), %ymm0
	vmovups	%ymm0, -69(%edx)
.LBB0_88:
	vmovups	-37(%ecx), %ymm0
	vmovups	%ymm0, -37(%edx)
	jmp	.LBB0_26
.LBB0_89:
	vmovups	-198(%ecx), %ymm0
	vmovups	%ymm0, -198(%edx)
.LBB0_90:
	vmovups	-166(%ecx), %ymm0
	vmovups	%ymm0, -166(%edx)
	vmovups	-134(%ecx), %ymm0
	vmovups	%ymm0, -134(%edx)
	vmovups	-102(%ecx), %ymm0
	vmovups	%ymm0, -102(%edx)
.LBB0_91:
	vmovups	-70(%ecx), %ymm0
	vmovups	%ymm0, -70(%edx)
.LBB0_92:
	vmovups	-38(%ecx), %ymm0
	vmovups	%ymm0, -38(%edx)
	jmp	.LBB0_26
.LBB0_93:
	vmovups	-199(%ecx), %ymm0
	vmovups	%ymm0, -199(%edx)
.LBB0_94:
	vmovups	-167(%ecx), %ymm0
	vmovups	%ymm0, -167(%edx)
	vmovups	-135(%ecx), %ymm0
	vmovups	%ymm0, -135(%edx)
	vmovups	-103(%ecx), %ymm0
	vmovups	%ymm0, -103(%edx)
.LBB0_95:
	vmovups	-71(%ecx), %ymm0
	vmovups	%ymm0, -71(%edx)
.LBB0_96:
	vmovups	-39(%ecx), %ymm0
	vmovups	%ymm0, -39(%edx)
	jmp	.LBB0_26
.LBB0_97:
	vmovups	-200(%ecx), %ymm0
	vmovups	%ymm0, -200(%edx)
.LBB0_98:
	vmovups	-168(%ecx), %ymm0
	vmovups	%ymm0, -168(%edx)
.LBB0_23:
	vmovups	-136(%ecx), %ymm0
	vmovups	%ymm0, -136(%edx)
	vmovups	-104(%ecx), %ymm0
	vmovups	%ymm0, -104(%edx)
.LBB0_24:
	vmovups	-72(%ecx), %ymm0
	vmovups	%ymm0, -72(%edx)
.LBB0_25:
	vmovups	-40(%ecx), %ymm0
	vmovups	%ymm0, -40(%edx)
.LBB0_26:
	vmovsd	-8(%ecx), %xmm0         # xmm0 = mem[0],zero
	vmovsd	%xmm0, -8(%edx)
	jmp	.LBB0_270
.LBB0_99:
	vmovups	-201(%ecx), %ymm0
	vmovups	%ymm0, -201(%edx)
.LBB0_100:
	vmovups	-169(%ecx), %ymm0
	vmovups	%ymm0, -169(%edx)
	vmovups	-137(%ecx), %ymm0
	vmovups	%ymm0, -137(%edx)
	vmovups	-105(%ecx), %ymm0
	vmovups	%ymm0, -105(%edx)
.LBB0_101:
	vmovups	-73(%ecx), %ymm0
	vmovups	%ymm0, -73(%edx)
.LBB0_102:
	vmovups	-41(%ecx), %ymm0
	vmovups	%ymm0, -41(%edx)
	jmp	.LBB0_44
.LBB0_103:
	vmovups	-202(%ecx), %ymm0
	vmovups	%ymm0, -202(%edx)
.LBB0_104:
	vmovups	-170(%ecx), %ymm0
	vmovups	%ymm0, -170(%edx)
	vmovups	-138(%ecx), %ymm0
	vmovups	%ymm0, -138(%edx)
	vmovups	-106(%ecx), %ymm0
	vmovups	%ymm0, -106(%edx)
.LBB0_105:
	vmovups	-74(%ecx), %ymm0
	vmovups	%ymm0, -74(%edx)
.LBB0_106:
	vmovups	-42(%ecx), %ymm0
	vmovups	%ymm0, -42(%edx)
	jmp	.LBB0_44
.LBB0_107:
	vmovups	-203(%ecx), %ymm0
	vmovups	%ymm0, -203(%edx)
.LBB0_108:
	vmovups	-171(%ecx), %ymm0
	vmovups	%ymm0, -171(%edx)
	vmovups	-139(%ecx), %ymm0
	vmovups	%ymm0, -139(%edx)
	vmovups	-107(%ecx), %ymm0
	vmovups	%ymm0, -107(%edx)
.LBB0_109:
	vmovups	-75(%ecx), %ymm0
	vmovups	%ymm0, -75(%edx)
.LBB0_110:
	vmovups	-43(%ecx), %ymm0
	vmovups	%ymm0, -43(%edx)
	jmp	.LBB0_44
.LBB0_111:
	vmovups	-204(%ecx), %ymm0
	vmovups	%ymm0, -204(%edx)
.LBB0_112:
	vmovups	-172(%ecx), %ymm0
	vmovups	%ymm0, -172(%edx)
	vmovups	-140(%ecx), %ymm0
	vmovups	%ymm0, -140(%edx)
	vmovups	-108(%ecx), %ymm0
	vmovups	%ymm0, -108(%edx)
.LBB0_113:
	vmovups	-76(%ecx), %ymm0
	vmovups	%ymm0, -76(%edx)
.LBB0_114:
	vmovups	-44(%ecx), %ymm0
	vmovups	%ymm0, -44(%edx)
	jmp	.LBB0_44
.LBB0_115:
	vmovups	-205(%ecx), %ymm0
	vmovups	%ymm0, -205(%edx)
.LBB0_116:
	vmovups	-173(%ecx), %ymm0
	vmovups	%ymm0, -173(%edx)
	vmovups	-141(%ecx), %ymm0
	vmovups	%ymm0, -141(%edx)
	vmovups	-109(%ecx), %ymm0
	vmovups	%ymm0, -109(%edx)
.LBB0_117:
	vmovups	-77(%ecx), %ymm0
	vmovups	%ymm0, -77(%edx)
.LBB0_118:
	vmovups	-45(%ecx), %ymm0
	vmovups	%ymm0, -45(%edx)
	jmp	.LBB0_44
.LBB0_119:
	vmovups	-206(%ecx), %ymm0
	vmovups	%ymm0, -206(%edx)
.LBB0_120:
	vmovups	-174(%ecx), %ymm0
	vmovups	%ymm0, -174(%edx)
	vmovups	-142(%ecx), %ymm0
	vmovups	%ymm0, -142(%edx)
	vmovups	-110(%ecx), %ymm0
	vmovups	%ymm0, -110(%edx)
.LBB0_121:
	vmovups	-78(%ecx), %ymm0
	vmovups	%ymm0, -78(%edx)
.LBB0_122:
	vmovups	-46(%ecx), %ymm0
	vmovups	%ymm0, -46(%edx)
	jmp	.LBB0_44
.LBB0_123:
	vmovups	-207(%ecx), %ymm0
	vmovups	%ymm0, -207(%edx)
.LBB0_124:
	vmovups	-175(%ecx), %ymm0
	vmovups	%ymm0, -175(%edx)
	vmovups	-143(%ecx), %ymm0
	vmovups	%ymm0, -143(%edx)
	vmovups	-111(%ecx), %ymm0
	vmovups	%ymm0, -111(%edx)
.LBB0_125:
	vmovups	-79(%ecx), %ymm0
	vmovups	%ymm0, -79(%edx)
.LBB0_126:
	vmovups	-47(%ecx), %ymm0
	vmovups	%ymm0, -47(%edx)
	jmp	.LBB0_44
.LBB0_127:
	vmovups	-208(%ecx), %ymm0
	vmovups	%ymm0, -208(%edx)
.LBB0_128:
	vmovups	-176(%ecx), %ymm0
	vmovups	%ymm0, -176(%edx)
.LBB0_41:
	vmovups	-144(%ecx), %ymm0
	vmovups	%ymm0, -144(%edx)
	vmovups	-112(%ecx), %ymm0
	vmovups	%ymm0, -112(%edx)
.LBB0_42:
	vmovups	-80(%ecx), %ymm0
	vmovups	%ymm0, -80(%edx)
.LBB0_43:
	vmovups	-48(%ecx), %ymm0
	vmovups	%ymm0, -48(%edx)
.LBB0_44:
	vmovups	-16(%ecx), %xmm0
	vmovups	%xmm0, -16(%edx)
	jmp	.LBB0_270
.LBB0_129:
	vmovups	-209(%ecx), %ymm0
	vmovups	%ymm0, -209(%edx)
.LBB0_130:
	vmovups	-177(%ecx), %ymm0
	vmovups	%ymm0, -177(%edx)
	vmovups	-145(%ecx), %ymm0
	vmovups	%ymm0, -145(%edx)
	vmovups	-113(%ecx), %ymm0
	vmovups	%ymm0, -113(%edx)
.LBB0_131:
	vmovups	-81(%ecx), %ymm0
	vmovups	%ymm0, -81(%edx)
.LBB0_132:
	vmovups	-49(%ecx), %ymm0
	vmovups	%ymm0, -49(%edx)
	jmp	.LBB0_269
.LBB0_133:
	vmovups	-210(%ecx), %ymm0
	vmovups	%ymm0, -210(%edx)
.LBB0_134:
	vmovups	-178(%ecx), %ymm0
	vmovups	%ymm0, -178(%edx)
	vmovups	-146(%ecx), %ymm0
	vmovups	%ymm0, -146(%edx)
	vmovups	-114(%ecx), %ymm0
	vmovups	%ymm0, -114(%edx)
.LBB0_135:
	vmovups	-82(%ecx), %ymm0
	vmovups	%ymm0, -82(%edx)
.LBB0_136:
	vmovups	-50(%ecx), %ymm0
	vmovups	%ymm0, -50(%edx)
	jmp	.LBB0_269
.LBB0_137:
	vmovups	-211(%ecx), %ymm0
	vmovups	%ymm0, -211(%edx)
.LBB0_138:
	vmovups	-179(%ecx), %ymm0
	vmovups	%ymm0, -179(%edx)
	vmovups	-147(%ecx), %ymm0
	vmovups	%ymm0, -147(%edx)
	vmovups	-115(%ecx), %ymm0
	vmovups	%ymm0, -115(%edx)
.LBB0_139:
	vmovups	-83(%ecx), %ymm0
	vmovups	%ymm0, -83(%edx)
.LBB0_140:
	vmovups	-51(%ecx), %ymm0
	vmovups	%ymm0, -51(%edx)
	jmp	.LBB0_269
.LBB0_141:
	vmovups	-212(%ecx), %ymm0
	vmovups	%ymm0, -212(%edx)
.LBB0_142:
	vmovups	-180(%ecx), %ymm0
	vmovups	%ymm0, -180(%edx)
	vmovups	-148(%ecx), %ymm0
	vmovups	%ymm0, -148(%edx)
	vmovups	-116(%ecx), %ymm0
	vmovups	%ymm0, -116(%edx)
.LBB0_143:
	vmovups	-84(%ecx), %ymm0
	vmovups	%ymm0, -84(%edx)
.LBB0_144:
	vmovups	-52(%ecx), %ymm0
	vmovups	%ymm0, -52(%edx)
	jmp	.LBB0_269
.LBB0_145:
	vmovups	-213(%ecx), %ymm0
	vmovups	%ymm0, -213(%edx)
.LBB0_146:
	vmovups	-181(%ecx), %ymm0
	vmovups	%ymm0, -181(%edx)
	vmovups	-149(%ecx), %ymm0
	vmovups	%ymm0, -149(%edx)
	vmovups	-117(%ecx), %ymm0
	vmovups	%ymm0, -117(%edx)
.LBB0_147:
	vmovups	-85(%ecx), %ymm0
	vmovups	%ymm0, -85(%edx)
.LBB0_148:
	vmovups	-53(%ecx), %ymm0
	vmovups	%ymm0, -53(%edx)
	jmp	.LBB0_269
.LBB0_149:
	vmovups	-214(%ecx), %ymm0
	vmovups	%ymm0, -214(%edx)
.LBB0_150:
	vmovups	-182(%ecx), %ymm0
	vmovups	%ymm0, -182(%edx)
	vmovups	-150(%ecx), %ymm0
	vmovups	%ymm0, -150(%edx)
	vmovups	-118(%ecx), %ymm0
	vmovups	%ymm0, -118(%edx)
.LBB0_151:
	vmovups	-86(%ecx), %ymm0
	vmovups	%ymm0, -86(%edx)
.LBB0_152:
	vmovups	-54(%ecx), %ymm0
	vmovups	%ymm0, -54(%edx)
	jmp	.LBB0_269
.LBB0_153:
	vmovups	-215(%ecx), %ymm0
	vmovups	%ymm0, -215(%edx)
.LBB0_154:
	vmovups	-183(%ecx), %ymm0
	vmovups	%ymm0, -183(%edx)
	vmovups	-151(%ecx), %ymm0
	vmovups	%ymm0, -151(%edx)
	vmovups	-119(%ecx), %ymm0
	vmovups	%ymm0, -119(%edx)
.LBB0_155:
	vmovups	-87(%ecx), %ymm0
	vmovups	%ymm0, -87(%edx)
.LBB0_156:
	vmovups	-55(%ecx), %ymm0
	vmovups	%ymm0, -55(%edx)
	jmp	.LBB0_269
.LBB0_157:
	vmovups	-216(%ecx), %ymm0
	vmovups	%ymm0, -216(%edx)
.LBB0_158:
	vmovups	-184(%ecx), %ymm0
	vmovups	%ymm0, -184(%edx)
	vmovups	-152(%ecx), %ymm0
	vmovups	%ymm0, -152(%edx)
	vmovups	-120(%ecx), %ymm0
	vmovups	%ymm0, -120(%edx)
.LBB0_159:
	vmovups	-88(%ecx), %ymm0
	vmovups	%ymm0, -88(%edx)
.LBB0_160:
	vmovups	-56(%ecx), %ymm0
	vmovups	%ymm0, -56(%edx)
	jmp	.LBB0_269
.LBB0_161:
	vmovups	-217(%ecx), %ymm0
	vmovups	%ymm0, -217(%edx)
.LBB0_162:
	vmovups	-185(%ecx), %ymm0
	vmovups	%ymm0, -185(%edx)
	vmovups	-153(%ecx), %ymm0
	vmovups	%ymm0, -153(%edx)
	vmovups	-121(%ecx), %ymm0
	vmovups	%ymm0, -121(%edx)
.LBB0_163:
	vmovups	-89(%ecx), %ymm0
	vmovups	%ymm0, -89(%edx)
.LBB0_164:
	vmovups	-57(%ecx), %ymm0
	vmovups	%ymm0, -57(%edx)
	jmp	.LBB0_269
.LBB0_165:
	vmovups	-218(%ecx), %ymm0
	vmovups	%ymm0, -218(%edx)
.LBB0_166:
	vmovups	-186(%ecx), %ymm0
	vmovups	%ymm0, -186(%edx)
	vmovups	-154(%ecx), %ymm0
	vmovups	%ymm0, -154(%edx)
	vmovups	-122(%ecx), %ymm0
	vmovups	%ymm0, -122(%edx)
.LBB0_167:
	vmovups	-90(%ecx), %ymm0
	vmovups	%ymm0, -90(%edx)
.LBB0_168:
	vmovups	-58(%ecx), %ymm0
	vmovups	%ymm0, -58(%edx)
	jmp	.LBB0_269
.LBB0_169:
	vmovups	-219(%ecx), %ymm0
	vmovups	%ymm0, -219(%edx)
.LBB0_170:
	vmovups	-187(%ecx), %ymm0
	vmovups	%ymm0, -187(%edx)
	vmovups	-155(%ecx), %ymm0
	vmovups	%ymm0, -155(%edx)
	vmovups	-123(%ecx), %ymm0
	vmovups	%ymm0, -123(%edx)
.LBB0_171:
	vmovups	-91(%ecx), %ymm0
	vmovups	%ymm0, -91(%edx)
.LBB0_172:
	vmovups	-59(%ecx), %ymm0
	vmovups	%ymm0, -59(%edx)
	jmp	.LBB0_269
.LBB0_173:
	vmovups	-220(%ecx), %ymm0
	vmovups	%ymm0, -220(%edx)
.LBB0_174:
	vmovups	-188(%ecx), %ymm0
	vmovups	%ymm0, -188(%edx)
	vmovups	-156(%ecx), %ymm0
	vmovups	%ymm0, -156(%edx)
	vmovups	-124(%ecx), %ymm0
	vmovups	%ymm0, -124(%edx)
.LBB0_175:
	vmovups	-92(%ecx), %ymm0
	vmovups	%ymm0, -92(%edx)
.LBB0_176:
	vmovups	-60(%ecx), %ymm0
	vmovups	%ymm0, -60(%edx)
	jmp	.LBB0_269
.LBB0_177:
	vmovups	-221(%ecx), %ymm0
	vmovups	%ymm0, -221(%edx)
.LBB0_178:
	vmovups	-189(%ecx), %ymm0
	vmovups	%ymm0, -189(%edx)
	vmovups	-157(%ecx), %ymm0
	vmovups	%ymm0, -157(%edx)
	vmovups	-125(%ecx), %ymm0
	vmovups	%ymm0, -125(%edx)
.LBB0_179:
	vmovups	-93(%ecx), %ymm0
	vmovups	%ymm0, -93(%edx)
.LBB0_180:
	vmovups	-61(%ecx), %ymm0
	vmovups	%ymm0, -61(%edx)
	jmp	.LBB0_269
.LBB0_181:
	vmovups	-222(%ecx), %ymm0
	vmovups	%ymm0, -222(%edx)
.LBB0_182:
	vmovups	-190(%ecx), %ymm0
	vmovups	%ymm0, -190(%edx)
	vmovups	-158(%ecx), %ymm0
	vmovups	%ymm0, -158(%edx)
	vmovups	-126(%ecx), %ymm0
	vmovups	%ymm0, -126(%edx)
.LBB0_183:
	vmovups	-94(%ecx), %ymm0
	vmovups	%ymm0, -94(%edx)
.LBB0_184:
	vmovups	-62(%ecx), %ymm0
	vmovups	%ymm0, -62(%edx)
	jmp	.LBB0_269
.LBB0_185:
	vmovups	-223(%ecx), %ymm0
	vmovups	%ymm0, -223(%edx)
.LBB0_186:
	vmovups	-191(%ecx), %ymm0
	vmovups	%ymm0, -191(%edx)
	vmovups	-159(%ecx), %ymm0
	vmovups	%ymm0, -159(%edx)
	vmovups	-127(%ecx), %ymm0
	vmovups	%ymm0, -127(%edx)
.LBB0_187:
	vmovups	-95(%ecx), %ymm0
	vmovups	%ymm0, -95(%edx)
.LBB0_188:
	vmovups	-63(%ecx), %ymm0
	vmovups	%ymm0, -63(%edx)
	jmp	.LBB0_269
.LBB0_189:
	vmovups	-225(%ecx), %ymm0
	vmovups	%ymm0, -225(%edx)
	vmovups	-193(%ecx), %ymm0
	vmovups	%ymm0, -193(%edx)
	vmovups	-161(%ecx), %ymm0
	vmovups	%ymm0, -161(%edx)
	vmovups	-129(%ecx), %ymm0
	vmovups	%ymm0, -129(%edx)
.LBB0_190:
	vmovups	-97(%ecx), %ymm0
	vmovups	%ymm0, -97(%edx)
	vmovups	-65(%ecx), %ymm0
	vmovups	%ymm0, -65(%edx)
	jmp	.LBB0_268
.LBB0_191:
	vmovups	-226(%ecx), %ymm0
	vmovups	%ymm0, -226(%edx)
	vmovups	-194(%ecx), %ymm0
	vmovups	%ymm0, -194(%edx)
	vmovups	-162(%ecx), %ymm0
	vmovups	%ymm0, -162(%edx)
	vmovups	-130(%ecx), %ymm0
	vmovups	%ymm0, -130(%edx)
.LBB0_192:
	vmovups	-98(%ecx), %ymm0
	vmovups	%ymm0, -98(%edx)
	vmovups	-66(%ecx), %ymm0
	vmovups	%ymm0, -66(%edx)
	jmp	.LBB0_268
.LBB0_193:
	vmovups	-227(%ecx), %ymm0
	vmovups	%ymm0, -227(%edx)
	vmovups	-195(%ecx), %ymm0
	vmovups	%ymm0, -195(%edx)
	vmovups	-163(%ecx), %ymm0
	vmovups	%ymm0, -163(%edx)
	vmovups	-131(%ecx), %ymm0
	vmovups	%ymm0, -131(%edx)
.LBB0_194:
	vmovups	-99(%ecx), %ymm0
	vmovups	%ymm0, -99(%edx)
	vmovups	-67(%ecx), %ymm0
	vmovups	%ymm0, -67(%edx)
	jmp	.LBB0_268
.LBB0_195:
	vmovups	-228(%ecx), %ymm0
	vmovups	%ymm0, -228(%edx)
	vmovups	-196(%ecx), %ymm0
	vmovups	%ymm0, -196(%edx)
	vmovups	-164(%ecx), %ymm0
	vmovups	%ymm0, -164(%edx)
	vmovups	-132(%ecx), %ymm0
	vmovups	%ymm0, -132(%edx)
.LBB0_196:
	vmovups	-100(%ecx), %ymm0
	vmovups	%ymm0, -100(%edx)
	vmovups	-68(%ecx), %ymm0
	vmovups	%ymm0, -68(%edx)
	jmp	.LBB0_268
.LBB0_197:
	vmovups	-229(%ecx), %ymm0
	vmovups	%ymm0, -229(%edx)
	vmovups	-197(%ecx), %ymm0
	vmovups	%ymm0, -197(%edx)
	vmovups	-165(%ecx), %ymm0
	vmovups	%ymm0, -165(%edx)
	vmovups	-133(%ecx), %ymm0
	vmovups	%ymm0, -133(%edx)
.LBB0_198:
	vmovups	-101(%ecx), %ymm0
	vmovups	%ymm0, -101(%edx)
	vmovups	-69(%ecx), %ymm0
	vmovups	%ymm0, -69(%edx)
	jmp	.LBB0_268
.LBB0_199:
	vmovups	-230(%ecx), %ymm0
	vmovups	%ymm0, -230(%edx)
	vmovups	-198(%ecx), %ymm0
	vmovups	%ymm0, -198(%edx)
	vmovups	-166(%ecx), %ymm0
	vmovups	%ymm0, -166(%edx)
	vmovups	-134(%ecx), %ymm0
	vmovups	%ymm0, -134(%edx)
.LBB0_200:
	vmovups	-102(%ecx), %ymm0
	vmovups	%ymm0, -102(%edx)
	vmovups	-70(%ecx), %ymm0
	vmovups	%ymm0, -70(%edx)
	jmp	.LBB0_268
.LBB0_201:
	vmovups	-231(%ecx), %ymm0
	vmovups	%ymm0, -231(%edx)
	vmovups	-199(%ecx), %ymm0
	vmovups	%ymm0, -199(%edx)
	vmovups	-167(%ecx), %ymm0
	vmovups	%ymm0, -167(%edx)
	vmovups	-135(%ecx), %ymm0
	vmovups	%ymm0, -135(%edx)
.LBB0_202:
	vmovups	-103(%ecx), %ymm0
	vmovups	%ymm0, -103(%edx)
	vmovups	-71(%ecx), %ymm0
	vmovups	%ymm0, -71(%edx)
	jmp	.LBB0_268
.LBB0_203:
	vmovups	-232(%ecx), %ymm0
	vmovups	%ymm0, -232(%edx)
	vmovups	-200(%ecx), %ymm0
	vmovups	%ymm0, -200(%edx)
	vmovups	-168(%ecx), %ymm0
	vmovups	%ymm0, -168(%edx)
	vmovups	-136(%ecx), %ymm0
	vmovups	%ymm0, -136(%edx)
.LBB0_204:
	vmovups	-104(%ecx), %ymm0
	vmovups	%ymm0, -104(%edx)
	vmovups	-72(%ecx), %ymm0
	vmovups	%ymm0, -72(%edx)
	jmp	.LBB0_268
.LBB0_205:
	vmovups	-233(%ecx), %ymm0
	vmovups	%ymm0, -233(%edx)
	vmovups	-201(%ecx), %ymm0
	vmovups	%ymm0, -201(%edx)
	vmovups	-169(%ecx), %ymm0
	vmovups	%ymm0, -169(%edx)
	vmovups	-137(%ecx), %ymm0
	vmovups	%ymm0, -137(%edx)
.LBB0_206:
	vmovups	-105(%ecx), %ymm0
	vmovups	%ymm0, -105(%edx)
	vmovups	-73(%ecx), %ymm0
	vmovups	%ymm0, -73(%edx)
	jmp	.LBB0_268
.LBB0_207:
	vmovups	-234(%ecx), %ymm0
	vmovups	%ymm0, -234(%edx)
	vmovups	-202(%ecx), %ymm0
	vmovups	%ymm0, -202(%edx)
	vmovups	-170(%ecx), %ymm0
	vmovups	%ymm0, -170(%edx)
	vmovups	-138(%ecx), %ymm0
	vmovups	%ymm0, -138(%edx)
.LBB0_208:
	vmovups	-106(%ecx), %ymm0
	vmovups	%ymm0, -106(%edx)
	vmovups	-74(%ecx), %ymm0
	vmovups	%ymm0, -74(%edx)
	jmp	.LBB0_268
.LBB0_209:
	vmovups	-235(%ecx), %ymm0
	vmovups	%ymm0, -235(%edx)
	vmovups	-203(%ecx), %ymm0
	vmovups	%ymm0, -203(%edx)
	vmovups	-171(%ecx), %ymm0
	vmovups	%ymm0, -171(%edx)
	vmovups	-139(%ecx), %ymm0
	vmovups	%ymm0, -139(%edx)
.LBB0_210:
	vmovups	-107(%ecx), %ymm0
	vmovups	%ymm0, -107(%edx)
	vmovups	-75(%ecx), %ymm0
	vmovups	%ymm0, -75(%edx)
	jmp	.LBB0_268
.LBB0_211:
	vmovups	-236(%ecx), %ymm0
	vmovups	%ymm0, -236(%edx)
	vmovups	-204(%ecx), %ymm0
	vmovups	%ymm0, -204(%edx)
	vmovups	-172(%ecx), %ymm0
	vmovups	%ymm0, -172(%edx)
	vmovups	-140(%ecx), %ymm0
	vmovups	%ymm0, -140(%edx)
.LBB0_212:
	vmovups	-108(%ecx), %ymm0
	vmovups	%ymm0, -108(%edx)
	vmovups	-76(%ecx), %ymm0
	vmovups	%ymm0, -76(%edx)
	jmp	.LBB0_268
.LBB0_213:
	vmovups	-237(%ecx), %ymm0
	vmovups	%ymm0, -237(%edx)
	vmovups	-205(%ecx), %ymm0
	vmovups	%ymm0, -205(%edx)
	vmovups	-173(%ecx), %ymm0
	vmovups	%ymm0, -173(%edx)
	vmovups	-141(%ecx), %ymm0
	vmovups	%ymm0, -141(%edx)
.LBB0_214:
	vmovups	-109(%ecx), %ymm0
	vmovups	%ymm0, -109(%edx)
	vmovups	-77(%ecx), %ymm0
	vmovups	%ymm0, -77(%edx)
	jmp	.LBB0_268
.LBB0_215:
	vmovups	-238(%ecx), %ymm0
	vmovups	%ymm0, -238(%edx)
	vmovups	-206(%ecx), %ymm0
	vmovups	%ymm0, -206(%edx)
	vmovups	-174(%ecx), %ymm0
	vmovups	%ymm0, -174(%edx)
	vmovups	-142(%ecx), %ymm0
	vmovups	%ymm0, -142(%edx)
.LBB0_216:
	vmovups	-110(%ecx), %ymm0
	vmovups	%ymm0, -110(%edx)
	vmovups	-78(%ecx), %ymm0
	vmovups	%ymm0, -78(%edx)
	jmp	.LBB0_268
.LBB0_217:
	vmovups	-239(%ecx), %ymm0
	vmovups	%ymm0, -239(%edx)
	vmovups	-207(%ecx), %ymm0
	vmovups	%ymm0, -207(%edx)
	vmovups	-175(%ecx), %ymm0
	vmovups	%ymm0, -175(%edx)
	vmovups	-143(%ecx), %ymm0
	vmovups	%ymm0, -143(%edx)
.LBB0_218:
	vmovups	-111(%ecx), %ymm0
	vmovups	%ymm0, -111(%edx)
	vmovups	-79(%ecx), %ymm0
	vmovups	%ymm0, -79(%edx)
	jmp	.LBB0_268
.LBB0_219:
	vmovups	-240(%ecx), %ymm0
	vmovups	%ymm0, -240(%edx)
	vmovups	-208(%ecx), %ymm0
	vmovups	%ymm0, -208(%edx)
	vmovups	-176(%ecx), %ymm0
	vmovups	%ymm0, -176(%edx)
	vmovups	-144(%ecx), %ymm0
	vmovups	%ymm0, -144(%edx)
.LBB0_220:
	vmovups	-112(%ecx), %ymm0
	vmovups	%ymm0, -112(%edx)
	vmovups	-80(%ecx), %ymm0
	vmovups	%ymm0, -80(%edx)
	jmp	.LBB0_268
.LBB0_221:
	vmovups	-241(%ecx), %ymm0
	vmovups	%ymm0, -241(%edx)
	vmovups	-209(%ecx), %ymm0
	vmovups	%ymm0, -209(%edx)
	vmovups	-177(%ecx), %ymm0
	vmovups	%ymm0, -177(%edx)
	vmovups	-145(%ecx), %ymm0
	vmovups	%ymm0, -145(%edx)
.LBB0_222:
	vmovups	-113(%ecx), %ymm0
	vmovups	%ymm0, -113(%edx)
	vmovups	-81(%ecx), %ymm0
	vmovups	%ymm0, -81(%edx)
	jmp	.LBB0_268
.LBB0_223:
	vmovups	-242(%ecx), %ymm0
	vmovups	%ymm0, -242(%edx)
	vmovups	-210(%ecx), %ymm0
	vmovups	%ymm0, -210(%edx)
	vmovups	-178(%ecx), %ymm0
	vmovups	%ymm0, -178(%edx)
	vmovups	-146(%ecx), %ymm0
	vmovups	%ymm0, -146(%edx)
.LBB0_224:
	vmovups	-114(%ecx), %ymm0
	vmovups	%ymm0, -114(%edx)
	vmovups	-82(%ecx), %ymm0
	vmovups	%ymm0, -82(%edx)
	jmp	.LBB0_268
.LBB0_225:
	vmovups	-243(%ecx), %ymm0
	vmovups	%ymm0, -243(%edx)
	vmovups	-211(%ecx), %ymm0
	vmovups	%ymm0, -211(%edx)
	vmovups	-179(%ecx), %ymm0
	vmovups	%ymm0, -179(%edx)
	vmovups	-147(%ecx), %ymm0
	vmovups	%ymm0, -147(%edx)
.LBB0_226:
	vmovups	-115(%ecx), %ymm0
	vmovups	%ymm0, -115(%edx)
	vmovups	-83(%ecx), %ymm0
	vmovups	%ymm0, -83(%edx)
	jmp	.LBB0_268
.LBB0_227:
	vmovups	-244(%ecx), %ymm0
	vmovups	%ymm0, -244(%edx)
	vmovups	-212(%ecx), %ymm0
	vmovups	%ymm0, -212(%edx)
	vmovups	-180(%ecx), %ymm0
	vmovups	%ymm0, -180(%edx)
	vmovups	-148(%ecx), %ymm0
	vmovups	%ymm0, -148(%edx)
.LBB0_228:
	vmovups	-116(%ecx), %ymm0
	vmovups	%ymm0, -116(%edx)
	vmovups	-84(%ecx), %ymm0
	vmovups	%ymm0, -84(%edx)
	jmp	.LBB0_268
.LBB0_229:
	vmovups	-245(%ecx), %ymm0
	vmovups	%ymm0, -245(%edx)
	vmovups	-213(%ecx), %ymm0
	vmovups	%ymm0, -213(%edx)
	vmovups	-181(%ecx), %ymm0
	vmovups	%ymm0, -181(%edx)
	vmovups	-149(%ecx), %ymm0
	vmovups	%ymm0, -149(%edx)
.LBB0_230:
	vmovups	-117(%ecx), %ymm0
	vmovups	%ymm0, -117(%edx)
	vmovups	-85(%ecx), %ymm0
	vmovups	%ymm0, -85(%edx)
	jmp	.LBB0_268
.LBB0_231:
	vmovups	-246(%ecx), %ymm0
	vmovups	%ymm0, -246(%edx)
	vmovups	-214(%ecx), %ymm0
	vmovups	%ymm0, -214(%edx)
	vmovups	-182(%ecx), %ymm0
	vmovups	%ymm0, -182(%edx)
	vmovups	-150(%ecx), %ymm0
	vmovups	%ymm0, -150(%edx)
.LBB0_232:
	vmovups	-118(%ecx), %ymm0
	vmovups	%ymm0, -118(%edx)
	vmovups	-86(%ecx), %ymm0
	vmovups	%ymm0, -86(%edx)
	jmp	.LBB0_268
.LBB0_233:
	vmovups	-247(%ecx), %ymm0
	vmovups	%ymm0, -247(%edx)
	vmovups	-215(%ecx), %ymm0
	vmovups	%ymm0, -215(%edx)
	vmovups	-183(%ecx), %ymm0
	vmovups	%ymm0, -183(%edx)
	vmovups	-151(%ecx), %ymm0
	vmovups	%ymm0, -151(%edx)
.LBB0_234:
	vmovups	-119(%ecx), %ymm0
	vmovups	%ymm0, -119(%edx)
	vmovups	-87(%ecx), %ymm0
	vmovups	%ymm0, -87(%edx)
	jmp	.LBB0_268
.LBB0_235:
	vmovups	-248(%ecx), %ymm0
	vmovups	%ymm0, -248(%edx)
	vmovups	-216(%ecx), %ymm0
	vmovups	%ymm0, -216(%edx)
	vmovups	-184(%ecx), %ymm0
	vmovups	%ymm0, -184(%edx)
	vmovups	-152(%ecx), %ymm0
	vmovups	%ymm0, -152(%edx)
.LBB0_236:
	vmovups	-120(%ecx), %ymm0
	vmovups	%ymm0, -120(%edx)
	vmovups	-88(%ecx), %ymm0
	vmovups	%ymm0, -88(%edx)
	jmp	.LBB0_268
.LBB0_237:
	vmovups	-249(%ecx), %ymm0
	vmovups	%ymm0, -249(%edx)
	vmovups	-217(%ecx), %ymm0
	vmovups	%ymm0, -217(%edx)
	vmovups	-185(%ecx), %ymm0
	vmovups	%ymm0, -185(%edx)
	vmovups	-153(%ecx), %ymm0
	vmovups	%ymm0, -153(%edx)
.LBB0_238:
	vmovups	-121(%ecx), %ymm0
	vmovups	%ymm0, -121(%edx)
	vmovups	-89(%ecx), %ymm0
	vmovups	%ymm0, -89(%edx)
	jmp	.LBB0_268
.LBB0_239:
	vmovups	-250(%ecx), %ymm0
	vmovups	%ymm0, -250(%edx)
	vmovups	-218(%ecx), %ymm0
	vmovups	%ymm0, -218(%edx)
	vmovups	-186(%ecx), %ymm0
	vmovups	%ymm0, -186(%edx)
	vmovups	-154(%ecx), %ymm0
	vmovups	%ymm0, -154(%edx)
.LBB0_240:
	vmovups	-122(%ecx), %ymm0
	vmovups	%ymm0, -122(%edx)
	vmovups	-90(%ecx), %ymm0
	vmovups	%ymm0, -90(%edx)
	jmp	.LBB0_268
.LBB0_241:
	vmovups	-251(%ecx), %ymm0
	vmovups	%ymm0, -251(%edx)
	vmovups	-219(%ecx), %ymm0
	vmovups	%ymm0, -219(%edx)
	vmovups	-187(%ecx), %ymm0
	vmovups	%ymm0, -187(%edx)
	vmovups	-155(%ecx), %ymm0
	vmovups	%ymm0, -155(%edx)
.LBB0_242:
	vmovups	-123(%ecx), %ymm0
	vmovups	%ymm0, -123(%edx)
	vmovups	-91(%ecx), %ymm0
	vmovups	%ymm0, -91(%edx)
	jmp	.LBB0_268
.LBB0_243:
	vmovups	-252(%ecx), %ymm0
	vmovups	%ymm0, -252(%edx)
	vmovups	-220(%ecx), %ymm0
	vmovups	%ymm0, -220(%edx)
	vmovups	-188(%ecx), %ymm0
	vmovups	%ymm0, -188(%edx)
	vmovups	-156(%ecx), %ymm0
	vmovups	%ymm0, -156(%edx)
.LBB0_244:
	vmovups	-124(%ecx), %ymm0
	vmovups	%ymm0, -124(%edx)
	vmovups	-92(%ecx), %ymm0
	vmovups	%ymm0, -92(%edx)
	jmp	.LBB0_268
.LBB0_245:
	vmovups	-253(%ecx), %ymm0
	vmovups	%ymm0, -253(%edx)
	vmovups	-221(%ecx), %ymm0
	vmovups	%ymm0, -221(%edx)
	vmovups	-189(%ecx), %ymm0
	vmovups	%ymm0, -189(%edx)
	vmovups	-157(%ecx), %ymm0
	vmovups	%ymm0, -157(%edx)
.LBB0_246:
	vmovups	-125(%ecx), %ymm0
	vmovups	%ymm0, -125(%edx)
	vmovups	-93(%ecx), %ymm0
	vmovups	%ymm0, -93(%edx)
	jmp	.LBB0_268
.LBB0_247:
	vmovups	-254(%ecx), %ymm0
	vmovups	%ymm0, -254(%edx)
	vmovups	-222(%ecx), %ymm0
	vmovups	%ymm0, -222(%edx)
	vmovups	-190(%ecx), %ymm0
	vmovups	%ymm0, -190(%edx)
	vmovups	-158(%ecx), %ymm0
	vmovups	%ymm0, -158(%edx)
.LBB0_248:
	vmovups	-126(%ecx), %ymm0
	vmovups	%ymm0, -126(%edx)
	vmovups	-94(%ecx), %ymm0
	vmovups	%ymm0, -94(%edx)
	jmp	.LBB0_268
.LBB0_249:
	vmovups	-255(%ecx), %ymm0
	vmovups	%ymm0, -255(%edx)
	vmovups	-223(%ecx), %ymm0
	vmovups	%ymm0, -223(%edx)
	vmovups	-191(%ecx), %ymm0
	vmovups	%ymm0, -191(%edx)
	vmovups	-159(%ecx), %ymm0
	vmovups	%ymm0, -159(%edx)
.LBB0_250:
	vmovups	-127(%ecx), %ymm0
	vmovups	%ymm0, -127(%edx)
	vmovups	-95(%ecx), %ymm0
	vmovups	%ymm0, -95(%edx)
	jmp	.LBB0_268
.LBB0_262:
	vmovups	-256(%ecx), %ymm0
	vmovups	%ymm0, -256(%edx)
.LBB0_263:
	vmovups	-224(%ecx), %ymm0
	vmovups	%ymm0, -224(%edx)
.LBB0_264:
	vmovups	-192(%ecx), %ymm0
	vmovups	%ymm0, -192(%edx)
.LBB0_265:
	vmovups	-160(%ecx), %ymm0
	vmovups	%ymm0, -160(%edx)
.LBB0_266:
	vmovups	-128(%ecx), %ymm0
	vmovups	%ymm0, -128(%edx)
.LBB0_267:
	vmovups	-96(%ecx), %ymm0
	vmovups	%ymm0, -96(%edx)
.LBB0_268:
	vmovups	-64(%ecx), %ymm0
	vmovups	%ymm0, -64(%edx)
.LBB0_269:
	vmovups	-32(%ecx), %ymm0
	vmovups	%ymm0, -32(%edx)
.LBB0_270:
	vzeroupper
	popl	%esi
	popl	%edi
	popl	%ebx
	popl	%ebp
	retl
END(memcpy_avx2)

/*.Lfunc_end0:
	.size	memcpy_avx2, .Lfunc_end0-memcpy_avx2
	.section	.rodata,"a",@progbits
	.p2align	2*/
.LJTI0_0:
	.long	.LBB0_6@GOTOFF
	.long	.LBB0_10@GOTOFF
	.long	.LBB0_12@GOTOFF
	.long	.LBB0_16@GOTOFF
	.long	.LBB0_18@GOTOFF
	.long	.LBB0_20@GOTOFF
	.long	.LBB0_22@GOTOFF
	.long	.LBB0_26@GOTOFF
	.long	.LBB0_28@GOTOFF
	.long	.LBB0_30@GOTOFF
	.long	.LBB0_32@GOTOFF
	.long	.LBB0_34@GOTOFF
	.long	.LBB0_36@GOTOFF
	.long	.LBB0_38@GOTOFF
	.long	.LBB0_40@GOTOFF
	.long	.LBB0_44@GOTOFF
	.long	.LBB0_46@GOTOFF
	.long	.LBB0_48@GOTOFF
	.long	.LBB0_50@GOTOFF
	.long	.LBB0_52@GOTOFF
	.long	.LBB0_54@GOTOFF
	.long	.LBB0_56@GOTOFF
	.long	.LBB0_58@GOTOFF
	.long	.LBB0_60@GOTOFF
	.long	.LBB0_62@GOTOFF
	.long	.LBB0_64@GOTOFF
	.long	.LBB0_66@GOTOFF
	.long	.LBB0_68@GOTOFF
	.long	.LBB0_70@GOTOFF
	.long	.LBB0_72@GOTOFF
	.long	.LBB0_74@GOTOFF
	.long	.LBB0_269@GOTOFF
	.long	.LBB0_5@GOTOFF
	.long	.LBB0_9@GOTOFF
	.long	.LBB0_82@GOTOFF
	.long	.LBB0_15@GOTOFF
	.long	.LBB0_88@GOTOFF
	.long	.LBB0_92@GOTOFF
	.long	.LBB0_96@GOTOFF
	.long	.LBB0_25@GOTOFF
	.long	.LBB0_102@GOTOFF
	.long	.LBB0_106@GOTOFF
	.long	.LBB0_110@GOTOFF
	.long	.LBB0_114@GOTOFF
	.long	.LBB0_118@GOTOFF
	.long	.LBB0_122@GOTOFF
	.long	.LBB0_126@GOTOFF
	.long	.LBB0_43@GOTOFF
	.long	.LBB0_132@GOTOFF
	.long	.LBB0_136@GOTOFF
	.long	.LBB0_140@GOTOFF
	.long	.LBB0_144@GOTOFF
	.long	.LBB0_148@GOTOFF
	.long	.LBB0_152@GOTOFF
	.long	.LBB0_156@GOTOFF
	.long	.LBB0_160@GOTOFF
	.long	.LBB0_164@GOTOFF
	.long	.LBB0_168@GOTOFF
	.long	.LBB0_172@GOTOFF
	.long	.LBB0_176@GOTOFF
	.long	.LBB0_180@GOTOFF
	.long	.LBB0_184@GOTOFF
	.long	.LBB0_188@GOTOFF
	.long	.LBB0_268@GOTOFF
	.long	.LBB0_4@GOTOFF
	.long	.LBB0_8@GOTOFF
	.long	.LBB0_81@GOTOFF
	.long	.LBB0_14@GOTOFF
	.long	.LBB0_87@GOTOFF
	.long	.LBB0_91@GOTOFF
	.long	.LBB0_95@GOTOFF
	.long	.LBB0_24@GOTOFF
	.long	.LBB0_101@GOTOFF
	.long	.LBB0_105@GOTOFF
	.long	.LBB0_109@GOTOFF
	.long	.LBB0_113@GOTOFF
	.long	.LBB0_117@GOTOFF
	.long	.LBB0_121@GOTOFF
	.long	.LBB0_125@GOTOFF
	.long	.LBB0_42@GOTOFF
	.long	.LBB0_131@GOTOFF
	.long	.LBB0_135@GOTOFF
	.long	.LBB0_139@GOTOFF
	.long	.LBB0_143@GOTOFF
	.long	.LBB0_147@GOTOFF
	.long	.LBB0_151@GOTOFF
	.long	.LBB0_155@GOTOFF
	.long	.LBB0_159@GOTOFF
	.long	.LBB0_163@GOTOFF
	.long	.LBB0_167@GOTOFF
	.long	.LBB0_171@GOTOFF
	.long	.LBB0_175@GOTOFF
	.long	.LBB0_179@GOTOFF
	.long	.LBB0_183@GOTOFF
	.long	.LBB0_187@GOTOFF
	.long	.LBB0_267@GOTOFF
	.long	.LBB0_190@GOTOFF
	.long	.LBB0_192@GOTOFF
	.long	.LBB0_194@GOTOFF
	.long	.LBB0_196@GOTOFF
	.long	.LBB0_198@GOTOFF
	.long	.LBB0_200@GOTOFF
	.long	.LBB0_202@GOTOFF
	.long	.LBB0_204@GOTOFF
	.long	.LBB0_206@GOTOFF
	.long	.LBB0_208@GOTOFF
	.long	.LBB0_210@GOTOFF
	.long	.LBB0_212@GOTOFF
	.long	.LBB0_214@GOTOFF
	.long	.LBB0_216@GOTOFF
	.long	.LBB0_218@GOTOFF
	.long	.LBB0_220@GOTOFF
	.long	.LBB0_222@GOTOFF
	.long	.LBB0_224@GOTOFF
	.long	.LBB0_226@GOTOFF
	.long	.LBB0_228@GOTOFF
	.long	.LBB0_230@GOTOFF
	.long	.LBB0_232@GOTOFF
	.long	.LBB0_234@GOTOFF
	.long	.LBB0_236@GOTOFF
	.long	.LBB0_238@GOTOFF
	.long	.LBB0_240@GOTOFF
	.long	.LBB0_242@GOTOFF
	.long	.LBB0_244@GOTOFF
	.long	.LBB0_246@GOTOFF
	.long	.LBB0_248@GOTOFF
	.long	.LBB0_250@GOTOFF
	.long	.LBB0_266@GOTOFF
	.long	.LBB0_3@GOTOFF
	.long	.LBB0_7@GOTOFF
	.long	.LBB0_11@GOTOFF
	.long	.LBB0_13@GOTOFF
	.long	.LBB0_17@GOTOFF
	.long	.LBB0_19@GOTOFF
	.long	.LBB0_21@GOTOFF
	.long	.LBB0_23@GOTOFF
	.long	.LBB0_27@GOTOFF
	.long	.LBB0_29@GOTOFF
	.long	.LBB0_31@GOTOFF
	.long	.LBB0_33@GOTOFF
	.long	.LBB0_35@GOTOFF
	.long	.LBB0_37@GOTOFF
	.long	.LBB0_39@GOTOFF
	.long	.LBB0_41@GOTOFF
	.long	.LBB0_45@GOTOFF
	.long	.LBB0_47@GOTOFF
	.long	.LBB0_49@GOTOFF
	.long	.LBB0_51@GOTOFF
	.long	.LBB0_53@GOTOFF
	.long	.LBB0_55@GOTOFF
	.long	.LBB0_57@GOTOFF
	.long	.LBB0_59@GOTOFF
	.long	.LBB0_61@GOTOFF
	.long	.LBB0_63@GOTOFF
	.long	.LBB0_65@GOTOFF
	.long	.LBB0_67@GOTOFF
	.long	.LBB0_69@GOTOFF
	.long	.LBB0_71@GOTOFF
	.long	.LBB0_73@GOTOFF
	.long	.LBB0_265@GOTOFF
	.long	.LBB0_76@GOTOFF
	.long	.LBB0_78@GOTOFF
	.long	.LBB0_80@GOTOFF
	.long	.LBB0_84@GOTOFF
	.long	.LBB0_86@GOTOFF
	.long	.LBB0_90@GOTOFF
	.long	.LBB0_94@GOTOFF
	.long	.LBB0_98@GOTOFF
	.long	.LBB0_100@GOTOFF
	.long	.LBB0_104@GOTOFF
	.long	.LBB0_108@GOTOFF
	.long	.LBB0_112@GOTOFF
	.long	.LBB0_116@GOTOFF
	.long	.LBB0_120@GOTOFF
	.long	.LBB0_124@GOTOFF
	.long	.LBB0_128@GOTOFF
	.long	.LBB0_130@GOTOFF
	.long	.LBB0_134@GOTOFF
	.long	.LBB0_138@GOTOFF
	.long	.LBB0_142@GOTOFF
	.long	.LBB0_146@GOTOFF
	.long	.LBB0_150@GOTOFF
	.long	.LBB0_154@GOTOFF
	.long	.LBB0_158@GOTOFF
	.long	.LBB0_162@GOTOFF
	.long	.LBB0_166@GOTOFF
	.long	.LBB0_170@GOTOFF
	.long	.LBB0_174@GOTOFF
	.long	.LBB0_178@GOTOFF
	.long	.LBB0_182@GOTOFF
	.long	.LBB0_186@GOTOFF
	.long	.LBB0_264@GOTOFF
	.long	.LBB0_75@GOTOFF
	.long	.LBB0_77@GOTOFF
	.long	.LBB0_79@GOTOFF
	.long	.LBB0_83@GOTOFF
	.long	.LBB0_85@GOTOFF
	.long	.LBB0_89@GOTOFF
	.long	.LBB0_93@GOTOFF
	.long	.LBB0_97@GOTOFF
	.long	.LBB0_99@GOTOFF
	.long	.LBB0_103@GOTOFF
	.long	.LBB0_107@GOTOFF
	.long	.LBB0_111@GOTOFF
	.long	.LBB0_115@GOTOFF
	.long	.LBB0_119@GOTOFF
	.long	.LBB0_123@GOTOFF
	.long	.LBB0_127@GOTOFF
	.long	.LBB0_129@GOTOFF
	.long	.LBB0_133@GOTOFF
	.long	.LBB0_137@GOTOFF
	.long	.LBB0_141@GOTOFF
	.long	.LBB0_145@GOTOFF
	.long	.LBB0_149@GOTOFF
	.long	.LBB0_153@GOTOFF
	.long	.LBB0_157@GOTOFF
	.long	.LBB0_161@GOTOFF
	.long	.LBB0_165@GOTOFF
	.long	.LBB0_169@GOTOFF
	.long	.LBB0_173@GOTOFF
	.long	.LBB0_177@GOTOFF
	.long	.LBB0_181@GOTOFF
	.long	.LBB0_185@GOTOFF
	.long	.LBB0_263@GOTOFF
	.long	.LBB0_189@GOTOFF
	.long	.LBB0_191@GOTOFF
	.long	.LBB0_193@GOTOFF
	.long	.LBB0_195@GOTOFF
	.long	.LBB0_197@GOTOFF
	.long	.LBB0_199@GOTOFF
	.long	.LBB0_201@GOTOFF
	.long	.LBB0_203@GOTOFF
	.long	.LBB0_205@GOTOFF
	.long	.LBB0_207@GOTOFF
	.long	.LBB0_209@GOTOFF
	.long	.LBB0_211@GOTOFF
	.long	.LBB0_213@GOTOFF
	.long	.LBB0_215@GOTOFF
	.long	.LBB0_217@GOTOFF
	.long	.LBB0_219@GOTOFF
	.long	.LBB0_221@GOTOFF
	.long	.LBB0_223@GOTOFF
	.long	.LBB0_225@GOTOFF
	.long	.LBB0_227@GOTOFF
	.long	.LBB0_229@GOTOFF
	.long	.LBB0_231@GOTOFF
	.long	.LBB0_233@GOTOFF
	.long	.LBB0_235@GOTOFF
	.long	.LBB0_237@GOTOFF
	.long	.LBB0_239@GOTOFF
	.long	.LBB0_241@GOTOFF
	.long	.LBB0_243@GOTOFF
	.long	.LBB0_245@GOTOFF
	.long	.LBB0_247@GOTOFF
	.long	.LBB0_249@GOTOFF
	.long	.LBB0_262@GOTOFF
.LJTI0_1:
	.long	.LBB0_6@GOTOFF
	.long	.LBB0_10@GOTOFF
	.long	.LBB0_12@GOTOFF
	.long	.LBB0_16@GOTOFF
	.long	.LBB0_18@GOTOFF
	.long	.LBB0_20@GOTOFF
	.long	.LBB0_22@GOTOFF
	.long	.LBB0_26@GOTOFF
	.long	.LBB0_28@GOTOFF
	.long	.LBB0_30@GOTOFF
	.long	.LBB0_32@GOTOFF
	.long	.LBB0_34@GOTOFF
	.long	.LBB0_36@GOTOFF
	.long	.LBB0_38@GOTOFF
	.long	.LBB0_40@GOTOFF
	.long	.LBB0_44@GOTOFF
	.long	.LBB0_46@GOTOFF
	.long	.LBB0_48@GOTOFF
	.long	.LBB0_50@GOTOFF
	.long	.LBB0_52@GOTOFF
	.long	.LBB0_54@GOTOFF
	.long	.LBB0_56@GOTOFF
	.long	.LBB0_58@GOTOFF
	.long	.LBB0_60@GOTOFF
	.long	.LBB0_62@GOTOFF
	.long	.LBB0_64@GOTOFF
	.long	.LBB0_66@GOTOFF
	.long	.LBB0_68@GOTOFF
	.long	.LBB0_70@GOTOFF
	.long	.LBB0_72@GOTOFF
	.long	.LBB0_74@GOTOFF
	.long	.LBB0_269@GOTOFF
	.long	.LBB0_5@GOTOFF
	.long	.LBB0_9@GOTOFF
	.long	.LBB0_82@GOTOFF
	.long	.LBB0_15@GOTOFF
	.long	.LBB0_88@GOTOFF
	.long	.LBB0_92@GOTOFF
	.long	.LBB0_96@GOTOFF
	.long	.LBB0_25@GOTOFF
	.long	.LBB0_102@GOTOFF
	.long	.LBB0_106@GOTOFF
	.long	.LBB0_110@GOTOFF
	.long	.LBB0_114@GOTOFF
	.long	.LBB0_118@GOTOFF
	.long	.LBB0_122@GOTOFF
	.long	.LBB0_126@GOTOFF
	.long	.LBB0_43@GOTOFF
	.long	.LBB0_132@GOTOFF
	.long	.LBB0_136@GOTOFF
	.long	.LBB0_140@GOTOFF
	.long	.LBB0_144@GOTOFF
	.long	.LBB0_148@GOTOFF
	.long	.LBB0_152@GOTOFF
	.long	.LBB0_156@GOTOFF
	.long	.LBB0_160@GOTOFF
	.long	.LBB0_164@GOTOFF
	.long	.LBB0_168@GOTOFF
	.long	.LBB0_172@GOTOFF
	.long	.LBB0_176@GOTOFF
	.long	.LBB0_180@GOTOFF
	.long	.LBB0_184@GOTOFF
	.long	.LBB0_188@GOTOFF
	.long	.LBB0_268@GOTOFF
	.long	.LBB0_4@GOTOFF
	.long	.LBB0_8@GOTOFF
	.long	.LBB0_81@GOTOFF
	.long	.LBB0_14@GOTOFF
	.long	.LBB0_87@GOTOFF
	.long	.LBB0_91@GOTOFF
	.long	.LBB0_95@GOTOFF
	.long	.LBB0_24@GOTOFF
	.long	.LBB0_101@GOTOFF
	.long	.LBB0_105@GOTOFF
	.long	.LBB0_109@GOTOFF
	.long	.LBB0_113@GOTOFF
	.long	.LBB0_117@GOTOFF
	.long	.LBB0_121@GOTOFF
	.long	.LBB0_125@GOTOFF
	.long	.LBB0_42@GOTOFF
	.long	.LBB0_131@GOTOFF
	.long	.LBB0_135@GOTOFF
	.long	.LBB0_139@GOTOFF
	.long	.LBB0_143@GOTOFF
	.long	.LBB0_147@GOTOFF
	.long	.LBB0_151@GOTOFF
	.long	.LBB0_155@GOTOFF
	.long	.LBB0_159@GOTOFF
	.long	.LBB0_163@GOTOFF
	.long	.LBB0_167@GOTOFF
	.long	.LBB0_171@GOTOFF
	.long	.LBB0_175@GOTOFF
	.long	.LBB0_179@GOTOFF
	.long	.LBB0_183@GOTOFF
	.long	.LBB0_187@GOTOFF
	.long	.LBB0_267@GOTOFF
	.long	.LBB0_190@GOTOFF
	.long	.LBB0_192@GOTOFF
	.long	.LBB0_194@GOTOFF
	.long	.LBB0_196@GOTOFF
	.long	.LBB0_198@GOTOFF
	.long	.LBB0_200@GOTOFF
	.long	.LBB0_202@GOTOFF
	.long	.LBB0_204@GOTOFF
	.long	.LBB0_206@GOTOFF
	.long	.LBB0_208@GOTOFF
	.long	.LBB0_210@GOTOFF
	.long	.LBB0_212@GOTOFF
	.long	.LBB0_214@GOTOFF
	.long	.LBB0_216@GOTOFF
	.long	.LBB0_218@GOTOFF
	.long	.LBB0_220@GOTOFF
	.long	.LBB0_222@GOTOFF
	.long	.LBB0_224@GOTOFF
	.long	.LBB0_226@GOTOFF
	.long	.LBB0_228@GOTOFF
	.long	.LBB0_230@GOTOFF
	.long	.LBB0_232@GOTOFF
	.long	.LBB0_234@GOTOFF
	.long	.LBB0_236@GOTOFF
	.long	.LBB0_238@GOTOFF
	.long	.LBB0_240@GOTOFF
	.long	.LBB0_242@GOTOFF
	.long	.LBB0_244@GOTOFF
	.long	.LBB0_246@GOTOFF
	.long	.LBB0_248@GOTOFF
	.long	.LBB0_250@GOTOFF
	.long	.LBB0_266@GOTOFF
	.long	.LBB0_3@GOTOFF
	.long	.LBB0_7@GOTOFF
	.long	.LBB0_11@GOTOFF
	.long	.LBB0_13@GOTOFF
	.long	.LBB0_17@GOTOFF
	.long	.LBB0_19@GOTOFF
	.long	.LBB0_21@GOTOFF
	.long	.LBB0_23@GOTOFF
	.long	.LBB0_27@GOTOFF
	.long	.LBB0_29@GOTOFF
	.long	.LBB0_31@GOTOFF
	.long	.LBB0_33@GOTOFF
	.long	.LBB0_35@GOTOFF
	.long	.LBB0_37@GOTOFF
	.long	.LBB0_39@GOTOFF
	.long	.LBB0_41@GOTOFF
	.long	.LBB0_45@GOTOFF
	.long	.LBB0_47@GOTOFF
	.long	.LBB0_49@GOTOFF
	.long	.LBB0_51@GOTOFF
	.long	.LBB0_53@GOTOFF
	.long	.LBB0_55@GOTOFF
	.long	.LBB0_57@GOTOFF
	.long	.LBB0_59@GOTOFF
	.long	.LBB0_61@GOTOFF
	.long	.LBB0_63@GOTOFF
	.long	.LBB0_65@GOTOFF
	.long	.LBB0_67@GOTOFF
	.long	.LBB0_69@GOTOFF
	.long	.LBB0_71@GOTOFF
	.long	.LBB0_73@GOTOFF
	.long	.LBB0_265@GOTOFF
	.long	.LBB0_76@GOTOFF
	.long	.LBB0_78@GOTOFF
	.long	.LBB0_80@GOTOFF
	.long	.LBB0_84@GOTOFF
	.long	.LBB0_86@GOTOFF
	.long	.LBB0_90@GOTOFF
	.long	.LBB0_94@GOTOFF
	.long	.LBB0_98@GOTOFF
	.long	.LBB0_100@GOTOFF
	.long	.LBB0_104@GOTOFF
	.long	.LBB0_108@GOTOFF
	.long	.LBB0_112@GOTOFF
	.long	.LBB0_116@GOTOFF
	.long	.LBB0_120@GOTOFF
	.long	.LBB0_124@GOTOFF
	.long	.LBB0_128@GOTOFF
	.long	.LBB0_130@GOTOFF
	.long	.LBB0_134@GOTOFF
	.long	.LBB0_138@GOTOFF
	.long	.LBB0_142@GOTOFF
	.long	.LBB0_146@GOTOFF
	.long	.LBB0_150@GOTOFF
	.long	.LBB0_154@GOTOFF
	.long	.LBB0_158@GOTOFF
	.long	.LBB0_162@GOTOFF
	.long	.LBB0_166@GOTOFF
	.long	.LBB0_170@GOTOFF
	.long	.LBB0_174@GOTOFF
	.long	.LBB0_178@GOTOFF
	.long	.LBB0_182@GOTOFF
	.long	.LBB0_186@GOTOFF
	.long	.LBB0_264@GOTOFF
	.long	.LBB0_75@GOTOFF
	.long	.LBB0_77@GOTOFF
	.long	.LBB0_79@GOTOFF
	.long	.LBB0_83@GOTOFF
	.long	.LBB0_85@GOTOFF
	.long	.LBB0_89@GOTOFF
	.long	.LBB0_93@GOTOFF
	.long	.LBB0_97@GOTOFF
	.long	.LBB0_99@GOTOFF
	.long	.LBB0_103@GOTOFF
	.long	.LBB0_107@GOTOFF
	.long	.LBB0_111@GOTOFF
	.long	.LBB0_115@GOTOFF
	.long	.LBB0_119@GOTOFF
	.long	.LBB0_123@GOTOFF
	.long	.LBB0_127@GOTOFF
	.long	.LBB0_129@GOTOFF
	.long	.LBB0_133@GOTOFF
	.long	.LBB0_137@GOTOFF
	.long	.LBB0_141@GOTOFF
	.long	.LBB0_145@GOTOFF
	.long	.LBB0_149@GOTOFF
	.long	.LBB0_153@GOTOFF
	.long	.LBB0_157@GOTOFF
	.long	.LBB0_161@GOTOFF
	.long	.LBB0_165@GOTOFF
	.long	.LBB0_169@GOTOFF
	.long	.LBB0_173@GOTOFF
	.long	.LBB0_177@GOTOFF
	.long	.LBB0_181@GOTOFF
	.long	.LBB0_185@GOTOFF
	.long	.LBB0_263@GOTOFF
	.long	.LBB0_189@GOTOFF
	.long	.LBB0_191@GOTOFF
	.long	.LBB0_193@GOTOFF
	.long	.LBB0_195@GOTOFF
	.long	.LBB0_197@GOTOFF
	.long	.LBB0_199@GOTOFF
	.long	.LBB0_201@GOTOFF
	.long	.LBB0_203@GOTOFF
	.long	.LBB0_205@GOTOFF
	.long	.LBB0_207@GOTOFF
	.long	.LBB0_209@GOTOFF
	.long	.LBB0_211@GOTOFF
	.long	.LBB0_213@GOTOFF
	.long	.LBB0_215@GOTOFF
	.long	.LBB0_217@GOTOFF
	.long	.LBB0_219@GOTOFF
	.long	.LBB0_221@GOTOFF
	.long	.LBB0_223@GOTOFF
	.long	.LBB0_225@GOTOFF
	.long	.LBB0_227@GOTOFF
	.long	.LBB0_229@GOTOFF
	.long	.LBB0_231@GOTOFF
	.long	.LBB0_233@GOTOFF
	.long	.LBB0_235@GOTOFF
	.long	.LBB0_237@GOTOFF
	.long	.LBB0_239@GOTOFF
	.long	.LBB0_241@GOTOFF
	.long	.LBB0_243@GOTOFF
	.long	.LBB0_245@GOTOFF
	.long	.LBB0_247@GOTOFF
	.long	.LBB0_249@GOTOFF
	.long	.LBB0_262@GOTOFF
                                        # -- End function
