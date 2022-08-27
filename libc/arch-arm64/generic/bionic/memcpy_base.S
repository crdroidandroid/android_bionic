#if defined (__ARM_NEON__) || defined (__aarch64__)
	#include "memcpy_simd.S"
#else
	#include "memcpy_standard.S"
#endif
