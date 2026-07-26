# pagebloomfilter

Fast page-based Bloom filter for Rust. The package name is `pagebloomfilter`;
the library crate name is `pbf`.

```toml
[dependencies]
pagebloomfilter = "1.3.0"
```

```rust
use pbf::pbf::BloomFilter;

let mut bf = pbf::new_bloom_filter(500, 0.01);
let key = b"Hello";

assert!(bf.set(key));
assert!(bf.test(key));
```

Source: https://github.com/PeterRK/PageBloomFilter

License: BSD-3-Clause
