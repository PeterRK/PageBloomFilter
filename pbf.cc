// Copyright (c) 2023, Ruan Kunliang.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

#include <cstring>
#ifndef DISABLE_SIMD_OPTIMIZE
#include <immintrin.h>
#endif
#include "hash.h"
#include "pbf.h"

namespace pbf {

void _PageBloomFilter::init(unsigned page_level, unsigned page_num, size_t unique_cnt, const uint8_t* data) {
	m_page_level = page_level;
	m_page_num = page_num;
	auto space = std::make_unique<uint8_t[]>(data_size());
	if (data == nullptr) {
		m_unique_cnt = 0;
		memset(space.get(), 0, data_size());
	} else {
		m_unique_cnt = unique_cnt;
		memcpy(space.get(), data, data_size());
	}
	m_space = std::move(space);
}

void _PageBloomFilter::clear() noexcept {
	m_unique_cnt = 0;
	if (m_space != nullptr) {
		memset(m_space.get(), 0, data_size());
	}
}

union V128X {
	V128 v;
	uint32_t w[4];
	uint16_t s[8];
#ifndef DISABLE_SIMD_OPTIMIZE
	__m128i m;
#endif
};

static FORCE_INLINE uint32_t Rot32(uint32_t x, unsigned k) {
	return (x >> k) | (x << (32U - k));
}

static FORCE_INLINE uint32_t PageHash(V128X t) {
	return Rot32(t.w[0], 6) ^ Rot32(t.w[1], 4) ^ Rot32(t.w[2], 2) ^ t.w[3];
}

template <unsigned N>
bool PageBloomFilter<N>::test(const uint8_t* data, unsigned len) const noexcept {
	V128X t;
	t.v = Hash(data, len);
	size_t page = PageHash(t) % m_page_num;
	const uint8_t* space = m_space.get() + (page << m_page_level);

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
		__m256i mask = _mm256_set1_epi32((1 << (m_page_level+3U)) - 1);
		__m256i idx = _mm256_and_si256(_mm256_setr_m128i(t.m, _mm_srli_epi32(t.m, 16)), mask);
		__m256i rec = _mm256_mask_i32gather_epi32(_mm256_set1_epi32(-1), reinterpret_cast<const int*>(space),
												  _mm256_srli_epi32(idx, 5U), hole, 4);
		__m256i bit = _mm256_sllv_epi32(_mm256_set1_epi32(1), _mm256_and_si256(idx, _mm256_set1_epi32(31)));
		return _mm256_testz_si256(_mm256_andnot_si256(rec, bit), bit);
	}
#endif
	uint16_t mask = (1U << (m_page_level+3U)) - 1U;
	for (unsigned i = 0; i < N; i++) {
		uint16_t idx = t.s[i] & mask;
		uint8_t bit = 1U << (idx&7);
		if ((space[idx>>3U] & bit) == 0) {
			return false;
		}
	}
	return true;
}

template <unsigned N>
bool PageBloomFilter<N>::set(const uint8_t* data, unsigned len) noexcept {
	V128X t;
	t.v = Hash(data, len);
	size_t page = PageHash(t) % m_page_num;
	uint8_t* space = m_space.get() + (page << m_page_level);

	uint8_t hit = 1U;
	uint16_t mask = (1U << (m_page_level+3U)) - 1U;
	for (unsigned i = 0; i < N; i++) {
		uint16_t idx = t.s[i] & mask;
		uint8_t bit = 1U << (idx&7);
		hit &= space[idx>>3U] >> (idx&7);
		space[idx>>3U] |= bit;
	}
	if (hit) {
		return false;
	}
	m_unique_cnt++;
	return true;
}

template class PageBloomFilter<4>;
template class PageBloomFilter<5>;
template class PageBloomFilter<6>;
template class PageBloomFilter<7>;
template class PageBloomFilter<8>;

} //pbf


