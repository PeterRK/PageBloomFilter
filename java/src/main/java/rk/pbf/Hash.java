// Copyright (c) 2023, Ruan Kunliang.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

package rk.pbf;

import java.nio.ByteBuffer;
import java.nio.ByteOrder;

public class Hash {
    public static final class V128 {
        public long low = 0;
        public long high = 0;

        V128(long low, long high) {
            this.low = low;
            this.high = high;
        }

        @Override
        public boolean equals(Object obj) {
            if(obj == this) {
                return true;
            }
            if(!(obj instanceof V128)) {
                return false;
            }
            V128 other = (V128)obj;
            return low == other.low && high == other.high;
        }
    }


    private static long rot(long x, int k)  {
        return (x << k) | (x >>> (64 - k));
    }
    private static final class State {
        long a = 0;
        long b = 0;
        long c = 0;
        long d = 0;

        State(long a, long b, long c, long d) {
            this.a = a;
            this.b = b;
            this.c = c;
            this.d = d;
        }

        void mix() {
            c = rot(c,50);  c += d;  a ^= c;
            d = rot(d,52);  d += a;  b ^= d;
            a = rot(a,30);  a += b;  c ^= a;
            b = rot(b,41);  b += c;  d ^= b;
            c = rot(c,54);  c += d;  a ^= c;
            d = rot(d,48);  d += a;  b ^= d;
            a = rot(a,38);  a += b;  c ^= a;
            b = rot(b,37);  b += c;  d ^= b;
            c = rot(c,62);  c += d;  a ^= c;
            d = rot(d,34);  d += a;  b ^= d;
            a = rot(a,5);   a += b;  c ^= a;
            b = rot(b,36);  b += c;  d ^= b;
        }

        void end() {
            d ^= c;  c = rot(c,15);  d += c;
            a ^= d;  d = rot(d,52);  a += d;
            b ^= a;  a = rot(a,26);  b += a;
            c ^= b;  b = rot(b,51);  c += b;
            d ^= c;  c = rot(c,28);  d += c;
            a ^= d;  d = rot(d,9);   a += d;
            b ^= a;  a = rot(a,47);  b += a;
            c ^= b;  b = rot(b,54);  c += b;
            d ^= c;  c = rot(c,32);  d += c;
            a ^= d;  d = rot(d,25);  a += d;
            b ^= a;  a = rot(a,63);  b += a;
        }
    }

    public static V128 hash128(byte[] key) {
        long magic = 0xdeadbeefdeadbeefL;
        State s = new State(0, 0, magic, magic);

        ByteBuffer buf = ByteBuffer.wrap(key);
        buf.order(ByteOrder.LITTLE_ENDIAN);
        while (buf.remaining() >= 32) {
            s.c += buf.getLong();
            s.d += buf.getLong();
            s.mix();
            s.a += buf.getLong();
            s.b += buf.getLong();
        }
        if (buf.remaining() >= 16) {
            s.c += buf.getLong();
            s.d += buf.getLong();
            s.mix();
        }

        s.d += ((long)key.length) << 56;
        int off = key.length & ~0xf;
        switch (key.length & 0xf) {
            case 15:
                s.d += ((long)key[off+14]) << 48;
            case 14:
                s.d += ((long)key[off+13]) << 40;
            case 13:
                s.d += ((long)key[off+12]) << 32;
            case 12:
                s.c += buf.getLong();
                s.d += buf.getInt();
                break;
            case 11:
                s.d += ((long)key[off+10]) << 16;
            case 10:
                s.d += ((long)key[off+9]) << 8;
            case 9:
                s.d += key[off+8];
            case 8:
                s.c += buf.getLong();
                break;
            case 7:
                s.c += ((long)key[off+6]) << 48;
            case 6:
                s.c += ((long)key[off+5]) << 40;
            case 5:
                s.c += ((long)key[off+4]) << 32;
            case 4:
                s.c += buf.getInt();
                break;
            case 3:
                s.c += ((long)key[off+2]) << 16;
            case 2:
                s.c += ((long)key[off+1]) << 8;
            case 1:
                s.c += key[off];
                break;
            case 0:
                s.c += magic;
                s.d += magic;
        }
        s.end();
        return new V128(s.a, s.b);
    }

    public static long hash64(byte[] key) {
        return hash128(key).low;
    }

    public static int hash32(byte[] key) {
        return (int)hash64(key);
    }
}
