// Copyright (c) 2023, Ruan Kunliang.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

namespace PageBloomFilter {
    public class Hash {
        public struct V128 {
            public ulong low;
            public ulong high;
            public V128(ulong low, ulong high) {
                this.low = low;
                this.high = high;
            }
        }

        static Hash() {
            System.Diagnostics.Trace.Assert(BitConverter.IsLittleEndian);
        }

        private static ulong Rot(ulong x, int k) {
            return (x << k) | (x >>> (64 - k));
        }
        private struct State {
            public ulong a, b, c, d;

            public State(ulong a, ulong b, ulong c, ulong d) {
                this.a = a;
                this.b = b;
                this.c = c;
                this.d = d;
            }

            public void Mix() {
                c = Rot(c, 50); c += d; a ^= c;
                d = Rot(d, 52); d += a; b ^= d;
                a = Rot(a, 30); a += b; c ^= a;
                b = Rot(b, 41); b += c; d ^= b;
                c = Rot(c, 54); c += d; a ^= c;
                d = Rot(d, 48); d += a; b ^= d;
                a = Rot(a, 38); a += b; c ^= a;
                b = Rot(b, 37); b += c; d ^= b;
                c = Rot(c, 62); c += d; a ^= c;
                d = Rot(d, 34); d += a; b ^= d;
                a = Rot(a, 5); a += b; c ^= a;
                b = Rot(b, 36); b += c; d ^= b;
            }

            public void End() {
                d ^= c; c = Rot(c, 15); d += c;
                a ^= d; d = Rot(d, 52); a += d;
                b ^= a; a = Rot(a, 26); b += a;
                c ^= b; b = Rot(b, 51); c += b;
                d ^= c; c = Rot(c, 28); d += c;
                a ^= d; d = Rot(d, 9); a += d;
                b ^= a; a = Rot(a, 47); b += a;
                c ^= b; b = Rot(b, 54); c += b;
                d ^= c; c = Rot(c, 32); d += c;
                a ^= d; d = Rot(d, 25); a += d;
                b ^= a; a = Rot(a, 63); b += a;
            }
        }

        public static V128 Hash128(byte[] key) {
            ulong magic = 0xdeadbeefdeadbeefUL;
            var s = new State(0, 0, magic, magic);

            int off = 0;
            for (int end = key.Length & ~0x1f; off < end; off += 32) {
                s.c += BitConverter.ToUInt64(key, off);
                s.d += BitConverter.ToUInt64(key, off + 8);
                s.Mix();
                s.a += BitConverter.ToUInt64(key, off + 16);
                s.b += BitConverter.ToUInt64(key, off + 24);
            }
            if (key.Length - off >= 16) {
                s.c += BitConverter.ToUInt64(key, off);
                s.d += BitConverter.ToUInt64(key, off + 8);
                s.Mix();
                off += 16;
            }

            s.d += ((ulong)key.Length) << 56;
            switch (key.Length & 0xf) {
                case 15:
                    s.d += ((ulong)key[off + 14]) << 48;
                    goto case 14;
                case 14:
                    s.d += ((ulong)key[off + 13]) << 40;
                    goto case 13;
                case 13:
                    s.d += ((ulong)key[off + 12]) << 32;
                    goto case 12;
                case 12:
                    s.d += BitConverter.ToUInt32(key, off + 8);
                    s.c += BitConverter.ToUInt64(key, off);
                    break;
                case 11:
                    s.d += ((ulong)key[off + 10]) << 16;
                    goto case 10;
                case 10:
                    s.d += ((ulong)key[off + 9]) << 8;
                    goto case 9;
                case 9:
                    s.d += key[off + 8];
                    goto case 8;
                case 8:
                    s.c += BitConverter.ToUInt64(key, off);
                    break;
                case 7:
                    s.c += ((ulong)key[off + 6]) << 48;
                    goto case 6;
                case 6:
                    s.c += ((ulong)key[off + 5]) << 40;
                    goto case 5;
                case 5:
                    s.c += ((ulong)key[off + 4]) << 32;
                    goto case 4;
                case 4:
                    s.c += BitConverter.ToUInt32(key, off);
                    break;
                case 3:
                    s.c += ((ulong)key[off + 2]) << 16;
                    goto case 2;
                case 2:
                    s.c += ((ulong)key[off + 1]) << 8;
                    goto case 1;
                case 1:
                    s.c += key[off];
                    break;
                case 0:
                    s.c += magic;
                    s.d += magic;
                    break;
            }
            s.End();
            return new V128(s.a, s.b);
        }

        public static ulong Hash64(byte[] key) {
            return Hash128(key).low;
        }

        public static uint Hash32(byte[] key) {
            return (uint)Hash64(key);
        }
    }
}