// Copyright (c) 2023, Ruan Kunliang.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

#include <string>
#include <chrono>
#include <iostream>
#include "pbf.h"
#include "bloom.h"
#include "bf/all.hpp"

constexpr size_t N = 1000000;

struct DeltaTime {
	long set = 0;
	long test = 0;

	const DeltaTime& operator+=(const DeltaTime& x) noexcept {
		set += x.set;
		test += x.test;
		return *this;
	}
};

template <unsigned W>
DeltaTime BenchMark(pbf::PageBloomFilter<W>& bf) {
	auto a = std::chrono::steady_clock::now();
	for (uint64_t i = 0; i < N; i += 2) {
		bf.set(reinterpret_cast<const uint8_t*>(&i), 8);
	}
	auto b = std::chrono::steady_clock::now();
	for (uint64_t i = 0; i < N; i++) {
		bf.test(reinterpret_cast<const uint8_t*>(&i), 8);
	}
	auto c = std::chrono::steady_clock::now();
	return {
		std::chrono::duration_cast<std::chrono::nanoseconds>(b - a).count(),
		std::chrono::duration_cast<std::chrono::nanoseconds>(c - b).count()
	};
}

DeltaTime BenchMark(bf::basic_bloom_filter& bf) {
	auto a = std::chrono::steady_clock::now();
	for (uint64_t i = 0; i < N; i += 2) {
		bf.add(i);
	}
	auto b = std::chrono::steady_clock::now();
	for (uint64_t i = 0; i < N; i++) {
		bf.lookup(i);
	}
	auto c = std::chrono::steady_clock::now();
	return {
		std::chrono::duration_cast<std::chrono::nanoseconds>(b - a).count(),
		std::chrono::duration_cast<std::chrono::nanoseconds>(c - b).count()
	};
}

DeltaTime BenchMark(bloom& bf) {
	auto a = std::chrono::steady_clock::now();
	for (uint64_t i = 0; i < N; i += 2) {
		bloom_add(&bf, &i, 8);
	}
	auto b = std::chrono::steady_clock::now();
	for (uint64_t i = 0; i < N; i++) {
		bloom_check(&bf, &i, 8);
	}
	auto c = std::chrono::steady_clock::now();
	return {
		std::chrono::duration_cast<std::chrono::nanoseconds>(b - a).count(),
		std::chrono::duration_cast<std::chrono::nanoseconds>(c - b).count()
	};
}

int main(int argc, char* argv[]) {
	const unsigned loop = 100;
	DeltaTime t;

	auto bf1 = NEW_BLOOM_FILTER(N, 0.01);
	t = DeltaTime();
	for (int i = 0; i < loop; i++) {
		t += BenchMark(bf1);
		bf1.clear();
	}
	std::cout << "pbf-set: " << (t.set / (double)(loop*N/2)) << " ns/op\n";
	std::cout << "pbf-test: " << (t.test / (double)(loop*N)) << " ns/op\n";

	bf::basic_bloom_filter bf2(0.01, N);
	t = DeltaTime();
	for (int i = 0; i < loop; i++) {
		t += BenchMark(bf2);
		bf2.clear();
	}
	std::cout << "libbf-set: " << (t.set / (double)(loop*N/2)) << " ns/op\n";
	std::cout << "libbf-test: " << (t.test / (double)(loop*N)) << " ns/op\n";

	bloom bf3;
	bloom_init2(&bf3, N, 0.01);
	t = DeltaTime();
	for (int i = 0; i < loop; i++) {
		t += BenchMark(bf3);
		bloom_reset(&bf3);
	}
	bloom_free(&bf3);
	std::cout << "libbloom-set: " << (t.set / (double)(loop*N/2)) << " ns/op\n";
	std::cout << "libbloom-test: " << (t.test / (double)(loop*N)) << " ns/op\n";

	return 0;
}