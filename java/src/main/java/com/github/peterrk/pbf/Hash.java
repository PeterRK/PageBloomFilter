// Copyright (c) 2023, Ruan Kunliang.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

package com.github.peterrk.pbf;

import java.lang.invoke.MethodHandles;
import java.lang.invoke.VarHandle;
import java.nio.ByteOrder;

class Hash {
    private static final VarHandle INT_VIEW =
            MethodHandles.byteArrayViewVarHandle(int[].class, ByteOrder.LITTLE_ENDIAN);
    private static final VarHandle LONG_VIEW =
            MethodHandles.byteArrayViewVarHandle(long[].class, ByteOrder.LITTLE_ENDIAN);

    private static long rot(long x, int k) {
        return (x << k) | (x >>> (64 - k));
    }

    private static int getInt(byte[] data, int offset) {
        return (int) INT_VIEW.get(data, offset);
    }

    private static long getLong(byte[] data, int offset) {
        return (long) LONG_VIEW.get(data, offset);
    }

    public static V128 hash128(byte[] data) {
        return hash128(data, 0);
    }

    public static V128 hash128(byte[] data, long seed) {
        long magic = 0xdeadbeefdeadbeefL;
        State s = new State(seed, seed, magic, magic);

        int len = data.length;
        int off = 0;
        while (len - off >= 32) {
            s.c += getLong(data, off);
            s.d += getLong(data, off + 8);
            s.mix();
            s.a += getLong(data, off + 16);
            s.b += getLong(data, off + 24);
            off += 32;
        }
        if (len - off >= 16) {
            s.c += getLong(data, off);
            s.d += getLong(data, off + 8);
            s.mix();
            off += 16;
        }

        s.d += ((long) len) << 56;
        switch (len & 0xf) {
            case 15:
                s.d += ((long) data[off + 14] & 0xff) << 48;
            case 14:
                s.d += ((long) data[off + 13] & 0xff) << 40;
            case 13:
                s.d += ((long) data[off + 12] & 0xff) << 32;
            case 12:
                s.c += getLong(data, off);
                s.d += getInt(data, off + 8) & 0xffffffffL;
                break;
            case 11:
                s.d += ((long) data[off + 10] & 0xff) << 16;
            case 10:
                s.d += ((long) data[off + 9] & 0xff) << 8;
            case 9:
                s.d += data[off + 8] & 0xff;
            case 8:
                s.c += getLong(data, off);
                break;
            case 7:
                s.c += ((long) data[off + 6] & 0xff) << 48;
            case 6:
                s.c += ((long) data[off + 5] & 0xff) << 40;
            case 5:
                s.c += ((long) data[off + 4] & 0xff) << 32;
            case 4:
                s.c += getInt(data, off) & 0xffffffffL;
                break;
            case 3:
                s.c += ((long) data[off + 2] & 0xff) << 16;
            case 2:
                s.c += ((long) data[off + 1] & 0xff) << 8;
            case 1:
                s.c += data[off] & 0xff;
                break;
            case 0:
                s.c += magic;
                s.d += magic;
        }
        s.end();
        return new V128(s.a, s.b);
    }

    static final class V128 {
        public final long low;
        public final long high;

        V128(long low, long high) {
            this.low = low;
            this.high = high;
        }

        @Override
        public boolean equals(Object obj) {
            if (obj == this) {
                return true;
            }
            if (!(obj instanceof V128)) {
                return false;
            }
            V128 other = (V128) obj;
            return low == other.low && high == other.high;
        }
    }

    private static final class State {
        long a;
        long b;
        long c;
        long d;

        State(long a, long b, long c, long d) {
            this.a = a;
            this.b = b;
            this.c = c;
            this.d = d;
        }

        void mix() {
            c = rot(c, 50);
            c += d;
            a ^= c;
            d = rot(d, 52);
            d += a;
            b ^= d;
            a = rot(a, 30);
            a += b;
            c ^= a;
            b = rot(b, 41);
            b += c;
            d ^= b;
            c = rot(c, 54);
            c += d;
            a ^= c;
            d = rot(d, 48);
            d += a;
            b ^= d;
            a = rot(a, 38);
            a += b;
            c ^= a;
            b = rot(b, 37);
            b += c;
            d ^= b;
            c = rot(c, 62);
            c += d;
            a ^= c;
            d = rot(d, 34);
            d += a;
            b ^= d;
            a = rot(a, 5);
            a += b;
            c ^= a;
            b = rot(b, 36);
            b += c;
            d ^= b;
        }

        void end() {
            d ^= c;
            c = rot(c, 15);
            d += c;
            a ^= d;
            d = rot(d, 52);
            a += d;
            b ^= a;
            a = rot(a, 26);
            b += a;
            c ^= b;
            b = rot(b, 51);
            c += b;
            d ^= c;
            c = rot(c, 28);
            d += c;
            a ^= d;
            d = rot(d, 9);
            a += d;
            b ^= a;
            a = rot(a, 47);
            b += a;
            c ^= b;
            b = rot(b, 54);
            c += b;
            d ^= c;
            c = rot(c, 32);
            d += c;
            a ^= d;
            d = rot(d, 25);
            a += d;
            b ^= a;
            a = rot(a, 63);
            b += a;
        }
    }
}
