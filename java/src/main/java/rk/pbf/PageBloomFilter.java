// Copyright (c) 2023, Ruan Kunliang.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

package rk.pbf;

import java.lang.Math;
import java.util.Arrays;

public class PageBloomFilter {
    private int way = 0;
    private int pageLevel = 0;
    private int pageNum = 0;
    private long uniqueCnt = 0;
    private byte[] data = null;

    public int getWay() { return way; }
    public int getPageLevel() { return pageLevel; }
    public int getPageNum() { return pageNum; }

    public long getUniqueCnt() { return uniqueCnt; }
    public final byte[] getData() { return data; }

    private static final double LN2 = Math.log(2);

    public static PageBloomFilter New(long item, double falsePositiveRate) {
        if (item < 1) {
            item = 1;
        }
        if (falsePositiveRate > 0.1) {
            falsePositiveRate = 0.1;
        } else if (falsePositiveRate < 0.0005) {
            falsePositiveRate = 0.0005;
        }
        double w = -Math.log(falsePositiveRate) / LN2;
        double bytesPerItem = w / (LN2 * 8);
        int way = Math.round((float)w);
        if (way < 4) {
            way = 4;
        } else if (way > 8) {
            way = 8;
            bytesPerItem *= 1.025;
        } else {
            bytesPerItem *= 1.01;
        }

        long n = (long)(bytesPerItem * item);
        int pageLevel = 0;
        for (int i = 7; i < 12; i++) {
            if (n < (1L << (i + 2))) {
                pageLevel = i;
                if (pageLevel < (8 - 8/way)) {
                    pageLevel++;
                }
                break;
            }
        }
        if (pageLevel == 0) {
            pageLevel = 12;
        }

        long pageNum = (n + (1L << pageLevel) - 1L) >> pageLevel;
        if (pageNum > Integer.MAX_VALUE) {
            throw new IllegalArgumentException("too many items");
        }
        return new PageBloomFilter(way, pageLevel, (int)pageNum);
    }

    public PageBloomFilter(int way, int pageLevel, int pageNum) {
        if (way < 4 || way > 8) {
            throw new IllegalArgumentException("way should be 4-8");
        }
        if (pageLevel < (8-8/way) || pageLevel > 13) {
            throw new IllegalArgumentException("pageLevel should be 7-13");
        }
        if (pageNum <= 0) {
            throw new IllegalArgumentException("pageNum should be positive");
        }

        this.way = way;
        this.pageLevel = pageLevel;
        this.pageNum = pageNum;
        this.uniqueCnt = 0;
        this.data = new byte[pageNum<<pageLevel];
    }

    public PageBloomFilter(int way, int pageLevel, byte[] data, long uniqueCnt) {
        if (way < 4 || way > 8) {
            throw new IllegalArgumentException("way should be 4-8");
        }
        if (pageLevel < (8-8/way) || pageLevel > 13) {
            throw new IllegalArgumentException("pageLevel should be 7-13");
        }
        int pageSize = 1 << pageLevel;
        if (data == null || data.length == 0 || data.length%pageSize != 0) {
            throw new IllegalArgumentException("illegal data size");
        }
        this.way = way;
        this.pageLevel = pageLevel;
        this.pageNum = data.length / pageSize;
        this.uniqueCnt = uniqueCnt;
        this.data = Arrays.copyOf(data, data.length);
    }

    public void clear() {
        Arrays.fill(data, (byte)0);
    }

    private static int rot(int x, int k) {
        return (x << k) | (x >>> (32 - k));
    }

    private static final class HashResult {
        int offset = 0;
        int[] codes = new int[8];
    }
    private HashResult hash(byte[] key) {
        Hash.V128 code = Hash.hash128(key);
        int w0 = (int)code.low;
        int w1 = (int)(code.low>>>32);
        int w2 = (int)code.high;
        int w3 = (int)(code.high>>>32);
        HashResult ret = new HashResult();
        long x = rot(w0, 8) ^ rot(w1, 6) ^ rot(w2, 4) ^ rot(w3, 2);
        ret.offset = (int)((x & 0xffffffffL) % pageNum);
        ret.offset <<= pageLevel;
        ret.codes[0] = w0 & 0xffff;
        ret.codes[1] = w0 >>> 16;
        ret.codes[2] = w1 & 0xffff;
        ret.codes[3] = w1 >>> 16;
        ret.codes[4] = w2 & 0xffff;
        ret.codes[5] = w2 >>> 16;
        ret.codes[6] = w3 & 0xffff;
        ret.codes[7] = w3 >>> 16;
        return ret;
    }

    public boolean set(byte[] key) {
        HashResult h = hash(key);
        int mask = (1 << (pageLevel+3)) - 1;
        byte hit = 1;
        for (int i = 0; i < way; i++) {
            int idx = h.codes[i] & mask;
            byte bit = (byte)(1 << (idx & 7));
            hit &= data[h.offset+(idx>>>3)] >>> (idx & 7);
            data[h.offset+(idx>>>3)] |= bit;
        }
        if (hit != 0) {
            return false;
        }
        uniqueCnt++;
        return true;
    }

    public boolean test(byte[] key) {
        HashResult h = hash(key);
        int mask = (1 << (pageLevel+3)) - 1;
        for (int i = 0; i < way; i++) {
            int idx = h.codes[i] & mask;
            byte bit = (byte)(1 << (idx & 7));
            if ((data[h.offset+(idx>>>3)] & bit) == 0) {
                return false;
            }
        }
        return true;
    }
}
