import math
import struct
import time

from _pbf import PageBloomFilter as _NativePageBloomFilter

__all__ = ["PageBloomFilter"]

_LN2 = math.log(2.0)


class PageBloomFilter:
    def __init__(self, way, page_level, page_num, unique_cnt=0, data=None):
        self._native = _NativePageBloomFilter(way, page_level, page_num, unique_cnt, data)

    @property
    def way(self):
        return self._native.way

    @property
    def page_level(self):
        return self._native.page_level

    @property
    def page_num(self):
        return self._native.page_num

    @property
    def unique_cnt(self):
        return self._native.unique_cnt

    @property
    def data(self):
        return self._native.data

    def clear(self):
        self._native.clear()

    def set(self, key):
        return self._native.set(key)

    def test(self, key):
        return self._native.test(key)

    def capacity(self):
        return self._native.capacity()

    def virtual_capacity(self, fpr):
        return self._native.virtual_capacity(fpr)

    def virual_capacity(self, fpr):
        return self._native.virual_capacity(fpr)

    def export_state(self):
        return self._native.export_state()

    def __contains__(self, key):
        return key in self._native

    def __repr__(self):
        return repr(self._native)

    @staticmethod
    def best_way(fpr):
        if fpr > 0.1:
            fpr = 0.1
        elif fpr < 0.0005:
            fpr = 0.0005

        way = round(-math.log2(fpr))
        if way < 4:
            return 4
        if way > 8:
            return 8
        return way

    @classmethod
    def create(cls, item, fpr):
        if item < 1:
            item = 1

        if fpr > 0.1:
            fpr = 0.1
        elif fpr < 0.0005:
            fpr = 0.0005

        w = -math.log2(fpr)
        bpi = w / (_LN2 * 8.0)
        if w > 9.0:
            x = w - 7.0
            bpi *= 1.0 + 0.0025 * x * x
        elif w > 3.0:
            bpi *= 1.01

        way = cls.best_way(fpr)
        n = int(bpi * item)
        page_level = 12
        for i in range(6, 12):
            if n >= (1 << (i + 4)):
                continue
            page_level = i
            if page_level < (8 - 8 / way):
                page_level += 1
            break

        page_num = (n + (1 << page_level) - 1) >> page_level
        if page_num == 0:
            page_num = 1
        if page_num >= 0x100000000:
            raise OverflowError("too many items for the Python implementation")

        return cls(way, page_level, page_num)

    @classmethod
    def restore(cls, way, page_level, data, unique_cnt=0):
        page_num = len(data) >> page_level
        return cls(way, page_level, page_num, unique_cnt=unique_cnt, data=data)


def _test_create():
    bf = PageBloomFilter.create(500, 0.01)
    assert bf.way == 7
    assert bf.page_level == 7
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

