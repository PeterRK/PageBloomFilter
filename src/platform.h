// Copyright (c) 2023, Ruan Kunliang.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

#pragma once
#ifndef PAGE_BLOOM_FILTER_PLATFORM_H
#define PAGE_BLOOM_FILTER_PLATFORM_H

// The native fast paths intentionally rely on little-endian, potentially
// unaligned 32-bit and 64-bit loads. Keep that implementation contract local
// to the native sources instead of exposing platform macros in public headers.
#if defined(_M_X64) || defined(__x86_64__) || defined(__amd64__)
#define PBF_ARCH_X86_64 1
#elif defined(_M_ARM64) || defined(__aarch64__)
#define PBF_ARCH_AARCH64 1
#else
#error "PageBloomFilter requires an x86-64 or AArch64 target with unaligned memory access"
#endif

#if defined(_WIN32)
// Supported Windows targets are little-endian.
#elif defined(__BYTE_ORDER__) && defined(__ORDER_BIG_ENDIAN__) && \
      (__BYTE_ORDER__ == __ORDER_BIG_ENDIAN__)
#error "PageBloomFilter supports little-endian targets only"
#elif defined(__BYTE_ORDER__) && defined(__ORDER_LITTLE_ENDIAN__) && \
      (__BYTE_ORDER__ == __ORDER_LITTLE_ENDIAN__)
#elif defined(PBF_ARCH_X86_64)
#elif defined(PBF_ARCH_AARCH64) && defined(__AARCH64EL__)
#else
#error "Unable to verify that PageBloomFilter is being built for a little-endian target"
#endif

#endif // PAGE_BLOOM_FILTER_PLATFORM_H
