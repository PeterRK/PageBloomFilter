# Copyright (c) 2023, Ruan Kunliang.
# Use of this source code is governed by a BSD-style
# license that can be found in the LICENSE file.

cmake_minimum_required(VERSION 3.10)
project(PageBloomFilter VERSION 1.3.0 LANGUAGES CXX)

include(GNUInstallDirs)
include(CMakePackageConfigHelpers)

option(BUILD_SHARED_LIBS "Build PageBloomFilter as a shared library" ON)

set(CMAKE_CXX_STANDARD 14)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

string(TOLOWER "${CMAKE_SYSTEM_PROCESSOR}" PBF_SYSTEM_PROCESSOR)
if(PBF_SYSTEM_PROCESSOR MATCHES "^(x86_64|amd64|x64)$")
    option(PBF_ENABLE_AVX2 "Compile AVX2-optimized page probes" ON)
    option(PBF_ENABLE_AESNI_HASH "Enable the data-incompatible AES-NI hash implementation" OFF)
elseif(PBF_ENABLE_AVX2 OR PBF_ENABLE_AESNI_HASH)
    message(FATAL_ERROR "PBF_ENABLE_AVX2 and PBF_ENABLE_AESNI_HASH require an x86-64 target")
endif()

include(CTest)

add_library(pbf src/pbf.cc src/pbf-c.cc src/hash.cc)
add_library(PageBloomFilter::pbf ALIAS pbf)
target_include_directories(pbf
    PUBLIC
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
        $<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}>
)
set_target_properties(pbf PROPERTIES
    EXPORT_NAME pbf
    VERSION ${PROJECT_VERSION}
    SOVERSION ${PROJECT_VERSION_MAJOR}
    WINDOWS_EXPORT_ALL_SYMBOLS ON
)

find_package(Threads REQUIRED)

if(BUILD_TESTING)
    find_package(GTest REQUIRED)

    add_executable(pbf-test test/test.cc src/pbf.cc src/hash.cc)
    target_include_directories(pbf-test PRIVATE include)
    target_link_libraries(pbf-test PRIVATE GTest::gtest Threads::Threads)
    add_test(NAME pbf-unit-tests COMMAND pbf-test)
endif()

add_executable(bench test/bench.cc src/pbf.cc src/hash.cc)
target_include_directories(bench PRIVATE include)

include(CheckCXXCompilerFlag)

function(pbf_enable_optional_simd target_name)
    if(NOT PBF_ENABLE_AVX2)
        return()
    endif()

    if(MSVC)
        target_compile_options(${target_name} PRIVATE /arch:AVX2)
    else()
        check_cxx_compiler_flag("-mavx2" PBF_COMPILER_SUPPORTS_AVX2)
        if(NOT PBF_COMPILER_SUPPORTS_AVX2)
            message(WARNING "Compiler does not support -mavx2; using scalar page probes")
            return()
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

set(PBF_TARGETS pbf bench)
if(BUILD_TESTING)
    list(APPEND PBF_TARGETS pbf-test)
endif()

foreach(target IN LISTS PBF_TARGETS)
    pbf_enable_optional_simd(${target})
    pbf_enable_optional_aesni_hash(${target})
endforeach()

install(TARGETS pbf
    EXPORT PageBloomFilterTargets
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
    INCLUDES DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
)
install(FILES include/pbf.h include/pbf-c.h
    DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
)
install(FILES LICENSE
    DESTINATION ${CMAKE_INSTALL_DATAROOTDIR}/doc/PageBloomFilter
)
install(EXPORT PageBloomFilterTargets
    FILE PageBloomFilterTargets.cmake
    NAMESPACE PageBloomFilter::
    DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/PageBloomFilter
)

configure_package_config_file(
    cmake/PageBloomFilterConfig.cmake.in
    ${CMAKE_CURRENT_BINARY_DIR}/PageBloomFilterConfig.cmake
    INSTALL_DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/PageBloomFilter
)
write_basic_package_version_file(
    ${CMAKE_CURRENT_BINARY_DIR}/PageBloomFilterConfigVersion.cmake
    VERSION ${PROJECT_VERSION}
    COMPATIBILITY SameMajorVersion
)
install(FILES
    ${CMAKE_CURRENT_BINARY_DIR}/PageBloomFilterConfig.cmake
    ${CMAKE_CURRENT_BINARY_DIR}/PageBloomFilterConfigVersion.cmake
    DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/PageBloomFilter
)

#include_directories(3rd-party/include)
#link_directories(3rd-party/lib)

#add_executable(set-bench test/set-bench.cc test/set-wrapper.cc)

#add_executable(peer-bench test/peer-bench.cc)
#target_link_libraries(peer-bench bloom pbf bf)
