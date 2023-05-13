// Copyright (c) 2023, Ruan Kunliang.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

use crate::hash::hash128;
use std::cmp::min;
use std::cmp::max;

pub trait BloomFilter {
    fn get_way(&self) -> u8;
    fn get_page_level(&self) -> u8;
    fn get_page_num(&self) -> u32;
    fn get_unique_cnt(&self) -> usize;
    fn get_data(&self) -> &Vec<u8>;
    fn clear(&mut self);
    fn valid(&self) -> bool;
    fn set(&mut self, key: &[u8]) -> bool;
    fn test(&self, key: &[u8]) -> bool;
}

pub fn new_bloom_filter(item: usize, fpr: f32) -> Box<dyn BloomFilter> {
    let mut rate = fpr;
    if rate < 0.0005 {
        rate = 0.0005;
    } else if rate > 0.1 {
        rate = 0.1;
    }
    let w = -f32::log2(rate);
    let ln2 = f32::ln(2.0 as f32);
    let mut bpi = (w / (ln2 * 8.0)) as f64;
    if w > 8.0 {
        bpi *= 1.025;
    } else if w > 4.0 {
        bpi *= 1.01;
    }
    let way = min(max(f32::round(w) as u8, 4), 8);

    let n = (bpi * max(item, 1) as f64) as usize;
    let mut page_level = 0_u8;
    for i in 6..12 {
        if n < (1_usize << (i + 2)) {
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

    let page_num = (n + (1 << page_level) - 1) >> page_level;
    if page_num > 0xffffffff {
        panic!("too many items");
    }

    match way {
        8 => Box::new(PageBloomFilter::<8>::new(page_level, page_num as u32)),
        7 => Box::new(PageBloomFilter::<7>::new(page_level, page_num as u32)),
        6 => Box::new(PageBloomFilter::<6>::new(page_level, page_num as u32)),
        5 => Box::new(PageBloomFilter::<5>::new(page_level, page_num as u32)),
        4 => Box::new(PageBloomFilter::<4>::new(page_level, page_num as u32)),
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

pub fn recover_pbf(way: u8, page_level: u8, data: &Vec<u8>, unique_cnt: usize) -> Box<dyn BloomFilter> {
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

impl<const W : u8> BloomFilter for PageBloomFilter<W> {
    fn get_way(&self) -> u8 {
        return W;
    }
    fn get_page_level(&self) -> u8 {
        return self.page_level;
    }
    fn get_page_num(&self) -> u32 {
        return self.page_num;
    }
    fn get_unique_cnt(&self) -> usize {
        return self.unique_cnt;
    }
    fn get_data(&self) -> &Vec<u8> {
        return &self.data;
    }

    fn clear(&mut self) {
        self.data.fill(0_u8);
    }
    fn valid(&self) -> bool {
        return self.data.len() != 0;
    }

    fn set(&mut self, key: &[u8]) -> bool {
        let (code, v) = page_hash(key);
        let off = ((code % self.page_num) as usize) << self.page_level;
        let mut hit = 1_u8;
        let mask = ((1 << (self.page_level + 3)) - 1) as u16;
        for i in 0..W {
            let idx = v[i as usize] & mask;
            let bit = 1_u8 << (idx & 7);
            hit &= self.data[off+(idx>>3) as usize] >> (idx & 7);
            self.data[off+(idx>>3) as usize] |= bit;
        }
        if hit != 0 {
            return false;
        }
        self.unique_cnt += 1;
        return true;
    }

    fn test(&self, key: &[u8]) -> bool {
        let (code, v) = page_hash(key);
        let off = ((code % self.page_num) as usize) << self.page_level;

        let mask = ((1 << (self.page_level + 3)) - 1) as u16;
        for i in 0..W {
            let idx = v[i as usize] & mask;
            let bit = 1_u8 << (idx & 7);
            if (self.data[off+(idx>>3) as usize] & bit) == 0 {
                return false;
            }
        }
        return true;
    }
}

impl<const W : u8> PageBloomFilter<W> {
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

    pub fn recover(page_level: u8, data: &Vec<u8>, unique_cnt: usize) -> Self {
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
            data: data.clone(),
        };
    }
}

#[inline(always)]
fn rot(x: u32, k: u8) -> u32 {
    return (x << k) | (x >> (32 - k));
}

#[inline(always)]
fn page_hash(key: &[u8]) -> (u32, [u16; 8]) {
    let code = hash128(key);
    let w = [
        code[0] as u32, (code[0] >> 32) as u32,
        code[1] as u32, (code[1] >> 32) as u32,
    ];
    return (rot(w[0], 8) ^ rot(w[1], 6) ^ rot(w[2], 4) ^ rot(w[3], 2),
            [
                w[0] as u16, (w[0] >> 16) as u16,
                w[1] as u16, (w[1] >> 16) as u16,
                w[2] as u16, (w[2] >> 16) as u16,
                w[3] as u16, (w[3] >> 16) as u16,
            ])
}