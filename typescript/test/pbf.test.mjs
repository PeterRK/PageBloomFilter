import assert from "node:assert/strict";
import test from "node:test";

import { PageBloomFilter } from "../dist/index.js";
import { validateLayout } from "../dist/api.js";

const keys = [
  "alpha",
  "中文键",
  new Uint8Array(),
  new Uint8Array([0, 1, 2, 3, 255]),
  new Uint16Array([0x1234, 0xabcd]),
];

async function exercise() {
  const filter = await PageBloomFilter.create(500, 0.01);
  assert.equal(filter.way, 7);
  assert.equal(filter.pageLevel, 7);
  assert.equal(filter.pageNum, 5);
  assert.equal(filter.data.byteLength, 640);
  assert.equal(filter.setMany(keys), keys.length);
  assert.deepEqual(filter.testMany(keys), keys.map(() => true));
  assert.equal(filter.set("alpha"), false);

  const state = filter.exportState();
  const restored = await PageBloomFilter.restore(...state);
  assert.equal(restored.uniqueCount, keys.length);
  assert.deepEqual(restored.data, filter.data);
  assert.deepEqual(restored.testMany(keys), keys.map(() => true));

  const snapshot = filter.data;
  snapshot.fill(0);
  assert.equal(filter.test("alpha"), true, "data must be returned as a copy");

  filter.clear();
  assert.equal(filter.uniqueCount, 0);
  assert.equal(filter.test("alpha"), false);
  return state;
}

test("WASM API preserves state and bitmap behavior", async () => {
  await exercise();
});

test("bitmap layout remains compatible with the existing language implementations", async () => {
  const filter = await PageBloomFilter.create(1, 0.01);
  filter.setMany(keys.slice(0, 4));

  assert.deepEqual([filter.way, filter.pageLevel, filter.pageNum], [7, 7, 1]);
  assert.equal(
    Buffer.from(filter.data).toString("hex"),
    [
      "0000000010000000000000004000000000000000000000100100000000010000",
      "0000000200000000000000000000040000000000040000008040000000000000",
      "0000004000004180020000002000000000000100080080000000800000000010",
      "0000000080000000000000000000410000800040000000800000000000002000",
    ].join(""),
  );
});

test("string keys retain their UTF-8 representation across buffer growth", async () => {
  const textKeys = [
    "",
    "short",
    "中文🙂".repeat(100),
    "small-again",
    "x".repeat(1024),
    "尾",
  ];
  const encoder = new TextEncoder();
  const filter = await PageBloomFilter.create(1_000, 0.01);
  for (const text of textKeys) {
    filter.set(text);
    assert.equal(filter.test(text), true);
    assert.equal(filter.test(encoder.encode(text)), true);
  }
  filter.dispose();
});

test("WASM refreshes its input view after memory growth", async () => {
  const first = await PageBloomFilter.create(1, 0.01);
  const binaryKey = new Uint8Array([0xde, 0xad, 0xbe, 0xef]);
  first.set("before-growth");
  first.set(binaryKey);

  const large = await PageBloomFilter.create(1_000_000, 0.01);
  assert.equal(first.test("before-growth"), true);
  assert.equal(first.test(binaryKey), true);
  assert.equal(first.set("after-growth"), true);
  assert.equal(first.test("after-growth"), true);

  large.dispose();
  first.dispose();
});

test("WASM keeps per-filter scratch allocations isolated and reusable", async () => {
  const first = await PageBloomFilter.create(1_000, 0.01);
  const second = await PageBloomFilter.create(1_000, 0.01);
  const firstKey = new Uint8Array([1, 2, 3, 4]);
  const secondKey = "second-filter";

  first.set(firstKey);
  second.set(secondKey);
  first.set("x".repeat(300));
  assert.equal(first.test(firstKey), true);
  assert.equal(second.test(secondKey), true);

  first.dispose();
  const replacement = await PageBloomFilter.create(1_000, 0.01);
  replacement.set("replacement");
  assert.equal(replacement.test("replacement"), true);
  assert.equal(second.test(secondKey), true);

  replacement.dispose();
  second.dispose();
});

test("disposed filters release storage and reject further access", async () => {
  const filter = await PageBloomFilter.create(500, 0.01);
  filter.set("alpha");
  filter.dispose();
  filter.dispose();
  assert.throws(() => filter.test("alpha"), /disposed/);
});

test("creation dispatches every supported way", async () => {
  for (const [fpr, way] of [[0.1, 4], [0.03, 5], [0.015, 6], [0.008, 7], [0.003, 8]]) {
    const filter = await PageBloomFilter.create(100, fpr);
    assert.equal(filter.way, way);
    filter.dispose();
  }
});

test("page count at the exclusive limit is rejected", () => {
  assert.throws(() => validateLayout(4, 6, 1 << 18), /too large/);
});

test("invalid restored layouts are rejected", async () => {
  await assert.rejects(PageBloomFilter.restore(3, 7, new Uint8Array(128)), /way/);
  await assert.rejects(PageBloomFilter.restore(7, 7, new Uint8Array()), /data length/);
  await assert.rejects(PageBloomFilter.restore(7, 7, new Uint8Array(129)), /data length/);
});
