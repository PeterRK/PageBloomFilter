// Copyright (c) 2023, Ruan Kunliang.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

#ifndef DISABLE_SIMD_OPTIMIZE
#include <immintrin.h>
#endif
#include "hash.h"

namespace pbf {

union V128X {
	V128 v;
	uint32_t w[4];
	uint16_t s[8];
#ifndef DISABLE_SIMD_OPTIMIZE
	__m128i m;
#endif
};

static FORCE_INLINE uint32_t Rot32(uint32_t x, unsigned k) noexcept {
	return (x >> k) | (x << (32U - k));
}

static FORCE_INLINE uint32_t PageHash(V128X t) noexcept {
	return Rot32(t.w[0], 6) ^ Rot32(t.w[1], 4) ^ Rot32(t.w[2], 2) ^ t.w[3];
}

template <unsigned N>
static FORCE_INLINE bool Test(const uint8_t* page, unsigned page_level, V128X t) noexcept {
#if defined(__AVX2__) && !defined(DISABLE_SIMD_OPTIMIZE)
	if (N > 4) {
		__m256i hole = _mm256_set1_epi32(-1);
		if (N == 7) {
			hole = _mm256_set_epi32(0, -1, -1, -1, -1, -1, -1, -1);
		} else if (N == 6) {
			hole = _mm256_set_epi32(0, -1, -1, -1, 0, -1, -1, -1);
		} else if (N == 5) {
			hole = _mm256_set_epi32(0, 0, -1, -1, 0, -1, -1, -1);
		}
		__m256i mask = _mm256_set1_epi32((1U << (page_level+3U)) - 1);
		__m256i idx = _mm256_and_si256(_mm256_setr_m128i(t.m, _mm_srli_epi32(t.m, 16)), mask);
		__m256i rec = _mm256_mask_i32gather_epi32(_mm256_set1_epi32(-1), reinterpret_cast<const int*>(page),
																							_mm256_srli_epi32(idx, 5U), hole, 4);
		__m256i bit = _mm256_sllv_epi32(_mm256_set1_epi32(1), _mm256_and_si256(idx, _mm256_set1_epi32(31)));
		return _mm256_testz_si256(_mm256_andnot_si256(rec, bit), bit);
	}
#endif
	uint16_t mask = (1U << (page_level+3U)) - 1U;
	for (unsigned i = 0; i < N; i++) {
		uint16_t idx = t.s[i] & mask;
		uint8_t bit = 1U << (idx&7);
		if ((page[idx>>3U] & bit) == 0) {
			return false;
		}
	}
	return true;
}

template <unsigned N>
static FORCE_INLINE bool Set(uint8_t* page, unsigned page_level, V128X t) noexcept {
	uint8_t hit = 1U;
	uint16_t mask = (1U << (page_level+3U)) - 1U;
	for (unsigned i = 0; i < N; i++) {
		uint16_t idx = t.s[i] & mask;
		uint8_t bit = 1U << (idx&7);
		hit &= page[idx>>3U] >> (idx&7);
		page[idx>>3U] |= bit;
	}
	return !hit;
}

} //pbf