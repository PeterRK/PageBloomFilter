// Copyright (c) 2023, Ruan Kunliang.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

#include <gtest/gtest.h>
#include <algorithm>
#include <string>
#include <vector>
#include "pbf.h"
#include "pbf-c.h"

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

static std::vector<uint8_t> FromHex(const std::string& hex) {
	std::vector<uint8_t> bytes;
	bytes.reserve(hex.size() / 2);
	for (size_t i = 0; i < hex.size(); i += 2) {
		bytes.push_back(static_cast<uint8_t>(std::stoul(hex.substr(i, 2), nullptr, 16)));
	}
	return bytes;
}

TEST(PBF, StableBitmapLayout) {
	auto bf = pbf::New(1, 0.01);
	ASSERT_NE(nullptr, bf);

	const std::vector<std::vector<uint8_t>> keys = {
		{0x61, 0x6c, 0x70, 0x68, 0x61},
		{0xe4, 0xb8, 0xad, 0xe6, 0x96, 0x87, 0xe9, 0x94, 0xae},
		{},
		{0x00, 0x01, 0x02, 0x03, 0xff},
	};
	const uint8_t empty_key = 0;
	for (const auto& key : keys) {
		const uint8_t* data = key.empty() ? &empty_key : key.data();
		ASSERT_TRUE(bf->set(data, static_cast<unsigned>(key.size())));
	}

	const auto expected = FromHex(
		"0000000010000000000000004000000000000000000000100100000000010000"
		"0000000200000000000000000000040000000000040000008040000000000000"
		"0000004000004180020000002000000000000100080080000000800000000010"
		"0000000080000000000000000000410000800040000000800000000000002000");
	ASSERT_EQ(expected.size(), bf->data_size());
	EXPECT_TRUE(std::equal(expected.begin(), expected.end(), bf->data()));
}

TEST(PBF, EmptyKey) {
	auto bf = pbf::New(1, 0.01);
	ASSERT_NE(nullptr, bf);
	EXPECT_TRUE(bf->set(nullptr, 0));
	EXPECT_TRUE(bf->test(nullptr, 0));
	EXPECT_FALSE(bf->set(nullptr, 1));
	EXPECT_FALSE(bf->test(nullptr, 1));
}

TEST(PBF, CApiEmptyKey) {
	std::vector<uint8_t> data(128);
	EXPECT_TRUE(PBF7_Set(data.data(), 7, 1, nullptr, 0));
	EXPECT_TRUE(PBF7_Test(data.data(), 7, 1, nullptr, 0));
	EXPECT_FALSE(PBF7_Set(data.data(), 7, 1, nullptr, 1));
	EXPECT_FALSE(PBF7_Test(data.data(), 7, 1, nullptr, 1));
}

TEST(PBF, RestoreRejectsInvalidBitmapSize) {
	std::vector<uint8_t> data(129);
	EXPECT_EQ(nullptr, pbf::New(7, 7, data.data(), data.size(), 0));
	EXPECT_EQ(nullptr, pbf::New(7, 7, nullptr, 128, 0));
	EXPECT_EQ(nullptr, pbf::New(7, 7, data.data(), 0, 0));
	EXPECT_EQ(nullptr, pbf::New(4, 6, pbf::kMaxPageNum));
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
