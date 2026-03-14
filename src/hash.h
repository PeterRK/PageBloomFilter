// Copyright (c) 2023, Ruan Kunliang.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

#pragma once
#ifndef PAGE_BLOOM_FILTER_HASH_H
#define PAGE_BLOOM_FILTER_HASH_H

#include <cstdint>

namespace pbf {

#if defined(_MSC_VER)
#define FORCE_INLINE __forceinline
#elif defined(__GNUC__) || defined(__clang__)
#define FORCE_INLINE inline __attribute__((always_inline))
#else
#define FORCE_INLINE inline
#endif

struct V128 {
	uint64_t l;
	uint64_t h;
};


extern V128 Hash(const uint8_t* msg, unsigned len) noexcept;

} //pbf
#endif // PAGE_BLOOM_FILTER_HASH_H
