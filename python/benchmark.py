# Copyright (c) 2023, Ruan Kunliang.
# Use of this source code is governed by a BSD-style
# license that can be found in the LICENSE file.

import struct
import pathlib
import sys
import time
import pbf
import rbloom


def benchmark_pbf():
    size = 1000000
    bf = pbf.PageBloomFilter.create(size, 0.01)

    keys = [struct.pack("<q", i) for i in range(size)]

    begin = time.time_ns()
    for i in range(0, size, 2):
        bf.set(keys[i])
    end = time.time_ns()
    delta = float(end - begin)
    
    print("pbf-set: {} ns/op".format(delta / (size/2)))

    begin = time.time_ns()
    for i in range(size):
        bf.test(keys[i])
    end = time.time_ns()
    delta = float(end - begin)

    print("pbf-test: {} ns/op".format(delta / size))


def benchmark_rbloom():
    size = 1000000
    bf = rbloom.Bloom(size, 0.01)

    keys = [struct.pack("<q", i) for i in range(size)]

    begin = time.time_ns()
    for i in range(0, size, 2):
        bf.add(keys[i])
    end = time.time_ns()
    delta = float(end - begin)
    
    print("rbloom-set: {} ns/op".format(delta / (size/2)))

    begin = time.time_ns()
    for i in range(size):
        keys[i] in bf
    end = time.time_ns()
    delta = float(end - begin)

    print("rbloom-test: {} ns/op".format(delta / size))



if __name__ == '__main__':
    benchmark_pbf()
    benchmark_rbloom()
