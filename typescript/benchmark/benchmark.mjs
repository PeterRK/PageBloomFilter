import os from "node:os";

import FastBloomFilter from "fast-bloom-filter";
import { BloomFilter as DaviesBloomFilter } from "bloomfilter";
import { BloomFilter as MnemonistBloomFilter } from "mnemonist";
import { PageBloomFilter } from "../dist/index.js";

const MODE = readMode();
const N = readPositiveInteger("BENCH_N", 1_000_000);
const ROUNDS = readPositiveInteger("BENCH_ROUNDS", 3);
const WARMUP_LIMIT = readPositiveInteger("BENCH_WARMUP_N", 100_000);
const WARMUP_N = Math.min(N, WARMUP_LIMIT);
const STRING_N = readPositiveInteger("BENCH_STRING_N", N);
const RAW_BATCH_N = Math.min(N, readPositiveInteger("BENCH_RAW_BATCH_N", 16_384));
const FPR = 0.01;

const activeN = MODE === "binary" ? N : STRING_N;
if (activeN > 0x1_0000_0000) {
  const name = MODE === "binary" ? "BENCH_N" : "BENCH_STRING_N";
  throw new RangeError(`${name} cannot exceed the 8-digit hexadecimal key space`);
}

function readMode() {
  let mode = process.env.BENCH_MODE;
  const args = process.argv.slice(2);
  for (let index = 0; index < args.length; index++) {
    const argument = args[index];
    if (argument === "--mode") {
      if (args[index + 1] === undefined) {
        throw new RangeError("--mode requires binary or string");
      }
      mode = args[index + 1];
      index += 1;
    } else if (argument.startsWith("--mode=")) {
      mode = argument.slice("--mode=".length);
    } else if (argument === "binary" || argument === "string") {
      mode = argument;
    } else {
      throw new RangeError(`unknown benchmark argument: ${argument}`);
    }
  }
  mode ??= "binary";
  if (mode !== "binary" && mode !== "string") {
    throw new RangeError(`BENCH_MODE/--mode must be "binary" or "string", got ${mode}`);
  }
  return mode;
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

function formatKey(index) {
  return index.toString(16).padStart(8, "0");
}

const RAW_KEY_LENGTH = 8;
const HEX_BYTES = new TextEncoder().encode("0123456789abcdef");

function createPackedRawKeys(length) {
  const data = new Uint8Array(length * RAW_KEY_LENGTH);
  for (let index = 0; index < length; index++) {
    let value = index;
    let offset = (index + 1) * RAW_KEY_LENGTH;
    for (let digit = 0; digit < RAW_KEY_LENGTH; digit++) {
      data[--offset] = HEX_BYTES[value & 0xf];
      value >>>= 4;
    }
  }
  return data;
}

const binaryKeyData = MODE === "binary" ? createPackedRawKeys(N) : new Uint8Array(0);
const rawBatchData = MODE === "binary"
  ? new Uint8Array(RAW_BATCH_N * RAW_KEY_LENGTH)
  : new Uint8Array(0);
const rawBatchKeys = MODE === "binary"
  ? Array.from(
    { length: RAW_BATCH_N },
    (_, index) => new Uint8Array(
      rawBatchData.buffer,
      rawBatchData.byteOffset + index * RAW_KEY_LENGTH,
      RAW_KEY_LENGTH,
    ),
  )
  : [];
const stringKeys = MODE === "string"
  ? Array.from({ length: STRING_N }, (_, index) => formatKey(index))
  : [];

function loadRawKeyBatch(start, end) {
  const byteStart = start * RAW_KEY_LENGTH;
  const byteEnd = end * RAW_KEY_LENGTH;
  rawBatchData.set(binaryKeyData.subarray(byteStart, byteEnd));
}

function timeSet(filter, length = N) {
  let elapsed = 0;
  for (let start = 0; start < length; start += RAW_BATCH_N) {
    const end = Math.min(start + RAW_BATCH_N, length);
    loadRawKeyBatch(start, end);
    const first = start % 2 === 0 ? start : start + 1;
    const batchStart = process.hrtime.bigint();
    for (let index = first; index < end; index += 2) {
      filter.add(rawBatchKeys[index - start]);
    }
    elapsed += Number(process.hrtime.bigint() - batchStart);
  }
  return elapsed;
}

function timeTest(filter, length = N) {
  let matches = 0;
  let elapsed = 0;
  for (let start = 0; start < length; start += RAW_BATCH_N) {
    const end = Math.min(start + RAW_BATCH_N, length);
    loadRawKeyBatch(start, end);
    const batchStart = process.hrtime.bigint();
    for (let index = start; index < end; index++) {
      matches += Number(filter.has(rawBatchKeys[index - start]));
    }
    elapsed += Number(process.hrtime.bigint() - batchStart);
  }
  return {
    elapsed,
    matches,
  };
}

async function warmUp(adapter) {
  const filter = await adapter.create();
  timeSet(filter, WARMUP_N);
  const { matches } = timeTest(filter, WARMUP_N);
  if (matches < Math.ceil(WARMUP_N / 2)) {
    throw new Error(`${adapter.name} produced a false negative during warmup`);
  }
  filter.dispose();
}

async function benchmark(adapter) {
  await warmUp(adapter);

  const setSamples = [];
  let sizeBytes = 0;
  for (let round = 0; round < ROUNDS; round++) {
    const filter = await adapter.create();
    sizeBytes = filter.sizeBytes;
    forceGc();
    setSamples.push(timeSet(filter) / Math.ceil(N / 2));
    filter.dispose();
  }

  const queryFilter = await adapter.create();
  timeSet(queryFilter);

  const testSamples = [];
  let matches = 0;
  for (let round = 0; round < ROUNDS; round++) {
    forceGc();
    const sample = timeTest(queryFilter);
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
    name: "fast-bloom-raw",
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

async function runBinaryBenchmark() {
  console.log("BINARY MODE");
  console.log(
    `N=${N.toLocaleString("en-US")}, inserted=${Math.ceil(N / 2).toLocaleString("en-US")}, ` +
    `FPR=${FPR}, key=UTF-8 bytes of an 8-char hex string, ` +
    `warmup=${WARMUP_N.toLocaleString("en-US")}, rounds=${ROUNDS}`,
  );

  const results = [];
  for (const adapter of [
    pbfAdapter("pbf-raw"),
    fastBloomAdapter(),
  ]) {
    process.stdout.write(`benchmarking ${adapter.name}... `);
    const result = await benchmark(adapter);
    results.push(result);
    console.log("done");
  }
  console.table(results);
}

const stringWarmupN = Math.min(STRING_N, WARMUP_LIMIT);

function stringPbfAdapter() {
  return {
    name: "pbf-str",
    async create() {
      const filter = await PageBloomFilter.create(STRING_N, FPR);
      return {
        sizeBytes: filter.pageNum * 2 ** filter.pageLevel,
        add: (key) => filter.set(key),
        has: (key) => filter.test(key),
        dispose: () => filter.dispose(),
      };
    },
  };
}

function stringFastBloomAdapter() {
  return {
    name: "fast-bloom-str",
    async create() {
      const filter = await FastBloomFilter.createOptimal(STRING_N, FPR);
      return {
        sizeBytes: filter.bitCount / 8,
        add: (key) => filter.addString(key),
        has: (key) => filter.hasString(key),
        dispose: () => filter.dispose(),
      };
    },
  };
}

function stringDaviesBloomAdapter() {
  return {
    name: "bloomfilter-str (FNV-1a)",
    async create() {
      const filter = DaviesBloomFilter.withTargetError(STRING_N, FPR);
      return {
        sizeBytes: filter.m / 8,
        add: (key) => filter.add(key),
        has: (key) => filter.test(key),
        dispose: () => {},
      };
    },
  };
}

function stringMnemonistAdapter() {
  return {
    name: "mnemonist-str (MurmurHash3)",
    async create() {
      const filter = new MnemonistBloomFilter({ capacity: STRING_N, errorRate: FPR });
      return {
        sizeBytes: filter.data.byteLength,
        add: (key) => filter.add(key),
        has: (key) => filter.test(key),
        dispose: () => {},
      };
    },
  };
}

function timeStringSet(filter) {
  const start = process.hrtime.bigint();
  for (let i = 0; i < STRING_N; i += 2) filter.add(stringKeys[i]);
  return Number(process.hrtime.bigint() - start);
}

function timeStringTest(filter) {
  let matches = 0;
  const start = process.hrtime.bigint();
  for (let i = 0; i < STRING_N; i++) {
    matches += Number(filter.has(stringKeys[i]));
  }
  return {
    elapsed: Number(process.hrtime.bigint() - start),
    matches,
  };
}

async function warmUpString(adapter) {
  const filter = await adapter.create();
  for (let i = 0; i < stringWarmupN; i += 2) filter.add(stringKeys[i]);
  let matches = 0;
  for (let i = 0; i < stringWarmupN; i++) {
    matches += Number(filter.has(stringKeys[i]));
  }
  if (matches < Math.ceil(stringWarmupN / 2)) {
    throw new Error(`${adapter.name} produced a false negative during string warmup`);
  }
  filter.dispose();
}

async function benchmarkString(adapter) {
  await warmUpString(adapter);

  const setSamples = [];
  let sizeBytes = 0;
  for (let round = 0; round < ROUNDS; round++) {
    const filter = await adapter.create();
    sizeBytes = filter.sizeBytes;
    forceGc();
    setSamples.push(timeStringSet(filter) / Math.ceil(STRING_N / 2));
    filter.dispose();
  }

  const queryFilter = await adapter.create();
  for (let i = 0; i < STRING_N; i += 2) queryFilter.add(stringKeys[i]);

  const testSamples = [];
  let matches = 0;
  for (let round = 0; round < ROUNDS; round++) {
    forceGc();
    const sample = timeStringTest(queryFilter);
    testSamples.push(sample.elapsed / STRING_N);
    matches = sample.matches;
  }
  queryFilter.dispose();

  const expectedHits = Math.ceil(STRING_N / 2);
  if (matches < expectedHits) {
    throw new Error(`${adapter.name} produced a false negative in the string check`);
  }
  return {
    implementation: adapter.name,
    bytes: sizeBytes,
    "set ns/op": median(setSamples).toFixed(2),
    "test ns/op": median(testSamples).toFixed(2),
    "observed FPR": ((matches - expectedHits) / Math.floor(STRING_N / 2)).toExponential(3),
  };
}

async function runStringBenchmark() {
  console.log("STRING MODE");
  console.log(
    `N=${STRING_N.toLocaleString("en-US")}, inserted=${Math.ceil(STRING_N / 2).toLocaleString("en-US")}, ` +
    `FPR=${FPR}, key=pre-generated 8-char hex string (UTF-8 when encoded), ` +
    `warmup=${stringWarmupN.toLocaleString("en-US")}, rounds=${ROUNDS}`,
  );
  const results = [];
  for (const adapter of [
    stringPbfAdapter(),
    stringFastBloomAdapter(),
    stringDaviesBloomAdapter(),
    stringMnemonistAdapter(),
  ]) {
    process.stdout.write(`benchmarking ${adapter.name}... `);
    const result = await benchmarkString(adapter);
    results.push(result);
    console.log("done");
  }
  console.table(results);
}

console.log(`Node ${process.version} | ${process.platform}/${process.arch}`);
console.log(os.cpus()[0]?.model ?? "unknown CPU");
if (MODE === "binary") {
  await runBinaryBenchmark();
} else {
  await runStringBenchmark();
}
