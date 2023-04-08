// Copyright (c) 2023, Ruan Kunliang.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

#pragma once
#ifndef PAGE_BLOOM_FILTER_HASH_H
#define PAGE_BLOOM_FILTER_HASH_H

#include <cstdint>

namespace pbf {

#define FORCE_INLINE inline __attribute__((always_inline))

struct V128 {
	uint64_t l;
	uint64_t h;
};

extern V128 Hash(const uint8_t* msg, unsigned len, uint64_t seed=0) noexcept;

} //pbf
#endif // PAGE_BLOOM_FILTER_HASH_H