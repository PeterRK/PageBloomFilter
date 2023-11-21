# Copyright (c) 2023, Ruan Kunliang.
# Use of this source code is governed by a BSD-style
# license that can be found in the LICENSE file.

cmake_minimum_required(VERSION 3.10)
project(PageBloomFilter)

set(CMAKE_CXX_STANDARD 14)

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -march=native")

include_directories(include)

add_library(pbf SHARED src/pbf.cc src/hash.cc)

add_executable(test test/test.cc src/pbf.cc src/hash.cc)
target_link_libraries(test gtest pthread)

add_executable(bench test/bench.cc src/pbf.cc src/hash.cc)

#include_directories(3rd-party/include)
#link_directories(3rd-party/lib)

#add_executable(set-bench test/set-bench.cc test/set-wrapper.cc)

#add_executable(peer-bench test/peer-bench.cc)
#target_link_libraries(peer-bench bloom pbf bf)