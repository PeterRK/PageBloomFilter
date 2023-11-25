# Copyright (c) 2023, Ruan Kunliang.
# Use of this source code is governed by a BSD-style
# license that can be found in the LICENSE file.

import math
import time
import struct
import _pbf


class PageBloomFilter:
    def __init__(self, way, page_level, page_num, unique_cnt=0, data=None):
        assert type(way) is int and 4 <= way <= 8 and \
               type(page_level) is int and (8-8/way) <= page_level <= 13 and \
               type(page_num) is int and 0 < page_num < 0xffffffff
        self.way = way
        self.page_level = page_level
        self.page_num = page_num
        data_size = page_num << page_level
        if data is None:
            self.data = bytearray(data_size)
            self.clear()
        else:
            assert len(data) == data_size
            self.data = bytearray(data)
            self.unique_cnt = unique_cnt

        api_set, api_test = PageBloomFilter._funcs[way]
        self._set = lambda key: api_set(self.data, self.page_level, self.page_num, key)
        self.test = lambda key: api_test(self.data, self.page_level, self.page_num, key)

    _funcs = {
        4: (_pbf.set4, _pbf.test4),
        5: (_pbf.set5, _pbf.test5),
        6: (_pbf.set6, _pbf.test6),
        7: (_pbf.set7, _pbf.test7),
        8: (_pbf.set8, _pbf.test8),
    }

    def clear(self):
        self.unique_cnt = 0
        _pbf.clear(self.data)

    def set(self, key):
        if self._set(key):
            self.unique_cnt += 1
            return True
        return False

    def capacity(self):
        return len(self.data) * 8 / self.way

    def virual_capacity(self, fpr):
        t = math.lop1p(-math.pow(fpr, 1.0/self.way)) / math.log1p(-1.0/(len(self.data) * 8))
        return int(t) / self.way


_LN2 = math.log(2)


def create(item, fpr):
    """
    :param item: number of items to hold
    :param fpr: false positive rate, 0.0005-0.1
    :return: PageBloomFilter
    """
    if item < 1:
        item = 1

    if fpr > 0.1:
        fpr = 0.1
    elif fpr < 0.0005:
        fpr = 0.0005

    w = -math.log2(fpr)
    bpi = w / (_LN2 * 8)
    if w > 8.5:
        x = w - 7
        bpi *= 1 + 0.0025*x*x
    elif w > 3:
        bpi *= 1.01

    way = round(w)
    if way < 4:
        way = 4
    elif way > 8:
        way = 8

    n = int(bpi * item)
    page_level = None
    for i in range(6, 12):
        if n >= (1 << (i+4)):
            continue
        page_level = i
        if page_level < (8 - 8/way):
            page_level += 1
        break
    if page_level is None:
        page_level = 12

    page_num = (n + (1 << page_level) - 1) >> page_level
    return PageBloomFilter(way, page_level, page_num)


def _test_create():
    bf = create(500, 0.01)
    assert bf.way == 7
    assert bf.page_level == 7
    assert bf.page_num == 3
    assert len(bf.data) == 640


def _test_operate(way):
    bf = PageBloomFilter(way, 7, 3)

    for i in range(200):
        assert bf.set(struct.pack("<q", i))

    for i in range(200):
        assert bf.test(struct.pack("<q", i))

    for i in range(200, 400):
        assert not bf.test(struct.pack("<q", i))


def test():
    _test_create()
    for i in range(4, 9):
        _test_operate(i)


def benchmark():
    size = 1000000
    bf = create(size, 0.01)

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
