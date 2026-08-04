// Copyright (c) 2023, Ruan Kunliang.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

package com.github.peterrk.pbf;

import java.lang.Math;
import java.nio.ByteBuffer;
import java.util.Arrays;

/**
 * A page-based Bloom filter with four to eight probes per key.
 *
 * <p>The filter stores all probes for a key in one page. Standard-hash
 * implementations in this repository share the same bitmap layout, so a
 * bitmap can be restored in another implementation when its configuration is
 * compatible.</p>
 *
 * <p>This class is mutable and is not thread-safe.</p>
 */
public abstract class PageBloomFilter {
    private final int pageLevel;
    private final int pageNum;
    private long uniqueCnt;
    private final byte[] data;

    /**
     * Returns the number of bitmap probes performed for each key.
     *
     * @return the probe count, in the range 4 through 8
     */
    public abstract int getWay();

    /**
     * Returns the base-2 logarithm of the page size in bytes.
     *
     * @return the page level; each page contains {@code 1 << pageLevel} bytes
     */
    public int getPageLevel() { return pageLevel; }

    /**
     * Returns the number of pages in the bitmap.
     *
     * @return the page count
     */
    public int getPageNum() { return pageNum; }

    /**
     * Returns the stored estimate of the number of distinct inserted keys.
     *
     * <p>Calls to { #set(byte[])} increment this value only when at least
     * one bitmap bit changes. A restored filter reports the
     * { uniqueCnt} value supplied by its caller.</p>
     *
     * @return the estimated unique insertion count
     */
    public long getUniqueCnt() { return uniqueCnt; }

    /**
     * Returns a read-only view of the backing bitmap.
     *
     * <p>The returned buffer shares storage with this filter. Later calls to
     * {@link #set(byte[])} or {@link #clear()} are visible through the view,
     * but the buffer itself cannot be used to modify the filter.</p>
     *
     * @return a read-only bitmap view positioned at the first byte
     */
    public ByteBuffer getData() { return ByteBuffer.wrap(data).asReadOnlyBuffer(); }

    /**
     * Returns the nominal item capacity of this bitmap.
     *
     * @return the bitmap bit count divided by the number of probes
     */
    public long capacity() {
         return (long)data.length * 8 / getWay();
    }

    /**
     * Estimates the number of inserted items that would produce a requested
     * false-positive rate with this filter's bitmap size and probe count.
     *
     * @param falsePositiveRate the requested probability, strictly between
     *                          0 and 1
     * @return the estimated item capacity at that false-positive rate
     */
    public long virtualCapacity(double falsePositiveRate) {
        double t = Math.log1p(-Math.pow(falsePositiveRate, 1.0/getWay()))
                / Math.log1p(-1.0/(data.length * 8));
        return (long)t / getWay();
    }

    /**
     * Adds a key to this filter.
     *
     * @param key the key bytes
     * @return {@code true} if at least one bitmap bit changed, or
     *         {@code false} if all required bits were already set
     * @throws NullPointerException if {@code key} is {@code null}
     */
    public abstract boolean set(byte[] key);

    /**
     * Tests whether a key may have been added to this filter.
     *
     * @param key the key bytes
     * @return {@code false} if the key is definitely absent, or {@code true}
     *         if it may be present
     * @throws NullPointerException if {@code key} is {@code null}
     */
    public abstract boolean test(byte[] key);
    
    private static final double LN2 = Math.log(2);
    private static final int MAX_PAGE_NUM = 1 << 18;

    /**
     * Creates an empty filter sized for an expected number of items and a
     * target false-positive rate.
     *
     * <p>Item counts below 1 are treated as 1. The false-positive rate is
     * clamped to the supported range from 0.0005 through 0.1.</p>
     *
     * @param item the expected number of inserted items
     * @param falsePositiveRate the target false-positive probability
     * @return a newly allocated empty filter
     * @throws IllegalArgumentException if the calculated bitmap would contain
     *                                  too many pages
     */
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
        if (w > 9) {
            double x = w - 7;
            bytesPerItem *= 1 + 0.0025*x*x;
        } else if (w > 3) {
            bytesPerItem *= 1.01;
        }
        int way = Math.round((float)w);
        if (way < 4) {
            way = 4;
        } else if (way > 8) {
            way = 8;
        }

        long n = (long)(bytesPerItem * item);
        int pageLevel = 0;
        for (int i = 6; i < 12; i++) {
            if (n < (1L << (i + 4))) {
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
        if (pageNum == 0) {
            pageNum = 1;
        }
        if (pageNum >= MAX_PAGE_NUM) {
            throw new IllegalArgumentException("too many items");
        }
        return New(way, pageLevel, (int)pageNum);
    }

    /**
     * Creates an empty filter from explicit layout parameters.
     *
     * @param way the probe count, from 4 through 8
     * @param pageLevel the base-2 logarithm of the page size in bytes
     * @param pageNum the page count, from 1 through {@code (1 << 18) - 1}
     * @return a newly allocated empty filter
     * @throws RuntimeException if {@code way} is outside the supported range
     * @throws IllegalArgumentException if {@code pageLevel} or
     *                                  {@code pageNum} is invalid
     */
    public static PageBloomFilter New(int way, int pageLevel, int pageNum) {
        switch (way) {
            case 4: return new PageBloomFilter.Way4(pageLevel, pageNum);
            case 5: return new PageBloomFilter.Way5(pageLevel, pageNum);
            case 6: return new PageBloomFilter.Way6(pageLevel, pageNum);
            case 7: return new PageBloomFilter.Way7(pageLevel, pageNum);
            case 8: return new PageBloomFilter.Way8(pageLevel, pageNum);
            default: throw new RuntimeException("illegal way");
        }
    }

    /**
     * Initializes an empty filter for a concrete probe-count implementation.
     *
     * @param way the probe count, from 4 through 8
     * @param pageLevel the base-2 logarithm of the page size in bytes
     * @param pageNum the page count, from 1 through {@code (1 << 18) - 1}
     * @throws IllegalArgumentException if any layout parameter is invalid
     */
    protected PageBloomFilter(int way, int pageLevel, int pageNum) {
        if (way < 4 || way > 8) {
            throw new IllegalArgumentException("way should be 4-8");
        }
        if (pageLevel < (8-8/way) || pageLevel > 13) {
            throw new IllegalArgumentException("pageLevel should be 7-13");
        }
        if (pageNum <= 0 || pageNum >= MAX_PAGE_NUM) {
            throw new IllegalArgumentException("pageNum should be in [1, 1<<18)");
        }
        this.pageLevel = pageLevel;
        this.pageNum = pageNum;
        this.uniqueCnt = 0;
        this.data = new byte[pageNum<<pageLevel];
    }

    /**
     * Restores a filter from explicit layout parameters and bitmap bytes.
     *
     * <p>The supplied array becomes the filter's backing storage and is not
     * copied. Callers must not modify it after this method returns.</p>
     *
     * @param way the probe count, from 4 through 8
     * @param pageLevel the base-2 logarithm of the page size in bytes
     * @param data a non-empty, page-aligned bitmap
     * @param uniqueCnt the insertion count to restore
     * @return a filter backed by {@code data}
     * @throws RuntimeException if {@code way} is outside the supported range
     * @throws IllegalArgumentException if the bitmap or layout is invalid
     */
    public static PageBloomFilter New(int way, int pageLevel, byte[] data, long uniqueCnt) {
        switch (way) {
            case 4: return new PageBloomFilter.Way4(pageLevel, data, uniqueCnt);
            case 5: return new PageBloomFilter.Way5(pageLevel, data, uniqueCnt);
            case 6: return new PageBloomFilter.Way6(pageLevel, data, uniqueCnt);
            case 7: return new PageBloomFilter.Way7(pageLevel, data, uniqueCnt);
            case 8: return new PageBloomFilter.Way8(pageLevel, data, uniqueCnt);
            default: throw new RuntimeException("illegal way");
        }
    }

    /**
     * Restores a filter from the remaining bytes of a buffer.
     *
     * <p>Bytes from the buffer's current position through its limit are copied.
     * The position of the supplied buffer is not changed.</p>
     *
     * @param way the probe count, from 4 through 8
     * @param pageLevel the base-2 logarithm of the page size in bytes
     * @param data a buffer containing a non-empty, page-aligned bitmap
     * @param uniqueCnt the insertion count to restore
     * @return a filter backed by a copy of the remaining buffer bytes
     * @throws RuntimeException if {@code way} is outside the supported range
     * @throws IllegalArgumentException if the buffer, bitmap, or layout is
     *                                  invalid
     */
    public static PageBloomFilter New(int way, int pageLevel, ByteBuffer data, long uniqueCnt) {
        if (data == null) {
            throw new IllegalArgumentException("illegal data size");
        }
        ByteBuffer view = data.asReadOnlyBuffer();
        byte[] copy = new byte[view.remaining()];
        view.get(copy);
        return New(way, pageLevel, copy, uniqueCnt);
    }

    /**
     * Initializes a filter for a concrete probe-count implementation by
     * adopting an existing bitmap array.
     *
     * @param way the probe count, from 4 through 8
     * @param pageLevel the base-2 logarithm of the page size in bytes
     * @param data a non-empty, page-aligned bitmap that becomes the backing
     *             storage
     * @param uniqueCnt the insertion count to restore
     * @throws IllegalArgumentException if any layout parameter or the bitmap
     *                                  is invalid
     */
    protected PageBloomFilter(int way, int pageLevel, byte[] data, long uniqueCnt) {
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
        int pageNum = data.length / pageSize;
        if (pageNum >= MAX_PAGE_NUM) {
            throw new IllegalArgumentException("too many pages");
        }
        this.pageLevel = pageLevel;
        this.pageNum = pageNum;
        this.uniqueCnt = uniqueCnt;
        this.data = data;
    }

    /**
     * Removes all keys and resets the estimated unique insertion count.
     */
    public void clear() {
        uniqueCnt = 0;
        Arrays.fill(data, (byte)0);
    }

    private static int rot(int x, int k) {
        return (x << k) | (x >>> (32 - k));
    }

    // Returns true if the bit was already set, and sets it unconditionally.
    private boolean checkAndSet(int offset, int idx) {
        int pos = offset + (idx >>> 3);
        byte bit = (byte)(1 << (idx & 7));
        boolean wasSet = (data[pos] & bit) != 0;
        data[pos] |= bit;
        return wasSet;
    }

    private boolean testBit(int offset, int idx) {
        return (data[offset + (idx >>> 3)] & (byte)(1 << (idx & 7))) != 0;
    }

    /**
     * Adds a key using an explicit probe count.
     *
     * @param way the probe count used by the concrete implementation
     * @param key the key bytes
     * @return {@code true} if at least one bitmap bit changed
     * @throws NullPointerException if {@code key} is {@code null}
     */
    protected boolean set(int way, byte[] key) {
        Hash.V128 code = Hash.hash128(key);
        int w0 = (int)code.low,  w1 = (int)(code.low >>> 32);
        int w2 = (int)code.high, w3 = (int)(code.high >>> 32);
        int offset = (int)(((rot(w0, 8) ^ rot(w1, 6) ^ rot(w2, 4) ^ rot(w3, 2)) & 0xffffffffL) % pageNum) << pageLevel;
        int mask = (1 << (pageLevel+3)) - 1;
        boolean hit = checkAndSet(offset, w0 & mask)
                    & checkAndSet(offset, (w0 >>> 16) & mask)
                    & checkAndSet(offset, w1 & mask)
                    & checkAndSet(offset, (w1 >>> 16) & mask);
        if (way > 4) {
            hit &= checkAndSet(offset, w2 & mask);
            if (way > 5) {
                hit &= checkAndSet(offset, (w2 >>> 16) & mask);
                if (way > 6) {
                    hit &= checkAndSet(offset, w3 & mask);
                    if (way > 7) {
                        hit &= checkAndSet(offset, (w3 >>> 16) & mask);
                    }
                }
            }
        }
        if (hit) return false;
        uniqueCnt++;
        return true;
    }

    /**
     * Tests a key using an explicit probe count.
     *
     * @param way the probe count used by the concrete implementation
     * @param key the key bytes
     * @return {@code false} if the key is definitely absent, or {@code true}
     *         if it may be present
     * @throws NullPointerException if {@code key} is {@code null}
     */
    protected boolean test(int way, byte[] key) {
        Hash.V128 code = Hash.hash128(key);
        int w0 = (int)code.low,  w1 = (int)(code.low >>> 32);
        int w2 = (int)code.high, w3 = (int)(code.high >>> 32);
        int offset = (int)(((rot(w0, 8) ^ rot(w1, 6) ^ rot(w2, 4) ^ rot(w3, 2)) & 0xffffffffL) % pageNum) << pageLevel;
        int mask = (1 << (pageLevel+3)) - 1;
        if (!testBit(offset, w0 & mask) || !testBit(offset, (w0 >>> 16) & mask)
         || !testBit(offset, w1 & mask) || !testBit(offset, (w1 >>> 16) & mask)) return false;
        if (way > 4) {
            if (!testBit(offset, w2 & mask)) return false;
            if (way > 5) {
                if (!testBit(offset, (w2 >>> 16) & mask)) return false;
                if (way > 6) {
                    if (!testBit(offset, w3 & mask)) return false;
                    if (way > 7) {
                        if (!testBit(offset, (w3 >>> 16) & mask)) return false;
                    }
                }
            }
        }
        return true;
    }


    private static class Way4 extends PageBloomFilter {
        private static final int WAY = 4;

        public Way4(int pageLevel, int pageNum) {
            super(WAY, pageLevel, pageNum);
        }

        public Way4(int pageLevel, byte[] data, long uniqueCnt) {
            super(WAY, pageLevel, data, uniqueCnt);
        }

        @Override
        public int getWay() { return WAY; }

        @Override
        public boolean set(byte[] key) {
            return set(WAY, key);
        }

        @Override
        public boolean test(byte[] key) {
            return test(WAY, key);
        }
    }

    private static class Way5 extends PageBloomFilter {
        private static final int WAY = 5;

        public Way5(int pageLevel, int pageNum) {
            super(WAY, pageLevel, pageNum);
        }

        public Way5(int pageLevel, byte[] data, long uniqueCnt) {
            super(WAY, pageLevel, data, uniqueCnt);
        }

        @Override
        public int getWay() { return WAY; }

        @Override
        public boolean set(byte[] key) {
            return set(WAY, key);
        }

        @Override
        public boolean test(byte[] key) {
            return test(WAY, key);
        }
    }

    private static class Way6 extends PageBloomFilter {
        private static final int WAY = 6;

        public Way6(int pageLevel, int pageNum) {
            super(WAY, pageLevel, pageNum);
        }

        public Way6(int pageLevel, byte[] data, long uniqueCnt) {
            super(WAY, pageLevel, data, uniqueCnt);
        }

        @Override
        public int getWay() { return WAY; }

        @Override
        public boolean set(byte[] key) {
            return set(WAY, key);
        }

        @Override
        public boolean test(byte[] key) {
            return test(WAY, key);
        }
    }

    private static class Way7 extends PageBloomFilter {
        private static final int WAY = 7;

        public Way7(int pageLevel, int pageNum) {
            super(WAY, pageLevel, pageNum);
        }

        public Way7(int pageLevel, byte[] data, long uniqueCnt) {
            super(WAY, pageLevel, data, uniqueCnt);
        }

        @Override
        public int getWay() { return WAY; }

        @Override
        public boolean set(byte[] key) {
            return set(WAY, key);
        }

        @Override
        public boolean test(byte[] key) {
            return test(WAY, key);
        }
    }

    private static class Way8 extends PageBloomFilter {
        private static final int WAY = 8;

        public Way8(int pageLevel, int pageNum) {
            super(WAY, pageLevel, pageNum);
        }

        public Way8(int pageLevel, byte[] data, long uniqueCnt) {
            super(WAY, pageLevel, data, uniqueCnt);
        }

        @Override
        public int getWay() { return WAY; }

        @Override
        public boolean set(byte[] key) {
            return set(WAY, key);
        }

        @Override
        public boolean test(byte[] key) {
            return test(WAY, key);
        }
    }

}
