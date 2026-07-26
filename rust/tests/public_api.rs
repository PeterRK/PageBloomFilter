// Copyright (c) 2023, Ruan Kunliang.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

use pbf::{best_way_const, new_bloom_filter, new_pbf, restore_pbf, BloomFilter, PageBloomFilter};

fn assert_valid(filter: &dyn BloomFilter) {
    assert!(filter.valid());
}

#[test]
fn crate_root_exposes_the_documented_public_api() {
    assert_eq!(7, best_way_const(0.01));

    let mut estimated = new_bloom_filter(500, 0.01);
    let key = b"Hello";
    assert!(estimated.set(key));
    assert!(estimated.test(key));
    assert_valid(estimated.as_ref());

    let direct = new_pbf(4, 6, 1);
    assert_valid(direct.as_ref());

    let restored = restore_pbf(4, 6, direct.get_data(), 0);
    assert_valid(restored.as_ref());

    let typed = PageBloomFilter::<4>::new(6, 1);
    assert_valid(&typed);

    let fast = pbf::new_bloom_filter_fast!(500, 0.01);
    assert_valid(&fast);
}
