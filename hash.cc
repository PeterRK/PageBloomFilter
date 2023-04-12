// Copyright (c) 2023, Ruan Kunliang.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

#include "hash.h"
#if defined(USE_AESNI_HASH)
#include "aesni-hash.h"
#elif defined(USE_XXHASH)
#include "xxh3.h"
#endif

namespace pbf {

#if defined(USE_AESNI_HASH)

V128 Hash(const uint8_t* msg, unsigned len) noexcept {
	union {
		V128 v;
		__m128i m;
	} t;
	t.m = AESNI_Hash128(msg, len);
	return t.v;
}

#elif defined(USE_XXHASH)
V128 Hash(const uint8_t* msg, unsigned len) noexcept {
	auto ret = XXH3_128bits(msg, len);
	return {ret.low64, ret.high64};
}
#else

static FORCE_INLINE uint64_t Rot64(uint64_t x, unsigned k) {
	return (x << k) | (x >> (64U - k));
}

static FORCE_INLINE void Mix(uint64_t& h0, uint64_t& h1, uint64_t& h2, uint64_t& h3) {
	h2 = Rot64(h2,50);  h2 += h3;  h0 ^= h2;
	h3 = Rot64(h3,52);  h3 += h0;  h1 ^= h3;
	h0 = Rot64(h0,30);  h0 += h1;  h2 ^= h0;
	h1 = Rot64(h1,41);  h1 += h2;  h3 ^= h1;
	h2 = Rot64(h2,54);  h2 += h3;  h0 ^= h2;
	h3 = Rot64(h3,48);  h3 += h0;  h1 ^= h3;
	h0 = Rot64(h0,38);  h0 += h1;  h2 ^= h0;
	h1 = Rot64(h1,37);  h1 += h2;  h3 ^= h1;
	h2 = Rot64(h2,62);  h2 += h3;  h0 ^= h2;
	h3 = Rot64(h3,34);  h3 += h0;  h1 ^= h3;
	h0 = Rot64(h0,5);   h0 += h1;  h2 ^= h0;
	h1 = Rot64(h1,36);  h1 += h2;  h3 ^= h1;
}

static FORCE_INLINE void End(uint64_t& h0, uint64_t& h1, uint64_t& h2, uint64_t& h3) {
	h3 ^= h2;  h2 = Rot64(h2,15);  h3 += h2;
	h0 ^= h3;  h3 = Rot64(h3,52);  h0 += h3;
	h1 ^= h0;  h0 = Rot64(h0,26);  h1 += h0;
	h2 ^= h1;  h1 = Rot64(h1,51);  h2 += h1;
	h3 ^= h2;  h2 = Rot64(h2,28);  h3 += h2;
	h0 ^= h3;  h3 = Rot64(h3,9);   h0 += h3;
	h1 ^= h0;  h0 = Rot64(h0,47);  h1 += h0;
	h2 ^= h1;  h1 = Rot64(h1,54);  h2 += h1;
	h3 ^= h2;  h2 = Rot64(h2,32);  h3 += h2;
	h0 ^= h3;  h3 = Rot64(h3,25);  h0 += h3;
	h1 ^= h0;  h0 = Rot64(h0,63);  h1 += h0;
}

//SpookyHash
V128 Hash(const uint8_t* msg, unsigned len) noexcept {
	constexpr uint64_t magic = 0xdeadbeefdeadbeefULL;

	uint64_t a = 0;
	uint64_t b = 0;
	uint64_t c = magic;
	uint64_t d = magic;

	for (auto end = msg + (len&~0x1fU); msg < end; msg += 32) {
		auto x = (const uint64_t*)msg;
		c += x[0];
		d += x[1];
		Mix(a, b, c, d);
		a += x[2];
		b += x[3];
	}

	if (len & 0x10U) {
		auto x = (const uint64_t*)msg;
		c += x[0];
		d += x[1];
		Mix(a, b, c, d);
		msg += 16;
	}

	d += ((uint64_t)len) << 56U;
	switch (len & 0xfU) {
		case 15:
			d += ((uint64_t)msg[14]) << 48U;
		case 14:
			d += ((uint64_t)msg[13]) << 40U;
		case 13:
			d += ((uint64_t)msg[12]) << 32U;
		case 12:
			d += *(uint32_t*)(msg+8);
			c += *(uint64_t*)msg;
			break;
		case 11:
			d += ((uint64_t)msg[10]) << 16U;
		case 10:
			d += ((uint64_t)msg[9]) << 8U;
		case 9:
			d += (uint64_t)msg[8];
		case 8:
			c += *(uint64_t*)msg;
			break;
		case 7:
			c += ((uint64_t)msg[6]) << 48U;
		case 6:
			c += ((uint64_t)msg[5]) << 40U;
		case 5:
			c += ((uint64_t)msg[4]) << 32U;
		case 4:
			c += *(uint32_t*)msg;
			break;
		case 3:
			c += ((uint64_t)msg[2]) << 16U;
		case 2:
			c += ((uint64_t)msg[1]) << 8U;
		case 1:
			c += (uint64_t)msg[0];
			break;
		case 0:
			c += magic;
			d += magic;
	}
	End(a, b, c, d);

	return {a, b};
}

#endif

} //pbf