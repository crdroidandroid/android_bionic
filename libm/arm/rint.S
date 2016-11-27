/*
 * Copyright 2016, Paranoid Android
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#include <float.h>
#include <private/bionic_asm.h>

ENTRY(rint)
    vmov        d0, r0, r1
    vrintx.f64  d0, d0
    vmov        r0, r1, d0
    bx          lr
END(rint)

ENTRY(rintf)
    vmov        s0, r0
    vrintx.f32  s0, s0
    vmov        r0, s0
    bx          lr
END(rintf)

ALIAS_SYMBOL(rintl, rint);
