// Copyright (c) 2023, Ruan Kunliang.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

#pragma once
#ifndef PAGE_BLOOM_FILTER_C_H
#define PAGE_BLOOM_FILTER_C_H

#include <stdint.h>
#include <stddef.h>
#include <stdbool.h>

#ifdef __cplusplus
extern "C" {
#endif

#define PAGE_BLOOM_FILTER_FUNC(way) \
extern bool PBF##way##_Set(void* space, unsigned page_level, unsigned page_num, const void* key, unsigned len); \
extern bool PBF##way##_Test(const void* space, unsigned page_level, unsigned page_num, const void* key, unsigned len);

PAGE_BLOOM_FILTER_FUNC(4)
PAGE_BLOOM_FILTER_FUNC(5)
PAGE_BLOOM_FILTER_FUNC(6)
PAGE_BLOOM_FILTER_FUNC(7)
PAGE_BLOOM_FILTER_FUNC(8)

#undef PAGE_BLOOM_FILTER_FUNC

#ifdef __cplusplus
}
#endif
#endif //PAGE_BLOOM_FILTER_C_H