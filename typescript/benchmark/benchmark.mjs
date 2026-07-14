import os from "node:os";

import FastBloomFilter from "fast-bloom-filter";
import bloomFilters from "bloom-filters";
import { PageBloomFilter } from "../dist/index.js";

const N = readPositiveInteger("BENCH_N", 1_000_000);
const ROUNDS = readPositiveInteger("BENCH_ROUNDS", 3);
const WARMUP_N = Math.min(N, readPositiveInteger("BENCH_WARMUP_N", 100_000));
const FPR = 0.01;

if (N > 0xffff_ffff) {
  throw new RangeError("BENCH_N must fit in an unsigned 32-bit key");
}

function readPositiveInteger(name, fallback) {
  const text = process.env[name];
  if (text === undefined) return fallback;
  const value = Number(text);
  if (!Number.isSafeInteger(value) || value < 1) {
    throw new RangeError(`${name} must be a positive safe integer`);
  }
  return value;
}

function median(values) {
  const sorted = [...values].sort((left, right) => left - right);
  const middle = Math.floor(sorted.length / 2);
  return sorted.length % 2 === 0
    ? (sorted[middle - 1] + sorted[middle]) / 2
    : sorted[middle];
}

function forceGc() {
  globalThis.gc?.();
}

function timeSet(filter, key, word) {
  const start = process.hrtime.bigint();
  for (let i = 0; i < N; i += 2) {
    word[0] = i;
    filter.add(key);
  }
  return Number(process.hrtime.bigint() - start);
}

function timeTest(filter, key, word) {
  let matches = 0;
  const start = process.hrtime.bigint();
  for (let i = 0; i < N; i++) {
    word[0] = i;
    matches += Number(filter.has(key));
  }
  return {
    elapsed: Number(process.hrtime.bigint() - start),
    matches,
  };
}

async function warmUp(adapter, key, word) {
  const filter = await adapter.create();
  for (let i = 0; i < WARMUP_N; i += 2) {
    word[0] = i;
    filter.add(key);
  }
  let matches = 0;
  for (let i = 0; i < WARMUP_N; i++) {
    word[0] = i;
    matches += Number(filter.has(key));
  }
  if (matches < Math.ceil(WARMUP_N / 2)) {
    throw new Error(`${adapter.name} produced a false negative during warmup`);
  }
  filter.dispose();
}

async function benchmark(adapter, key, word) {
  await warmUp(adapter, key, word);

  const setSamples = [];
  let sizeBytes = 0;
  for (let round = 0; round < ROUNDS; round++) {
    const filter = await adapter.create();
    sizeBytes = filter.sizeBytes;
    forceGc();
    setSamples.push(timeSet(filter, key, word) / Math.ceil(N / 2));
    filter.dispose();
  }

  const queryFilter = await adapter.create();
  for (let i = 0; i < N; i += 2) {
    word[0] = i;
    queryFilter.add(key);
  }

  const testSamples = [];
  let matches = 0;
  for (let round = 0; round < ROUNDS; round++) {
    forceGc();
    const sample = timeTest(queryFilter, key, word);
    testSamples.push(sample.elapsed / N);
    matches = sample.matches;
  }
  queryFilter.dispose();

  const expectedHits = Math.ceil(N / 2);
  if (matches < expectedHits) {
    throw new Error(`${adapter.name} produced a false negative`);
  }
  return {
    implementation: adapter.name,
    bytes: sizeBytes,
    "set ns/op": median(setSamples).toFixed(2),
    "test ns/op": median(testSamples).toFixed(2),
    "observed FPR": ((matches - expectedHits) / Math.floor(N / 2)).toExponential(3),
  };
}

function pbfAdapter(name) {
  return {
    name,
    async create() {
      const filter = await PageBloomFilter.create(N, FPR);
      return {
        sizeBytes: filter.pageNum * 2 ** filter.pageLevel,
        add: (key) => filter.set(key),
        has: (key) => filter.test(key),
        dispose: () => filter.dispose(),
      };
    },
  };
}

function fastBloomAdapter() {
  return {
    name: "fast-bloom-filter",
    async create() {
      const filter = await FastBloomFilter.createOptimal(N, FPR);
      return {
        sizeBytes: filter.bitCount / 8,
        add: (key) => filter.add(key),
        has: (key) => filter.has(key),
        dispose: () => filter.dispose(),
      };
    },
  };
}

function bloomFiltersAdapter() {
  return {
    name: "bloom-filters",
    async create() {
      const filter = bloomFilters.BloomFilter.create(N, FPR);
      return {
        sizeBytes: Math.ceil(filter.size / 8),
        add: (key) => filter.add(key.buffer),
        has: (key) => filter.has(key.buffer),
        dispose: () => {},
      };
    },
  };
}

const key = new Uint8Array(4);
const word = new Uint32Array(key.buffer, 0, 1);
const adapters = [
  pbfAdapter("PageBloomFilter WASM"),
  fastBloomAdapter(),
  bloomFiltersAdapter(),
];

console.log(`Node ${process.version} | ${process.platform}/${process.arch}`);
console.log(os.cpus()[0]?.model ?? "unknown CPU");
console.log(
  `N=${N.toLocaleString("en-US")}, inserted=${Math.ceil(N / 2).toLocaleString("en-US")}, ` +
  `FPR=${FPR}, key=uint32-le, warmup=${WARMUP_N.toLocaleString("en-US")}, rounds=${ROUNDS}`,
);

const results = [];
for (const adapter of adapters) {
  process.stdout.write(`benchmarking ${adapter.name}... `);
  const result = await benchmark(adapter, key, word);
  results.push(result);
  console.log("done");
}
console.table(results);
