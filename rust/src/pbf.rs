// Copyright (c) 2023, Ruan Kunliang.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

use crate::hash::hash128;
use std::cmp::max;

pub trait BloomFilter {
    fn get_way(&self) -> u8;
    fn get_page_level(&self) -> u8;
    fn get_page_num(&self) -> u32;
    fn get_unique_cnt(&self) -> usize;
    fn get_data(&self) -> &[u8];
    fn capacity(&self) -> usize;
    fn virtual_capacity(&self, fpr: f32) -> usize;
    fn clear(&mut self);
    fn valid(&self) -> bool;
    fn set(&mut self, key: &[u8]) -> bool;
    fn test(&self, key: &[u8]) -> bool;
}

pub const fn best_way_const(fpr: f32) -> u8 {
    let mut rate = fpr;
    if rate < 0.0005 {
        rate = 0.0005;
    } else if rate > 0.1 {
        rate = 0.1;
    }
    // Approximate ceil(log2(2 / fpr)) with integer bit checks so this stays
    // const-evaluable and matches the C++ selector.
    let mut n = (2.0 / rate) as u32;
    n += 1;

    let mut i = 1_u32;
    while i < 32 {
        if (n & (0xfffffffe_u32 << i)) == 0 {
            let way = i as u8;
            if way < 4 {
                return 4;
            }
            if way > 8 {
                return 8;
            }
            return way;
        }
        i += 1;
    }
    0
}

fn estimate_params(item: usize, fpr: f32) -> (u8, u8, u32) {
    let mut rate = fpr;
    if rate < 0.0005 {
        rate = 0.0005;
    } else if rate > 0.1 {
        rate = 0.1;
    }
    let way = best_way_const(rate);
    let w = -f32::log2(rate);
    let ln2 = f32::ln(2.0 as f32);
    let mut bpi = (w / (ln2 * 8.0)) as f64;
    if w > 9.0 {
        let x = (w - 7.0) as f64;
        bpi *= 1.0 + 0.0025*x*x;
    } else if w > 3.0 {
        bpi *= 1.01;
    }

    let n = (bpi * max(item, 1) as f64) as usize;
    let mut page_level = 0_u8;
    for i in 6..12 {
        if n < (1_usize << (i + 4)) {
            page_level = i;
            if page_level < (8 - 8/way) {
                page_level += 1;
            }
            break;
        }
    }
    if page_level == 0 {
        page_level = 12
    }

    let mut page_num = (n + (1 << page_level) - 1) >> page_level;
    if page_num == 0 {
        page_num = 1;
    }
    if page_num > 0xffffffff {
        panic!("too many items");
    }
    (way, page_level, page_num as u32)
}

pub fn new_bloom_filter(item: usize, fpr: f32) -> Box<dyn BloomFilter> {
    let (way, page_level, page_num) = estimate_params(item, fpr);
    match way {
        8 => Box::new(PageBloomFilter::<8>::new(page_level, page_num)),
        7 => Box::new(PageBloomFilter::<7>::new(page_level, page_num)),
        6 => Box::new(PageBloomFilter::<6>::new(page_level, page_num)),
        5 => Box::new(PageBloomFilter::<5>::new(page_level, page_num)),
        4 => Box::new(PageBloomFilter::<4>::new(page_level, page_num)),
        _ => panic!("no way"),
    }
}

pub fn new_pbf(way: u8, page_level: u8, page_num: u32) -> Box<dyn BloomFilter> {
    match way {
        8 => Box::new(PageBloomFilter::<8>::new(page_level, page_num)),
        7 => Box::new(PageBloomFilter::<7>::new(page_level, page_num)),
        6 => Box::new(PageBloomFilter::<6>::new(page_level, page_num)),
        5 => Box::new(PageBloomFilter::<5>::new(page_level, page_num)),
        4 => Box::new(PageBloomFilter::<4>::new(page_level, page_num)),
        _ => panic!("no way"),
    }
}

pub fn restore_pbf(way: u8, page_level: u8, data: &[u8], unique_cnt: usize) -> Box<dyn BloomFilter> {
    match way {
        8 => Box::new(PageBloomFilter::<8>::recover(page_level, data, unique_cnt)),
        7 => Box::new(PageBloomFilter::<7>::recover(page_level, data, unique_cnt)),
        6 => Box::new(PageBloomFilter::<6>::recover(page_level, data, unique_cnt)),
        5 => Box::new(PageBloomFilter::<5>::recover(page_level, data, unique_cnt)),
        4 => Box::new(PageBloomFilter::<4>::recover(page_level, data, unique_cnt)),
        _ => panic!("no way"),
    }
}

pub struct PageBloomFilter<const W : u8> {
    page_level: u8,
    page_num: u32,
    unique_cnt: usize,
    data: Vec<u8>,
}

impl<const W : u8> PageBloomFilter<W> {
    pub fn from_estimate(item: usize, fpr: f32) -> Self {
        let (way, page_level, page_num) = estimate_params(item, fpr);
        assert_eq!(W, way, "generic W does not match estimated way");
        Self::new(page_level, page_num)
    }

    pub fn new(page_level: u8, page_num: u32) -> Self {
        if W < 4 || W > 8 {
            panic!("way should be 4-8");
        }
        if page_level < (8-8/W) || page_level > 13 {
            panic!("pageLevel should be 7-13");
        }
        if page_num <= 0 {
            panic!("pageNum should be positive");
        }
        return Self {
            page_level: page_level,
            page_num: page_num,
            unique_cnt: 0,
            data: vec![0_u8; (page_num as usize) << page_level],
        };
    }

    pub fn recover(page_level: u8, data: &[u8], unique_cnt: usize) -> Self {
        if W < 4 || W > 8 {
            panic!("way should be 4-8");
        }
        if page_level < (8-8/W) || page_level > 13 {
            panic!("pageLevel should be 7-13");
        }
        let page_size = 1_usize << page_level;
        if data.len() == 0 || data.len()%page_size != 0 {
            panic!("illegal data size");
        }
        let page_num = data.len() / page_size;
        if page_num > 0xffffffff {
            panic!("too big data");
        }
        return Self {
            page_level: page_level,
            page_num: page_num as u32,
            unique_cnt: unique_cnt,
            data: data.to_vec(),
        };
    }
}

#[inline(always)]
fn rot(x: u32, k: u8) -> u32 {
    return (x << k) | (x >> (32 - k));
}

#[inline(always)]
fn page_hash(key: &[u8]) -> (u32, [u32; 4]) {
    let code = hash128(key);
    let w = [
        code[0] as u32, (code[0] >> 32) as u32,
        code[1] as u32, (code[1] >> 32) as u32,
    ];
    return (rot(w[0], 8) ^ rot(w[1], 6) ^ rot(w[2], 4) ^ rot(w[3], 2), w)
}

#[inline(always)]
fn page_mask(page_level: u8) -> u16 {
    ((1_u32 << (page_level + 3)) - 1) as u16
}

#[inline(always)]
fn set_slot(data: &mut [u8], off: usize, mask: u16, word: u32, shift: u32, hit: &mut u8) {
    let idx = ((word >> shift) as u16) & mask;
    let byte = off + (idx >> 3) as usize;
    let bit = 1_u8 << (idx & 7);
    *hit &= data[byte] >> (idx & 7);
    data[byte] |= bit;
}

#[inline(always)]
fn test_slot(data: &[u8], off: usize, mask: u16, word: u32, shift: u32) -> bool {
    let idx = ((word >> shift) as u16) & mask;
    let bit = 1_u8 << (idx & 7);
    (data[off + (idx >> 3) as usize] & bit) != 0
}

macro_rules! impl_bloom_filter {
    ($w:literal, $(($word:literal, $shift:literal)),+ $(,)?) => {
        impl BloomFilter for PageBloomFilter<$w> {
            fn get_way(&self) -> u8 {
                $w
            }

            fn get_page_level(&self) -> u8 {
                self.page_level
            }

            fn get_page_num(&self) -> u32 {
                self.page_num
            }

            fn get_unique_cnt(&self) -> usize {
                self.unique_cnt
            }

            fn get_data(&self) -> &[u8] {
                &self.data
            }

            fn capacity(&self) -> usize {
                self.data.len() * 8 / $w as usize
            }

            fn virtual_capacity(&self, fpr: f32) -> usize {
                let t = f64::ln_1p(-f64::powf(fpr as f64, 1.0 / $w as f64)) /
                    f64::ln_1p(-1.0 / (self.data.len() * 8) as f64);
                t as usize / $w as usize
            }

            fn clear(&mut self) {
                self.unique_cnt = 0;
                self.data.fill(0_u8);
            }

            fn valid(&self) -> bool {
                !self.data.is_empty()
            }

            fn set(&mut self, key: &[u8]) -> bool {
                let (code, words) = page_hash(key);
                let off = ((code % self.page_num) as usize) << self.page_level;
                let mask = page_mask(self.page_level);
                let mut hit = 1_u8;
                $(set_slot(&mut self.data, off, mask, words[$word], $shift, &mut hit);)+
                if hit != 0 {
                    return false;
                }
                self.unique_cnt += 1;
                true
            }

            fn test(&self, key: &[u8]) -> bool {
                let (code, words) = page_hash(key);
                let off = ((code % self.page_num) as usize) << self.page_level;
                let mask = page_mask(self.page_level);
                $(if !test_slot(&self.data, off, mask, words[$word], $shift) {
                    return false;
                })+
                true
            }
        }
    };
}

impl_bloom_filter!(4, (0, 0), (0, 16), (1, 0), (1, 16));
impl_bloom_filter!(5, (0, 0), (0, 16), (1, 0), (1, 16), (2, 0));
impl_bloom_filter!(6, (0, 0), (0, 16), (1, 0), (1, 16), (2, 0), (2, 16));
impl_bloom_filter!(7, (0, 0), (0, 16), (1, 0), (1, 16), (2, 0), (2, 16), (3, 0));
impl_bloom_filter!(8, (0, 0), (0, 16), (1, 0), (1, 16), (2, 0), (2, 16), (3, 0), (3, 16));
