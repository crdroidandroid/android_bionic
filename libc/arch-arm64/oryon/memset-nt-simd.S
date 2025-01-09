/*
 * Copyright (C) 2024 The Android Open Source Project
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

/* Assumptions:
 *
 * ARMv8-a, AArch64
 * Unaligned accesses
 *
 */
#include <private/bionic_asm.h>

#define A_q	q0
#define A_s	s0
#define dstin	x0
#define val	x1
#define valw	w1
#define count	x2
#define dst	x3
#define off	x3
#define dstend	x4
#define dstend2	x5
#define zva_len	x6
#define zva_len_w	w6
#define zva_bits	x7
#define tmp1	x8
#define tmp1w	w8
#define tmp2	x9
#define tmp2w	w9
#define tmp3	x10
#define tmp3w	w10
/* More than SMALL_BUF_SIZE using stnp (non-temporal) instructions,
 * best to refer the L1 cache size */
#define SMALL_BUF_SIZE	98304 /*96K*/
#define MEDIUM_THR	512

ENTRY(__memset_aarch64_nt_simd)

	add	dstend, dstin, count
	dup	v0.16B, valw

	/* Handle 0..15 bytes. */
	cmp	count, 16
	b.lo	.Lset_tiny

	/* Handle #MEDIUM_THR+..bytes. */
	cmp	count, #MEDIUM_THR
	b.hi	.Lset_long

	/* Handle 64..MEDIUM_THR bytes.*/
	cmp	count, 64
	b.hs	.Lset_medium

	/* Handle 16..63 bytes. */
	mov	off, 16
	and	off, off, count, lsr 1
	sub	dstend2, dstend, off
	str	A_q, [dstin]
	str	A_q, [dstin, off]
	str	A_q, [dstend2, -16]
	str	A_q, [dstend, -16]
	ret

	.p2align 4
.Lset_tiny:
	cmp	count, 4
	b.lo	.tiny_4B
	lsr	off, count, 3
	sub	dstend2, dstend, off, lsl 2
	str	A_s, [dstin]
	str	A_s, [dstin, off, lsl 2]
	str	A_s, [dstend2, -4]
	str	A_s, [dstend, -4]
	ret
.tiny_4B:
	cbz	count, .tiny_end
	lsr	off, count, 1
	strb	valw, [dstin]
	strb	valw, [dstin, off]
	strb	valw, [dstend, -1]
.tiny_end:
	ret

.Lset_128:
	stp	A_q, A_q, [dstin]
	stp	A_q, A_q, [dstin, 32]
	stp	A_q, A_q, [dstend, -64]
	stp	A_q, A_q, [dstend, -32]
	ret

.Lset_medium:
	cmp	count, 128
	b.ls	.Lset_128
	sub	count, count, 64
	neg	tmp1, dstin
	ands	tmp1, tmp1, 15
	add	dst, dstin, tmp1
	b.eq	.Lmedium_loop
	str	A_q, [dstin]
	sub	count, count, tmp1
.Lmedium_loop:
	stp	A_q, A_q, [dst]
	stp	A_q, A_q, [dst, 32]
	add	dst, dst, 64
	subs	count, count, 64
	b.hi	.Lmedium_loop
	stp	A_q, A_q, [dstend, -64]
	stp	A_q, A_q, [dstend, -32]
	ret

	.p2align 6
.Lset_long:
	and	valw, valw, 255
	cbnz	valw, .Lwithout_zva

.Lzero_mem_with_zva:

#ifdef ZVA_COMMON_CHECK
	/* common zva */
.Lzva_common:
	mov	dst, dstin

	mrs	tmp2, dczid_el0
	tbnz	tmp2, #4, .Lwithout_zva
	/* zva_len = 4* 2^(tmp2w&0xF) */
	and	zva_len_w, tmp2w, #15
	mov	tmp3w, #4
	lsl	zva_len_w, tmp3w, zva_len_w
	sub	zva_bits, zva_len, #1
	neg	tmp1, dstin
	and	tmp1, tmp1, zva_bits
	sub	count, count, tmp1
	subs	count, count, zva_len
	b.lt	.Lwithout_zva
	cmp	tmp1, 0
	b.eq	.Lcommon_zva_loop
	sub	tmp2, tmp1, 64
1:
	str	A_q, [dst]
	str	A_q, [dst, 16]
	stp	A_q, A_q, [dst, 32]
	add	dst, dst, 64
	subs	tmp2, tmp2, 64
	b.ge	1b
	add	dst, dstin, tmp1
.Lcommon_zva_loop:
	dc	zva, dst
	add	dst, dst, zva_len
	subs	count, count, zva_len
	b.ge	.Lcommon_zva_loop
	adds	count, count, zva_len
	b.eq	.Lcommon_zva_end
2:
	sub	dstend, dstend, 32
	stp	A_q, A_q, [dstend]
	subs	count, count, 32
	b.ge	2b
.Lcommon_zva_end:
	ret
#else
	/* skip check for zva64 */
.Lzva_64:
	sub	count, count, 64
	neg	tmp1, dstin
	ands	tmp1, tmp1, 63
	add	dst, dstin, tmp1
	b.eq	.Lzva64_loop
	str	A_q, [dstin]
	str	A_q, [dstin, 16]
	stp	A_q, A_q, [dstin, 32]
	sub	count, count, tmp1
.Lzva64_loop:
	dc	zva, dst
	add	dst, dst, 64
	subs	count, count, 64
	b.ge	.Lzva64_loop
	adds	count, count, 64
	b.eq	.Lzva64_end
	stp	A_q, A_q, [dstend, -64]
	stp	A_q, A_q, [dstend, -32]
.Lzva64_end:
	ret
#endif

	.p2align 4
.Lwithout_zva:
	bic	dst, dstin, 15
	str	A_q, [dstin]
	str	A_q, [dst, 16]
	cmp	count, #SMALL_BUF_SIZE
	sub	count, dstend, dst
	sub	count, count, 64 + 32
	bgt	.Lgreater_than_buf
.Lless_than_buf:
	stp	A_q, A_q, [dst, 32]
	stp	A_q, A_q, [dst, 64]!
	subs	count, count, 64
	b.hi	.Lless_than_buf
	stp	A_q, A_q, [dstend, -64]
	stp	A_q, A_q, [dstend, -32]
	ret
.Lgreater_than_buf:
	stnp	A_q, A_q, [dst, 32]
	stnp	A_q, A_q, [dst, 64]
	add	dst, dst, #64
	subs	count, count, 64
	b.hi	.Lgreater_than_buf
	stnp	A_q, A_q, [dstend, -64]
	stnp	A_q, A_q, [dstend, -32]
	ret

END(__memset_aarch64_nt_simd)
