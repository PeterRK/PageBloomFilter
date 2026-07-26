# pagebloomfilter

Fast page-based Bloom filter backed by WebAssembly for Node.js and modern
browsers.

```shell
npm install pagebloomfilter@1.3.0
```

```typescript
import { PageBloomFilter } from "pagebloomfilter";

const bf = await PageBloomFilter.create(500, 0.01);
bf.set("Hello");
console.log(bf.test("Hello"));
bf.dispose();
```

Requires Node.js 18+ or a browser with WebAssembly.

Source: https://github.com/PeterRK/PageBloomFilter

License: BSD-3-Clause
