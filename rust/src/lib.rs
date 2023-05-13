// Copyright (c) 2023, Ruan Kunliang.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

mod hash;
pub mod pbf;


#[test]
fn test_hash() {
    let expected = [
        [0x232706fc6bf50919_u64, 0x8b72ee65b4e851c7_u64],
        [0x50209687d54ec67e_u64, 0x62fe85108df1cf6d_u64],
        [0xfbe67d8368f3fb4f_u64, 0xb54a5a89706d5a5a_u64],
        [0x2882d11a5846ccfa_u64, 0x6b21b0e870109222_u64],
        [0xf5e0d56325d6d000_u64, 0xaf8703c9f9ac75e5_u64],
        [0x59a0f67b7ae7a5ad_u64, 0x84d7aeabc053b848_u64],
        [0xf01562a268e42c21_u64, 0xdfe994ab22873e7e_u64],
        [0x16133104620725dd_u64, 0xa5ca36afa7182e6a_u64],
        [0x7a9378dcdf599479_u64, 0x30f5a569a74ecdd7_u64],
        [0xd9f07bdc76c20a78_u64, 0x34f0621847f7888a_u64],
        [0x332a4fff07df83da_u64, 0xfa40557cc0ea6b72_u64],
        [0x976beeefd11659dc_u64, 0x8a3187b6a72d0039_u64],
        [0xc3fcc139e4c6832a_u64, 0xdadfeff6e01e2f2e_u64],
        [0x86130593c7746a6f_u64, 0x8ac9fb14904fe39d_u64],
        [0x70550dbe5cdde280_u64, 0xddb95757282706c0_u64],
        [0x67211fbaf6b9122d_u64, 0x68f4e8f3bbc700db_u64],
        [0xe2d06846964b80ad_u64, 0x6005068ac75c4c20_u64],
        [0xd55b3c010258ce93_u64, 0x981c8b03659d9950_u64],
        [0x5a2507daa032fa13_u64, 0x0d1c989bfc0c6cf7_u64],
        [0xaf8618678ae5cd55_u64, 0xe0b75cfad427eefc_u64],
        [0xad5a7047e8a139d8_u64, 0x183621cf988a753e_u64],
        [0x8fc110192723cd5e_u64, 0x203129f80764b844_u64],
        [0x50170b4485d7af19_u64, 0x7f2c79d145db7d35_u64],
        [0x7c32444652212bf3_u64, 0x27fd51b9156e2ad2_u64],
        [0x90e571225cce7360_u64, 0xf743b8f6f7433428_u64],
        [0x9919537c1add41e1_u64, 0x7ff0158f05b261f2_u64],
        [0x3a70a8070883029f_u64, 0xc5dcba911815d20a_u64],
        [0xcc32b418290e2879_u64, 0xbb7945d6d79b5dfb_u64],
        [0xde493e4646077aeb_u64, 0x465c2ea52660973a_u64],
        [0x4d3ad9b55316f970_u64, 0x9137e3040a7d87bb_u64],
        [0x1547de75efe848f4_u64, 0x21ae3f08b5330aac_u64],
        [0xe2ead0cc6aab6aff_u64, 0x29a20bccf77e70a7_u64],
        [0x3dc2f4a9e9b451b4_u64, 0x27de306dde7b60d2_u64],
        [0xce247654a4de9f51_u64, 0x040097e45e948d66_u64],
        [0xbc118f2ba2305503_u64, 0x810f05d0ea32853f_u64],
        [0xb55cd8bdcac2a118_u64, 0x4e93b65164705d2a_u64],
        [0xb7c97db807c32f38_u64, 0x510723230adef63d_u64],
    ];
    let key = "0123456789abcdefghijklmnopqrstuvwxyz".as_bytes();
    for i in 0..expected.len() {
        let code = hash::hash128(&key[..i]);
        assert_eq!(code, expected[i]);
    }
}

#[test]
fn test_new() {
    let bf = pbf::new_bloom_filter(500, 0.01);
    assert!(bf.valid());
    assert_eq!(bf.get_way(), 7);
    assert_eq!(bf.get_page_level(), 8);
    assert_eq!(bf.get_data().len(), 768);
}

#[test]
fn test_operate() {
    let _doit = |way: u8| {
        let mut bf = pbf::new_pbf(way, 7, 3);
        for i in 0..200 {
            assert!(bf.set(&(i as u64).to_le_bytes()));
        }
        for i in 0..200 {
            assert!(bf.test(&(i as u64).to_le_bytes()));
        }
        for i in 200..400 {
            assert!(!bf.test(&(i as u64).to_le_bytes()));
        }
    };
    for i in 4..9 {
        _doit(i as u8);
    }
}

#[test]
fn benchmark() {
    let n = 1000000_usize;
    let mut bf = pbf::new_bloom_filter(n, 0.01);

    let set = std::time::Instant::now();
    for i in 0..(n/2) {
        bf.set(&(i as u64).to_le_bytes());
    }
    println!("pbf-set: {:.2}ns/op", (set.elapsed().as_nanos() as u64) as f64 / (n/2) as f64);

    let test = std::time::Instant::now();
    for i in 0..n {
        bf.test(&(i as u64).to_le_bytes());
    }
    println!("pbf-test: {:.2}ns/op", (test.elapsed().as_nanos() as u64) as f64 / n as f64);
}