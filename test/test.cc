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