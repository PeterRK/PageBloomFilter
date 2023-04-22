// Copyright (c) 2023, Ruan Kunliang.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

#include "pbf-c.h"
#include "pbf-internal.h"
#ifdef C_ALL_IN_ONE
#include "hash.cc"
#endif

extern "C" {

#define PAGE_BLOOM_FILTER_FUNC(way) \
bool PBF##way##_Set(void* space, unsigned page_level, unsigned page_num,        \
	const void* key, unsigned len) {                                            \
	pbf::V128X t;                                                               \
	t.v = pbf::Hash((const uint8_t*)key, len);                                  \
	size_t idx = PageHash(t) % page_num;                                        \
	auto page = ((uint8_t*)space) + (idx << page_level);                        \
	return pbf::Set< way >(page, page_level, t);                                \
} \
bool PBF##way##_Test(const void* space, unsigned page_level, unsigned page_num, \
	const void* key, unsigned len) {                                            \
	pbf::V128X t;                                                               \
	t.v = pbf::Hash((const uint8_t*)key, len);                                  \
	size_t idx = PageHash(t) % page_num;                                        \
	auto page = ((uint8_t*)space) + (idx << page_level);                        \
	return pbf::Test< way >(page, page_level, t);                               \
}

PAGE_BLOOM_FILTER_FUNC(4)
PAGE_BLOOM_FILTER_FUNC(5)
PAGE_BLOOM_FILTER_FUNC(6)
PAGE_BLOOM_FILTER_FUNC(7)
PAGE_BLOOM_FILTER_FUNC(8)

#undef PAGE_BLOOM_FILTER_FUNC
}