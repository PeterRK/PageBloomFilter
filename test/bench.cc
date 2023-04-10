// Copyright (c) 2023, Ruan Kunliang.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

#include <chrono>
#include <iostream>
#include "../pbf.h"

int main(int argc, char* argv[]) {
#ifndef BENCHMARK_WAY
	#define BENCHMARK_WAY 8
#endif
	pbf::PageBloomFilter< BENCHMARK_WAY > bf(12, 250);

	const uint64_t n = 1000000;

	auto start = std::chrono::steady_clock::now();
	for (uint64_t i = 0; i < n; i+=2) {
		bf.set(reinterpret_cast<const uint8_t*>(&i), 8);
	}
	auto end = std::chrono::steady_clock::now();
	auto delta = std::chrono::duration_cast<std::chrono::nanoseconds>(end - start).count();
	std::cout << "set: " << static_cast<double>(delta)/(n/2) << "ns/op" << std::endl;

	start = std::chrono::steady_clock::now();
	for (uint64_t i = 0; i < n; i++) {
		bf.test(reinterpret_cast<const uint8_t*>(&i), 8);
	}
	end = std::chrono::steady_clock::now();

	delta = std::chrono::duration_cast<std::chrono::nanoseconds>(end - start).count();
	std::cout << "test: " << static_cast<double>(delta)/n << "ns/op" << std::endl;
	return 0;
}