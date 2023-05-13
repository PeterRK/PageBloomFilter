// Copyright (c) 2023, Ruan Kunliang.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

use std::num::Wrapping;

#[inline(always)]
fn rot(x: Wrapping<u64>, k: u8) -> Wrapping<u64> {
    return Wrapping((x.0 << k) | (x.0 >> (64 - k)));
}

struct State {
    a: Wrapping<u64>,
    b: Wrapping<u64>,
    c: Wrapping<u64>,
    d: Wrapping<u64>,
}

impl State {
    #[inline(always)]
    pub fn mix(&mut self) {
        self.c = rot(self.c,50);  self.c += self.d;  self.a ^= self.c;
        self.d = rot(self.d,52);  self.d += self.a;  self.b ^= self.d;
        self.a = rot(self.a,30);  self.a += self.b;  self.c ^= self.a;
        self.b = rot(self.b,41);  self.b += self.c;  self.d ^= self.b;
        self.c = rot(self.c,54);  self.c += self.d;  self.a ^= self.c;
        self.d = rot(self.d,48);  self.d += self.a;  self.b ^= self.d;
        self.a = rot(self.a,38);  self.a += self.b;  self.c ^= self.a;
        self.b = rot(self.b,37);  self.b += self.c;  self.d ^= self.b;
        self.c = rot(self.c,62);  self.c += self.d;  self.a ^= self.c;
        self.d = rot(self.d,34);  self.d += self.a;  self.b ^= self.d;
        self.a = rot(self.a,5);   self.a += self.b;  self.c ^= self.a;
        self.b = rot(self.b,36);  self.b += self.c;  self.d ^= self.b;
    }

    #[inline(always)]
    pub fn end(&mut self) {
        self.d ^= self.c;  self.c = rot(self.c,15);  self.d += self.c;
        self.a ^= self.d;  self.d = rot(self.d,52);  self.a += self.d;
        self.b ^= self.a;  self.a = rot(self.a,26);  self.b += self.a;
        self.c ^= self.b;  self.b = rot(self.b,51);  self.c += self.b;
        self.d ^= self.c;  self.c = rot(self.c,28);  self.d += self.c;
        self.a ^= self.d;  self.d = rot(self.d,9);   self.a += self.d;
        self.b ^= self.a;  self.a = rot(self.a,47);  self.b += self.a;
        self.c ^= self.b;  self.b = rot(self.b,54);  self.c += self.b;
        self.d ^= self.c;  self.c = rot(self.c,32);  self.d += self.c;
        self.a ^= self.d;  self.d = rot(self.d,25);  self.a += self.d;
        self.b ^= self.a;  self.a = rot(self.a,63);  self.b += self.a;
    }
}

#[inline(always)]
fn u64to64(data: &[u8]) -> u64 {
    return u64::from_le_bytes(data.try_into().unwrap());
}

#[inline(always)]
fn u32to64(data: &[u8]) -> u64 {
    return u32::from_le_bytes(data.try_into().unwrap()) as u64;
}

#[inline(always)]
fn u16to64(data: &[u8]) -> u64 {
    return u16::from_le_bytes(data.try_into().unwrap()) as u64;
}

pub fn hash128(msg: &[u8]) -> [u64; 2] {
    let magic  = Wrapping(0xdeadbeefdeadbeef_u64);
    let mut s = State {a: Wrapping(0_u64), b: Wrapping(0_u64), c: magic, d: magic};

    let mut off = 0_usize;
    while off < (msg.len() & !0x1f_usize) {
        s.c += u64to64(&msg[off .. off+8]);
        s.d += u64to64(&msg[off+8 .. off+16]);
        s.mix();
        s.a += u64to64(&msg[off+16 .. off+24]);
        s.b += u64to64(&msg[off+24 .. off+32]);
        off += 32;
    }
    if msg.len() - off >= 16 {
        s.c += u64to64(&msg[off .. off+8]);
        s.d += u64to64(&msg[off+8 .. off+16]);
        s.mix();
        off += 16;
    }

    s.d += (msg.len() as u64) << 56;
    match msg.len() & 0xf_usize {
        15 => {
            s.c += u64to64(&msg[off .. off+8]);
            s.d += ((msg[off+14] as u64) << 48)
                | (u16to64(&msg[off+12 .. off+14]) << 32)
                | u32to64(&msg[off+8 .. off+12]);
        },
        14 => {
            s.c += u64to64(&msg[off .. off+8]);
            s.d += (u16to64(&msg[off+12 .. off+14]) << 32)
                | u32to64(&msg[off+8 .. off+12]);
        },
        13 => {
            s.c += u64to64(&msg[off .. off+8]);
            s.d += ((msg[off+12] as u64) << 32) | u32to64(&msg[off+8 .. off+12]);
        },
        12 => {
            s.c += u64to64(&msg[off .. off+8]);
            s.d += u32to64(&msg[off+8 .. off+12]);
        },
        11 => {
            s.c += u64to64(&msg[off .. off+8]);
            s.d += ((msg[off+10] as u64) << 16) | u16to64(&msg[off+8 .. off+10]);
        },
        10 => {
            s.c += u64to64(&msg[off .. off+8]);
            s.d += u16to64(&msg[off+8 .. off+10]);
        },
        9 => {
            s.c += u64to64(&msg[off .. off+8]);
            s.d += msg[off+8] as u64;
        },
        8 => {
            s.c += u64to64(&msg[off .. off+8]);
        },
        7 => {
            s.c += ((msg[off+6] as u64) << 48)
                | (u16to64(&msg[off+4 .. off+6]) << 32)
                | u32to64(&msg[off .. off+4]);
        },
        6 => {
            s.c += (u16to64(&msg[off+4 .. off+6]) << 32)
                | u32to64(&msg[off .. off+4]);
        },
        5 => {
            s.c += ((msg[off+4] as u64) << 32) | u32to64(&msg[off .. off+4]);
        },
        4 => {
            s.c += u32to64(&msg[off .. off+4]);
        },
        3 => {
            s.c += ((msg[off+2] as u64) << 16) | u16to64(&msg[off .. off+2]);
        },
        2 => {
            s.c += u16to64(&msg[off .. off+2]);
        },
        1 => {
            s.c += msg[off] as u64;
        },
        0 => {
            s.c += magic;
            s.d += magic;
        },
        _ => {}
    }
    s.end();
    return [s.a.0, s.b.0];
}