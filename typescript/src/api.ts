export type Key = string | ArrayBuffer | ArrayBufferView;
export type WasmSource =
  | WebAssembly.Module
  | BufferSource
  | Response
  | URL
  | string;

export interface PageBloomFilterOptions {
  wasmSource?: WasmSource;
}

export type SerializedState = readonly [
  way: number,
  pageLevel: number,
  data: Uint8Array,
  uniqueCount: number,
];

type FilterOperation = (
  space: number,
  pageLevel: number,
  pageNum: number,
  key: number,
  keyLength: number,
) => number;

interface Allocation {
  pointer: number;
  length: number;
}

/** @internal */
export interface PageBloomFilterInit {
  readonly memory: WebAssembly.Memory;
  readonly setOperation: FilterOperation;
  readonly testOperation: FilterOperation;
  readonly pointer: number;
  readonly length: number;
  readonly allocateScratch: (length: number) => Allocation;
  readonly releaseScratch: (allocation: Allocation) => void;
  readonly release: () => void;
}


const encoder = new TextEncoder();
const LN2 = Math.log(2);
const MAX_PAGE_NUM = 1 << 19;

/** @internal */
export function requireInteger(name: string, value: number, minimum = 0): void {
  if (!Number.isSafeInteger(value) || value < minimum) {
    throw new RangeError(`${name} must be a safe integer >= ${minimum}`);
  }
}

/** @internal */
export function bytes(value: ArrayBuffer | ArrayBufferView): Uint8Array {
  if (value instanceof Uint8Array) return value;
  if (value instanceof ArrayBuffer) return new Uint8Array(value);
  if (ArrayBuffer.isView(value)) {
    return new Uint8Array(value.buffer, value.byteOffset, value.byteLength);
  }
  throw new TypeError("value must be a string or contiguous byte buffer");
}

function clampFpr(fpr: number): number {
  if (!Number.isFinite(fpr)) throw new RangeError("fpr must be finite");
  return Math.min(Math.max(fpr, 0.0005), 0.1);
}

/** @internal */
export function validateLayout(way: number, pageLevel: number, pageNum: number): number {
  requireInteger("way", way, 4);
  if (way > 8) throw new RangeError("way must be in [4, 8]");
  requireInteger("pageLevel", pageLevel);
  const minimumPageLevel = 8 - Math.floor(8 / way);
  if (pageLevel < minimumPageLevel || pageLevel > 13) {
    throw new RangeError("pageLevel is out of range for this way");
  }
  requireInteger("pageNum", pageNum, 1);
  if (pageNum >= MAX_PAGE_NUM) throw new RangeError("pageNum is too large");
  const size = pageNum * 2 ** pageLevel;
  if (!Number.isSafeInteger(size)) throw new RangeError("bitmap is too large");
  return size;
}

export function bestWay(fpr: number): number {
  const way = Math.round(-Math.log2(clampFpr(fpr)));
  return Math.min(Math.max(way, 4), 8);
}

/** @internal */
export function createLayout(item: number, requestedFpr: number): [number, number, number] {
  requireInteger("item", item);
  item = Math.max(item, 1);
  const fpr = clampFpr(requestedFpr);
  const w = -Math.log2(fpr);
  let bitsPerItem = w / (LN2 * 8);
  if (w > 9) {
    const x = w - 7;
    bitsPerItem *= 1 + 0.0025 * x * x;
  } else if (w > 3) {
    bitsPerItem *= 1.01;
  }

  const way = bestWay(fpr);
  const bytesRequired = Math.trunc(bitsPerItem * item);
  let pageLevel = 12;
  for (let level = 6; level < 12; level++) {
    if (bytesRequired >= 2 ** (level + 4)) continue;
    pageLevel = level;
    if (pageLevel < 8 - 8 / way) pageLevel++;
    break;
  }
  const pageNum = Math.max(Math.ceil(bytesRequired / 2 ** pageLevel), 1);
  validateLayout(way, pageLevel, pageNum);
  return [way, pageLevel, pageNum];
}

export class PageBloomFilter {
  static async create(
    item: number,
    fpr: number,
    options: PageBloomFilterOptions = {},
  ): Promise<PageBloomFilter> {
    const { createPageBloomFilter } = await import("./wasm.js");
    return createPageBloomFilter(item, fpr, options.wasmSource);
  }

  static async restore(
    way: number,
    pageLevel: number,
    data: ArrayBuffer | ArrayBufferView,
    uniqueCount = 0,
    options: PageBloomFilterOptions = {},
  ): Promise<PageBloomFilter> {
    const { restorePageBloomFilter } = await import("./wasm.js");
    return restorePageBloomFilter(
      way, pageLevel, data, uniqueCount, options.wasmSource,
    );
  }

  /** @internal */
  static fromInit(
    init: PageBloomFilterInit,
    way: number,
    pageLevel: number,
    pageNum: number,
    uniqueCount: number,
  ): PageBloomFilter {
    return new PageBloomFilter(init, way, pageLevel, pageNum, uniqueCount);
  }

  readonly way: number;
  readonly pageLevel: number;
  readonly pageNum: number;
  readonly #memory: WebAssembly.Memory;
  readonly #setOperation: FilterOperation;
  readonly #testOperation: FilterOperation;
  readonly #pointer: number;
  readonly #length: number;
  readonly #allocateScratch: (length: number) => Allocation;
  readonly #releaseScratch: (allocation: Allocation) => void;
  readonly #release: () => void;
  #uniqueCount: number;
  #scratchPointer = 0;
  #scratchCapacity = 0;
  #scratchView = new Uint8Array(0);
  #disposed = false;

  /** Use PageBloomFilter.create() or PageBloomFilter.restore(). */
  private constructor(
    init: PageBloomFilterInit,
    way: number,
    pageLevel: number,
    pageNum: number,
    uniqueCount: number,
  ) {
    this.#memory = init.memory;
    this.#setOperation = init.setOperation;
    this.#testOperation = init.testOperation;
    this.#pointer = init.pointer;
    this.#length = init.length;
    this.#allocateScratch = init.allocateScratch;
    this.#releaseScratch = init.releaseScratch;
    this.#release = init.release;
    this.way = way;
    this.pageLevel = pageLevel;
    this.pageNum = pageNum;
    this.#uniqueCount = uniqueCount;
  }

  #resizeScratch(length: number): void {
    const next = this.#allocateScratch(length);
    if (this.#scratchPointer !== 0) {
      this.#releaseScratch({ pointer: this.#scratchPointer, length: this.#scratchCapacity });
    }
    this.#scratchPointer = next.pointer;
    this.#scratchCapacity = next.length;
    this.#refreshScratchView();
  }

  #refreshScratchView(): void {
    this.#scratchView = new Uint8Array(
      this.#memory.buffer,
      this.#scratchPointer,
      this.#scratchCapacity,
    );
  }

  #prepareScratch(length: number): Uint8Array {
    if (length > this.#scratchCapacity || this.#scratchPointer === 0) {
      this.#resizeScratch(length);
    } else if (this.#scratchView.byteLength !== this.#scratchCapacity) {
      this.#refreshScratchView();
    }
    return this.#scratchView;
  }

  get uniqueCount(): number {
    return this.#uniqueCount;
  }

  get data(): Uint8Array {
    this.#assertActive();
    return new Uint8Array(this.#memory.buffer, this.#pointer, this.#length).slice();
  }

  #assertActive(): void {
    if (this.#disposed) throw new Error("PageBloomFilter has been disposed");
  }

  dispose(): void {
    if (this.#disposed) return;
    this.#release();
    this.#disposed = true;
  }

  clear(): void {
    this.#assertActive();
    new Uint8Array(this.#memory.buffer, this.#pointer, this.#length).fill(0);
    this.#uniqueCount = 0;
  }

  set(key: Key): boolean {
    this.#assertActive();
    let keyLength: number;
    if (key instanceof Uint8Array) {
      keyLength = key.byteLength;
      let target = this.#scratchView;
      const available = target.byteLength;
      if (keyLength > available || available === 0) {
        if (keyLength > this.#scratchCapacity || this.#scratchPointer === 0) {
          this.#resizeScratch(keyLength);
        } else {
          this.#refreshScratchView();
        }
        target = this.#scratchView;
      }
      target.set(key);
    } else if (typeof key === "string") {
      const target = this.#prepareScratch(key.length * 3);
      const { read, written } = encoder.encodeInto(key, target);
      if (read !== key.length) throw new RangeError("unable to encode the complete string key");
      keyLength = written;
    } else {
      const keyBytes = bytes(key);
      keyLength = keyBytes.byteLength;
      this.#prepareScratch(keyLength).set(keyBytes);
    }
    const inserted = this.#setOperation(
      this.#pointer,
      this.pageLevel,
      this.pageNum,
      this.#scratchPointer,
      keyLength,
    ) !== 0;
    if (inserted) this.#uniqueCount++;
    return inserted;
  }

  test(key: Key): boolean {
    this.#assertActive();
    let keyLength: number;
    if (key instanceof Uint8Array) {
      keyLength = key.byteLength;
      let target = this.#scratchView;
      const available = target.byteLength;
      if (keyLength > available || available === 0) {
        if (keyLength > this.#scratchCapacity || this.#scratchPointer === 0) {
          this.#resizeScratch(keyLength);
        } else {
          this.#refreshScratchView();
        }
        target = this.#scratchView;
      }
      target.set(key);
    } else if (typeof key === "string") {
      const target = this.#prepareScratch(key.length * 3);
      const { read, written } = encoder.encodeInto(key, target);
      if (read !== key.length) throw new RangeError("unable to encode the complete string key");
      keyLength = written;
    } else {
      const keyBytes = bytes(key);
      keyLength = keyBytes.byteLength;
      this.#prepareScratch(keyLength).set(keyBytes);
    }
    return this.#testOperation(
      this.#pointer,
      this.pageLevel,
      this.pageNum,
      this.#scratchPointer,
      keyLength,
    ) !== 0;
  }

  setMany(keys: Iterable<Key>): number {
    let inserted = 0;
    for (const key of keys) if (this.set(key)) inserted++;
    return inserted;
  }

  testMany(keys: Iterable<Key>): boolean[] {
    return Array.from(keys, (key) => this.test(key));
  }

  capacity(): number {
    return (this.pageNum * 2 ** this.pageLevel * 8) / this.way;
  }

  virtualCapacity(fpr: number): number {
    if (!(fpr > 0 && fpr < 1)) throw new RangeError("fpr must be between 0 and 1");
    const bitCount = this.pageNum * 2 ** this.pageLevel * 8;
    const estimate = Math.log1p(-(fpr ** (1 / this.way))) / Math.log1p(-1 / bitCount);
    return Math.trunc(Math.trunc(estimate) / this.way);
  }

  exportState(): SerializedState {
    return [this.way, this.pageLevel, this.data, this.#uniqueCount];
  }

  toString(): string {
    return `PageBloomFilter(way=${this.way}, pageLevel=${this.pageLevel}, pageNum=${this.pageNum}, uniqueCount=${this.#uniqueCount})`;
  }
}

