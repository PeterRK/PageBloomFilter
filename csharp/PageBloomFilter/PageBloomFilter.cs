// Copyright (c) 2023, Ruan Kunliang.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

namespace PageBloomFilter {
    public class PageBloomFilter {
        private int way = 0;
        private int pageLevel = 0;
        private uint pageNum = 0;
        private long uniqueCnt = 0;
        private byte[] data;

        public int Way { get { return way; } }
        public int PageLevel { get { return pageLevel; } }
        public uint PageNum { get { return pageNum; } }

        public long UniqueCnt { get { return uniqueCnt; } }
        public byte[] Data { get { return data; } }

        public static PageBloomFilter New(long item, double falsePositiveRate) {
            if (item < 1) {
                item = 1;
            }
            if (falsePositiveRate > 0.1) {
                falsePositiveRate = 0.1;
            } else if (falsePositiveRate < 0.0005) {
                falsePositiveRate = 0.0005;
            }
            double w = -Math.Log2(falsePositiveRate);
            double bytesPerItem = w / (Math.Log(2) * 8);
            int way = (int)Math.Round(w);
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
            for (int i = 6; i < 12; i++) {
                if (n < (1U << (i + 2))) {
                    pageLevel = i;
                    if (pageLevel < (8 - 8 / way)) {
                        pageLevel++;
                    }
                    break;
                }
            }
            if (pageLevel == 0) {
                pageLevel = 12;
            }

            long pageNum = (n + (1L << pageLevel) - 1L) >> pageLevel;
            if (pageNum > Int32.MaxValue) {
                throw new ArgumentException("too many items");
            }
            return new PageBloomFilter(way, pageLevel, (uint)pageNum);
        }

        public PageBloomFilter(int way, int pageLevel, uint pageNum) {
            if (way < 4 || way > 8) {
                throw new ArgumentException("way should be 4-8");
            }
            if (pageLevel < (8 - 8 / way) || pageLevel > 13) {
                throw new ArgumentException("pageLevel should be 7-13");
            }
            if (pageNum <= 0) {
                throw new ArgumentException("pageNum should be positive");
            }

            this.way = way;
            this.pageLevel = pageLevel;
            this.pageNum = pageNum;
            this.uniqueCnt = 0;
            this.data = new byte[pageNum << pageLevel];
        }

        public PageBloomFilter(int way, int pageLevel, byte[] data, long uniqueCnt) {
            if (way < 4 || way > 8) {
                throw new ArgumentException("way should be 4-8");
            }
            if (pageLevel < (8 - 8 / way) || pageLevel > 13) {
                throw new ArgumentException("pageLevel should be 7-13");
            }
            int pageSize = 1 << pageLevel;
            if (data == null || data.Length == 0 || data.Length % pageSize != 0) {
                throw new ArgumentException("illegal data size");
            }
            this.way = way;
            this.pageLevel = pageLevel;
            this.pageNum = (uint)(data.Length / pageSize);
            this.uniqueCnt = uniqueCnt;
            this.data = (byte[])data.Clone();
        }

        public void Clear() {
            Array.Clear(data, 0, data.Length);
        }

        private static uint Rot(uint x, int k) {
            return (x << k) | (x >>> (32 - k));
        }

        struct HashResult {
            public uint offset;
            public uint[] codes;
            public HashResult() {
                offset = 0;
                codes = new uint[8];
            }
        }
        private HashResult PageHash(byte[] key) {
            var code = Hash.Hash128(key);
            uint w0 = (uint)code.low;
            uint w1 = (uint)(code.low >> 32);
            uint w2 = (uint)code.high;
            uint w3 = (uint)(code.high >>> 32);
            var ret = new HashResult();
            long x = Rot(w0, 8) ^ Rot(w1, 6) ^ Rot(w2, 4) ^ Rot(w3, 2);
            ret.offset = (uint)((x & 0xffffffff) % pageNum);
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

        public bool Set(byte[] key) {
            var h = PageHash(key);
            uint mask = (1U << (pageLevel + 3)) - 1U;
            int hit = 1;
            for (int i = 0; i < way; i++) {
                uint idx = h.codes[i] & mask;
                byte bit = (byte)(1u << (int)(idx & 7));
                hit &= data[h.offset + (idx >> 3)] >> (int)(idx & 7);
                data[h.offset + (idx >>> 3)] |= bit;
            }
            if (hit != 0) {
                return false;
            }
            uniqueCnt++;
            return true;
        }

        public bool Test(byte[] key) {
            var h = PageHash(key);
            uint mask = (1U << (pageLevel + 3)) - 1U;
            for (int i = 0; i < way; i++) {
                uint idx = h.codes[i] & mask;
                byte bit = (byte)(1U << (int)(idx & 7));
                if ((data[h.offset + (idx >> 3)] & bit) == 0) {
                    return false;
                }
            }
            return true;
        }
    }
}
