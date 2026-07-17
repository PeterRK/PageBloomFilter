# pagebloomfilter

Fast page-based Bloom filter for Rust.

The crates.io package is named `pagebloomfilter`; its library crate remains
`pbf` for source compatibility.

```rust
let mut bf = pbf::new_bloom_filter(500, 0.01);
let key = b"Hello";

assert!(bf.set(key));
assert!(bf.test(key));
```

When the false-positive rate is a compile-time constant, the macro form avoids
runtime dispatch:

```rust
let mut bf = pbf::new_bloom_filter_fast!(500, 0.01);
assert!(bf.set(b"Hello"));
```

PageBloomFilter is licensed under the BSD 3-Clause License. The source and
cross-language format documentation are available at
https://github.com/PeterRK/PageBloomFilter.
