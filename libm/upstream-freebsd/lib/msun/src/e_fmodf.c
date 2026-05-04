/* e_fmodf.c -- float version of e_fmod.c.
 * Conversion to float by Ian Lance Taylor, Cygnus Support, ian@cygnus.com.
 */

/*
 * ====================================================
 * Copyright (C) 1993 by Sun Microsystems, Inc. All rights reserved.
 *
 * Developed at SunPro, a Sun Microsystems, Inc. business.
 * Permission to use, copy, modify, and distribute this
 * software is freely granted, provided that this notice
 * is preserved.
 * ====================================================
 */

/*
 * fmodf(x,y)
 * Return x mod y in exact arithmetic
 * Method: shift and subtract
 */

#include "math.h"
#include "math_private.h"

static const float one = 1.0, Zero[] = {0.0, -0.0,};

float
fmodf(float x, float y)
{
    uint32_t hx,hy,sx;
    // ---------------------------------------------
    // Extract raw 32-bit IEEE-754 words from x and y
    // ---------------------------------------------
    GET_FLOAT_WORD(hx, x);   // hx = bit-pattern(x)
    GET_FLOAT_WORD(hy, y);   // hy = bit-pattern(y)

    // Extract sign bit of x (bit 31)
    sx = hx & 0x80000000u;

    // Take absolute value of x by clearing sign bit
    hx ^= sx;

    // Take absolute value of y by clearing sign bit
    hy &= ~0x80000000u;

    // ----------------------------------------------------------
    // Special cases:
    // 1. y == 0 → invalid → return NaN
    // 2. x is NaN or Inf (hx >= 0x7f800000)
    // 3. y is NaN (hy > 0x7f800000)
    // ----------------------------------------------------------

    if (hx < hy)
    {
        /* If y is a NaN, return a NaN.  */
        if (hy > 0x7F800000u)
            return x * y;
        return x;
    }

    /* Common case where exponents are close: |x/y| < 2^9, x not inf/NaN
        and |x%y| not denormal.  */

    int ex = hx >> 23;
    int ey = hy >> 23;
    int exp_diff = ex - ey;

    if  (ey < ( 0x7F800000u >> 23) - 8
                && ey > 23
                && exp_diff <= 8)
        {
        uint32_t mx = (hx << 8) | 0x80000000u;
        uint32_t my = (hy << 8) | 0x80000000u;

        mx %= (my >> exp_diff);

        if (mx == 0)
        {
            SET_FLOAT_WORD (x,sx);
            return x;
        }

        int shift = __builtin_clz (mx);
        ex -= shift + 1;
        mx <<= shift;
        mx = sx | (mx >> 8);
        SET_FLOAT_WORD(x, (mx + ((uint32_t)ex << 23)));
        return x;
    }

    if (hy == 0 || hx >= 0x7F800000u)
    {
        /* If x is a NaN, return a NaN.  */
        if (hx > 0x7F800000u)
            return x * y;

        /* If x is an infinity or y is zero, return a NaN and set EDOM.  */
        return ((x * y) / (x * y));                                                //Not setting EDOM
    }
    /* Special case, both x and y are denormal.  */
    if (ex == 0)
    {
        //return asfloat (sx | hx % hy);
        SET_FLOAT_WORD(x, (sx | hx % hy));
        return x;
    }

    /* Extract normalized mantissas - hx is not denormal and hy != 0.  */
    uint32_t mx = (hx & 0x007FFFFFu) | (0x007FFFFFu + 1);
    uint32_t my = (hy & 0x007FFFFFu) | (0x007FFFFFu + 1);
    int lead_zeros_my = 8;

    ey--;
    /* Special case for denormal y.  */
    if (ey < 0)
    {
      my = hy;
      ey = 0;
      exp_diff--;
      lead_zeros_my = __builtin_clz (my);
    }

    int tail_zeros_my = __builtin_ctz (my);
    int sides_zeroes = lead_zeros_my + tail_zeros_my;

    int right_shift = exp_diff < tail_zeros_my ? exp_diff : tail_zeros_my;
    my >>= right_shift;
    exp_diff -= right_shift;
    ey += right_shift;

    int left_shift = exp_diff < 8 ? exp_diff : 8;
    mx <<= left_shift;
    exp_diff -= left_shift;

    mx %= my;

    if (mx == 0)
    {
        SET_FLOAT_WORD(x,sx);
        return x;
    }

    if (exp_diff == 0)
    {
        return make_float (mx, ey, sx);
    }

    /* Multiplication with the inverse is faster than repeated modulo.  */
    uint32_t inv_hy = UINT32_MAX / my;
    while (exp_diff > sides_zeroes) {
        exp_diff -= sides_zeroes;
        uint32_t hd = (mx * inv_hy) >> (32 - sides_zeroes);
        mx <<= sides_zeroes;
        mx -= hd * my;
        while  (mx > my){
            mx -= my;
        }
    }
    uint32_t hd = (mx * inv_hy) >> (32 - exp_diff);
    mx <<= exp_diff;
    mx -= hd * my;
    while (mx > my)
        mx -= my;
    return make_float (mx, ey, sx);
}
