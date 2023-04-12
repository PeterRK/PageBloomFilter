# Copyright (c) 2023, Ruan Kunliang.
# Use of this source code is governed by a BSD-style
# license that can be found in the LICENSE file.

cmake_minimum_required(VERSION 3.10)
project(PageBloomFilter)

set(CMAKE_CXX_STANDARD 14)

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -march=native")

add_library(pbf pbf.cc hash.cc)

add_executable(test test/test.cc pbf.cc hash.cc)
target_link_libraries(test gtest pthread)

add_executable(bench test/bench.cc pbf.cc hash.cc)

#add_executable(set-bench test/set-bench.cc test/set-wrapper.cc)