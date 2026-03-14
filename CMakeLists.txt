# Copyright (c) 2023, Ruan Kunliang.
# Use of this source code is governed by a BSD-style
# license that can be found in the LICENSE file.

cmake_minimum_required(VERSION 3.10)
project(PageBloomFilter)

set(CMAKE_CXX_STANDARD 14)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

option(PBF_ENABLE_AVX2 "Enable AVX2-optimized page probes" OFF)
option(PBF_ENABLE_AESNI_HASH "Enable AES-NI hash implementation" OFF)

enable_testing()

include_directories(include)

add_library(pbf SHARED src/pbf.cc src/hash.cc)

find_package(Threads REQUIRED)
find_package(GTest REQUIRED)

add_executable(pbf-test test/test.cc src/pbf.cc src/hash.cc)
target_link_libraries(pbf-test PRIVATE GTest::gtest Threads::Threads)
add_test(NAME pbf-unit-tests COMMAND pbf-test)

add_executable(bench test/bench.cc src/pbf.cc src/hash.cc)

include(CheckCXXCompilerFlag)

function(pbf_enable_optional_simd target_name)
    if(NOT PBF_ENABLE_AVX2)
        target_compile_definitions(${target_name} PRIVATE DISABLE_SIMD_OPTIMIZE)
        return()
    endif()

    if(MSVC)
        target_compile_options(${target_name} PRIVATE /arch:AVX2)
    else()
        check_cxx_compiler_flag("-mavx2" PBF_COMPILER_SUPPORTS_AVX2)
        if(NOT PBF_COMPILER_SUPPORTS_AVX2)
            message(FATAL_ERROR "PBF_ENABLE_AVX2=ON requires compiler support for -mavx2")
        endif()
        target_compile_options(${target_name} PRIVATE -mavx2)
    endif()
endfunction()

function(pbf_enable_optional_aesni_hash target_name)
    if(NOT PBF_ENABLE_AESNI_HASH)
        return()
    endif()

    target_compile_definitions(${target_name} PRIVATE USE_AESNI_HASH)

    if(MSVC)
        return()
    endif()

    check_cxx_compiler_flag("-maes" PBF_COMPILER_SUPPORTS_AES)
    check_cxx_compiler_flag("-mssse3" PBF_COMPILER_SUPPORTS_SSSE3)
    if(NOT PBF_COMPILER_SUPPORTS_AES OR NOT PBF_COMPILER_SUPPORTS_SSSE3)
        message(FATAL_ERROR "PBF_ENABLE_AESNI_HASH=ON requires compiler support for -maes and -mssse3")
    endif()
    target_compile_options(${target_name} PRIVATE -maes -mssse3)
endfunction()

foreach(target pbf pbf-test bench)
    pbf_enable_optional_simd(${target})
    pbf_enable_optional_aesni_hash(${target})
endforeach()

#include_directories(3rd-party/include)
#link_directories(3rd-party/lib)

#add_executable(set-bench test/set-bench.cc test/set-wrapper.cc)

#add_executable(peer-bench test/peer-bench.cc)
#target_link_libraries(peer-bench bloom pbf bf)
