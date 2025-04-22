// Copyright (c) 2023, Ruan Kunliang.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

namespace PageBloomFilter {
    public abstract class PageBloomFilter {
        private readonly int pageLevel = 0;
        private readonly uint pageNum = 0;
        private long uniqueCnt = 0;
        private readonly byte[] data;

        public abstract int Way { get; }
        public int PageLevel { get => pageLevel; }
        public uint PageNum { get => pageNum; }

        public long UniqueCnt { get => uniqueCnt; }
        public byte[] Data { get => data; }

        public long Capacity {
            get => data.LongLength * 8 / Way;
        }
        public long VirtualCapacity(double falsePositiveRate) {
            var t = Math.Log(1.0 - Math.Pow(falsePositiveRate, 1.0 / Way))
                / Math.Log(1.0 - 1.0 / (data.LongLength * 8));
            return (long)t / Way;
        }

        public abstract bool Set(ReadOnlySpan<byte> key);
        public abstract bool Test(ReadOnlySpan<byte> key);

        public static PageBloomFilter New(long item, double falsePositiveRate) {
            if (item < 1) {
                item = 1;
            }
            if (falsePositiveRate > 0.1) {
                falsePositiveRate = 0.1;
            } else if (falsePositiveRate < 0.0005) {
                falsePositiveRate = 0.0005;
            }
            var w = -Math.Log2(falsePositiveRate);
            var bytesPerItem = w / (Math.Log(2) * 8);
            if (w > 9) {
                var x = w - 7;
                bytesPerItem *= 1 + 0.0025*x*x;
            } else if (w > 3) {
                bytesPerItem *= 1.01;
            }
            var way = (int)Math.Round(w);
            if (way < 4) {
                way = 4;
            } else if (way > 8) {
                way = 8;
            }

            var n = (long)(bytesPerItem * item);
            int pageLevel = 0;
            for (int i = 6; i < 12; i++) {
                if (n < (1U << (i + 4))) {
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
            return New(way, pageLevel, (uint)pageNum);
        }

        public static PageBloomFilter New(int way, int pageLevel, uint pageNum) =>
        	way switch {
        		4 => new PageBloomFilter.Way4(pageLevel, pageNum),
        		5 => new PageBloomFilter.Way5(pageLevel, pageNum),
        		6 => new PageBloomFilter.Way6(pageLevel, pageNum),
        		7 => new PageBloomFilter.Way7(pageLevel, pageNum),
        		8 => new PageBloomFilter.Way8(pageLevel, pageNum),
        		_ => throw new ArgumentException("illegal way"),
        	};

        protected PageBloomFilter(int way, int pageLevel, uint pageNum) {
            if (way < 4 || way > 8) {
                throw new ArgumentException("way should be 4-8");
            }
            if (pageLevel < (8 - 8 / way) || pageLevel > 13) {
                throw new ArgumentException("pageLevel should be 7-13");
            }
            if (pageNum <= 0) {
                throw new ArgumentException("pageNum should be positive");
            }

            this.pageLevel = pageLevel;
            this.pageNum = pageNum;
            this.uniqueCnt = 0;
            this.data = new byte[pageNum << pageLevel];
        }

        public static PageBloomFilter New(int way, int pageLevel, ReadOnlySpan<byte> data, long uniqueCnt) =>
            way switch {
                4 => new PageBloomFilter.Way4(pageLevel, data, uniqueCnt),
                5 => new PageBloomFilter.Way5(pageLevel, data, uniqueCnt),
                6 => new PageBloomFilter.Way6(pageLevel, data, uniqueCnt),
                7 => new PageBloomFilter.Way7(pageLevel, data, uniqueCnt),
                8 => new PageBloomFilter.Way8(pageLevel, data, uniqueCnt),
                _ => throw new ArgumentException("illegal way"),
            };

        protected PageBloomFilter(int way, int pageLevel, ReadOnlySpan<byte> data, long uniqueCnt) {
            if (way < 4 || way > 8) {
                throw new ArgumentException("way should be 4-8");
            }
            if (pageLevel < (8 - 8 / way) || pageLevel > 13) {
                throw new ArgumentException("pageLevel should be 7-13");
            }
            int pageSize = 1 << pageLevel;
            if (data.Length == 0 || data.Length % pageSize != 0) {
                throw new ArgumentException("illegal data size");
            }
            this.pageLevel = pageLevel;
            this.pageNum = (uint)(data.Length / pageSize);
            this.uniqueCnt = uniqueCnt;
            this.data = new byte[data.Length];
            data.CopyTo(this.data);
        }

        public void Clear() {
            Array.Clear(data, 0, data.Length);
        }

        private static uint Rot(uint x, int k) {
            return (x << k) | (x >> (32 - k));
        }

        private struct HashResult {
            public uint offset;
            public uint[] codes;
            public HashResult() {
                offset = 0;
                codes = new uint[8];
            }
        }
        private HashResult PageHash(ReadOnlySpan<byte> key) {
            var code = Hash.Hash128(key);
            var w0 = (uint)code.low;
            var w1 = (uint)(code.low >> 32);
            var w2 = (uint)code.high;
            var w3 = (uint)(code.high >> 32);
            var ret = new HashResult();
            var x = Rot(w0, 8) ^ Rot(w1, 6) ^ Rot(w2, 4) ^ Rot(w3, 2);
            ret.offset = x % pageNum;
            ret.offset <<= pageLevel;
            ret.codes[0] = w0 & 0xffff;
            ret.codes[1] = w0 >> 16;
            ret.codes[2] = w1 & 0xffff;
            ret.codes[3] = w1 >> 16;
            ret.codes[4] = w2 & 0xffff;
            ret.codes[5] = w2 >> 16;
            ret.codes[6] = w3 & 0xffff;
            ret.codes[7] = w3 >> 16;
            return ret;
        }

        protected bool Set(int way, ReadOnlySpan<byte> key) {
            var h = PageHash(key);
            uint mask = (1U << (pageLevel + 3)) - 1U;
            int hit = 1;
            for (int i = 0; i < way; i++) {
                uint idx = h.codes[i] & mask;
                byte bit = (byte)(1u << (int)(idx & 7));
                hit &= data[h.offset + (idx >> 3)] >> (int)(idx & 7);
                data[h.offset + (idx >> 3)] |= bit;
            }
            if (hit != 0) {
                return false;
            }
            uniqueCnt++;
            return true;
        }

        protected bool Test(int way, ReadOnlySpan<byte> key) {
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


        private sealed class Way4 : PageBloomFilter {
            private const int WAY = 4;
            public Way4(int pageLevel, uint pageNum)
                : base(WAY, pageLevel, pageNum) {}
            public Way4(int pageLevel, ReadOnlySpan<byte> data, long uniqueCnt)
                : base(WAY, pageLevel, data, uniqueCnt) {}
            public override int Way { get => WAY; }
            public override bool Set(ReadOnlySpan<byte> key) { return Set(WAY, key); }
            public override bool Test(ReadOnlySpan<byte> key) { return Test(WAY, key); }
        }

        private sealed class Way5 : PageBloomFilter {
            private const int WAY = 5;
            public Way5(int pageLevel, uint pageNum)
                : base(WAY, pageLevel, pageNum) {}
            public Way5(int pageLevel, ReadOnlySpan<byte> data, long uniqueCnt)
                : base(WAY, pageLevel, data, uniqueCnt) {}
            public override int Way { get => WAY; }
            public override bool Set(ReadOnlySpan<byte> key) { return Set(WAY, key); }
            public override bool Test(ReadOnlySpan<byte> key) { return Test(WAY, key); }
        }

        private sealed class Way6 : PageBloomFilter {
            private const int WAY = 6;
            public Way6(int pageLevel, uint pageNum)
                : base(WAY, pageLevel, pageNum) {}
            public Way6(int pageLevel, ReadOnlySpan<byte> data, long uniqueCnt)
                : base(WAY, pageLevel, data, uniqueCnt) {}
            public override int Way { get => WAY; }
            public override bool Set(ReadOnlySpan<byte> key) { return Set(WAY, key); }
            public override bool Test(ReadOnlySpan<byte> key) { return Test(WAY, key); }
        }

        private sealed class Way7 : PageBloomFilter {
            private const int WAY = 7;
            public Way7(int pageLevel, uint pageNum)
                : base(WAY, pageLevel, pageNum) {}
            public Way7(int pageLevel, ReadOnlySpan<byte> data, long uniqueCnt)
                : base(WAY, pageLevel, data, uniqueCnt) {}
            public override int Way { get => WAY; }
            public override bool Set(ReadOnlySpan<byte> key) { return Set(WAY, key); }
            public override bool Test(ReadOnlySpan<byte> key) { return Test(WAY, key); }
        }

        private sealed class Way8 : PageBloomFilter {
            private const int WAY = 8;
            public Way8(int pageLevel, uint pageNum)
                : base(WAY, pageLevel, pageNum) {}
            public Way8(int pageLevel, ReadOnlySpan<byte> data, long uniqueCnt)
                : base(WAY, pageLevel, data, uniqueCnt) {}
            public override int Way { get => WAY; }
            public override bool Set(ReadOnlySpan<byte> key) { return Set(WAY, key); }
            public override bool Test(ReadOnlySpan<byte> key) { return Test(WAY, key); }
        }
    }
}
