// Copyright (c) 2023, Ruan Kunliang.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

#include <gtest/gtest.h>
#include "pbf.h"

int main(int argc,char **argv){
	testing::InitGoogleTest(&argc,argv);
	return RUN_ALL_TESTS();
}

TEST(PBF, New) {
	auto bf = NEW_BLOOM_FILTER(500, 0.01);
	ASSERT_FALSE(!bf);
	ASSERT_EQ(7, bf.way());
	ASSERT_EQ(7, bf.page_level());
	ASSERT_EQ(640, bf.data_size());
	auto p = pbf::New(500, 0.01);
	ASSERT_NE(nullptr, p);
	ASSERT_FALSE(!*p);
	ASSERT_EQ(7, p->way());
	ASSERT_EQ(7, p->page_level());
	ASSERT_EQ(640, p->data_size());
}

TEST(PBF, SmallEstimate) {
	auto bf = NEW_BLOOM_FILTER(1, 0.1);
	ASSERT_FALSE(!bf);
	ASSERT_EQ(4, bf.way());
	ASSERT_EQ(6, bf.page_level());
	ASSERT_EQ(64, bf.data_size());
	auto p = pbf::New(1, 0.1);
	ASSERT_NE(nullptr, p);
	ASSERT_FALSE(!*p);
	ASSERT_EQ(1, p->page_num());
}

template <typename Word, size_t D, size_t V>
void CheckDivisors(const Word (&divisors)[D], const Word (&values)[V]) {
	for (Word divisor : divisors) {
		pbf::Divisor<Word> fast(divisor);
		for (Word value : values) {
			ASSERT_EQ(static_cast<Word>(value / divisor), fast.div(value));
			ASSERT_EQ(static_cast<Word>(value % divisor), fast.mod(value));
		}
	}
}

TEST(PBF, SoftDivide) {
	const uint8_t divisors8[] = {1, 2, 3, 7, 127, 251, 255};
	const uint8_t values8[] = {0, 1, 2, 7, 63, 127, 128, 251, 254, 255};
	CheckDivisors(divisors8, values8);

	const uint16_t divisors16[] = {1, 2, 3, 255, 256, 257, 65521, 65535};
	const uint16_t values16[] = {0, 1, 2, 255, 256, 257, 32767, 32768, 65534, 65535};
	CheckDivisors(divisors16, values16);

	const uint32_t divisors32[] = {1U, 2U, 3U, 65535U, 65536U, 65537U, 0x7fffffffU, 0xfffffffbU, 0xffffffffU};
	const uint32_t values32[] = {0U, 1U, 2U, 65535U, 65536U, 65537U, 0x7fffffffU, 0x80000000U, 0xfffffffeU, 0xffffffffU};
	CheckDivisors(divisors32, values32);
}

template <unsigned N>
void DoTest() {
	pbf::PageBloomFilter<N> bf(7, 3);
	ASSERT_FALSE(!bf);
	ASSERT_GE(bf.capacity(), 384);

	for (uint64_t i = 0; i < 200; i++) {
		ASSERT_TRUE(bf.set(reinterpret_cast<const uint8_t*>(&i), 8));
	}
	ASSERT_EQ(bf.unique_cnt(), 200);

	for (uint64_t i = 0; i < 200; i++) {
		ASSERT_TRUE(bf.test(reinterpret_cast<const uint8_t*>(&i), 8));
	}
	for (uint64_t i = 200; i < 400; i++) {
		ASSERT_FALSE(bf.test(reinterpret_cast<const uint8_t*>(&i), 8));
	}
}

TEST(PBF, X8) { DoTest<8>(); }
TEST(PBF, X7) { DoTest<7>(); }
TEST(PBF, X6) { DoTest<6>(); }
TEST(PBF, X5) { DoTest<5>(); }
TEST(PBF, X4) { DoTest<4>(); }

TEST(PBF, Copy) {
	auto bf = pbf::New(500, 0.01);
	for (uint64_t i = 0; i < 200; i++) {
		ASSERT_TRUE(bf->set(reinterpret_cast<const uint8_t*>(&i), 8));
	}
	auto copy = pbf::New(bf->way(), bf->page_level(), bf->data(), bf->data_size(), bf->unique_cnt());
	for (uint64_t i = 0; i < 200; i++) {
		ASSERT_TRUE(copy->test(reinterpret_cast<const uint8_t*>(&i), 8));
	}
	for (uint64_t i = 200; i < 400; i++) {
		ASSERT_TRUE(copy->set(reinterpret_cast<const uint8_t*>(&i), 8));
	}
	for (uint64_t i = 200; i < 400; i++) {
		ASSERT_FALSE(bf->test(reinterpret_cast<const uint8_t*>(&i), 8));
	}
}
