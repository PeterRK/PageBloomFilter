# pagebloomfilter

A fast page-based Bloom filter backed by WebAssembly. It supports Node.js and
modern browsers.

```typescript
import { PageBloomFilter } from "pagebloomfilter";

const bf = await PageBloomFilter.create(500, 0.01);
bf.set("Hello");
console.log(bf.test("Hello"));
bf.dispose();
```

Binary keys can be passed as `ArrayBuffer` or any `ArrayBufferView`. Use
`exportState()` and `PageBloomFilter.restore()` to persist and restore the
cross-language-compatible bitmap.

The package requires Node.js 18 or newer when used in Node. Browser runtimes
must provide WebAssembly, `fetch`, `TextEncoder`, and
`FinalizationRegistry`.

Licensed under the BSD 3-Clause License. Full documentation and source:
https://github.com/PeterRK/PageBloomFilter.
