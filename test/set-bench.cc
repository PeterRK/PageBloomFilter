// Copyright (c) 2023, Ruan Kunliang.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

#include <chrono>
#include <iostream>
#include "set-wrapper.h"

int main(int argc, char* argv[]) {
	const uint64_t n = 1000000;
	Set set(n/2);
	std::string key;
	key.resize(8);
	uint64_t& num = *reinterpret_cast<uint64_t*>(&key[0]);

	auto start = std::chrono::steady_clock::now();
	for (uint64_t i = 0; i < n; i+=2) {
		num = i;
		set.set(key);
	}
	auto end = std::chrono::steady_clock::now();
	auto delta = std::chrono::duration_cast<std::chrono::nanoseconds>(end - start).count();
	std::cout << "set: " << static_cast<double>(delta)/(n/2) << "ns/op" << std::endl;

	start = std::chrono::steady_clock::now();
	for (uint64_t i = 0; i < n; i++) {
		num = i;
		set.test(key);
	}
	end = std::chrono::steady_clock::now();

	delta = std::chrono::duration_cast<std::chrono::nanoseconds>(end - start).count();
	std::cout << "test: " << static_cast<double>(delta)/n << "ns/op" << std::endl;
	return 0;
}