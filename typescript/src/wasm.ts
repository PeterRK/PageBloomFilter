import {
  PageBloomFilter,
  bytes,
  createLayout,
  requireInteger,
  validateLayout,
  type Allocation,
  type FilterOperation,
  type PageBloomFilterInit,
  type WasmSource,
} from "./api.js";

interface PbfWasmExports extends WebAssembly.Exports {
  memory: WebAssembly.Memory;
  __heap_base: WebAssembly.Global;
  PBF4_Set: FilterOperation;
  PBF4_Test: FilterOperation;
  PBF5_Set: FilterOperation;
  PBF5_Test: FilterOperation;
  PBF6_Set: FilterOperation;
  PBF6_Test: FilterOperation;
  PBF7_Set: FilterOperation;
  PBF7_Test: FilterOperation;
  PBF8_Set: FilterOperation;
  PBF8_Test: FilterOperation;
}

interface AllocationGroup {
  readonly blocks: Allocation[];
}


async function defaultWasmBytes(): Promise<Uint8Array<ArrayBuffer>> {
  const url = new URL("./pagebloomfilter.wasm", import.meta.url);
  if (url.protocol === "file:") {
    const moduleName = "node:fs/promises";
    const { readFile } = await import(moduleName) as typeof import("node:fs/promises");
    return new Uint8Array(await readFile(url));
  }
  const response = await fetch(url);
  if (!response.ok) throw new Error(`unable to load ${url}: ${response.status}`);
  return new Uint8Array(await response.arrayBuffer());
}

async function instantiate(source?: WasmSource): Promise<WebAssembly.Instance> {
  if (source instanceof WebAssembly.Module) return new WebAssembly.Instance(source, {});
  let bytes: BufferSource;
  if (source === undefined) {
    bytes = await defaultWasmBytes();
  } else if (source instanceof Response) {
    bytes = new Uint8Array(await source.arrayBuffer());
  } else if (source instanceof URL || typeof source === "string") {
    const response = await fetch(source);
    if (!response.ok) throw new Error(`unable to load WebAssembly: ${response.status}`);
    bytes = new Uint8Array(await response.arrayBuffer());
  } else {
    bytes = source;
  }
  return (await WebAssembly.instantiate(bytes, {})).instance;
}

class WasmContext {
  readonly memory: WebAssembly.Memory;
  readonly #exports: PbfWasmExports;
  readonly #registry: FinalizationRegistry<AllocationGroup>;
  readonly #freeBlocks: Allocation[] = [];
  #heapTop: number;

  constructor(instance: WebAssembly.Instance) {
    const exports = instance.exports as PbfWasmExports;
    this.#exports = exports;
    this.memory = exports.memory;
    this.#registry = new FinalizationRegistry((group) => this.#releaseGroup(group));
    this.#heapTop = Math.ceil(Number(exports.__heap_base.value) / 8) * 8;
  }

  #releaseGroup(group: AllocationGroup): void {
    for (const block of group.blocks.splice(0)) this.#releaseBlock(block);
  }

  #releaseBlock(allocation: Allocation): void {
    this.#freeBlocks.push(allocation);
    this.#freeBlocks.sort((left, right) => left.pointer - right.pointer);
    const merged: Allocation[] = [];
    for (const block of this.#freeBlocks) {
      const previous = merged.at(-1);
      if (previous && previous.pointer + previous.length === block.pointer) {
        previous.length += block.length;
      } else {
        merged.push({ ...block });
      }
    }
    this.#freeBlocks.length = 0;
    this.#freeBlocks.push(...merged);
  }

  #allocate(length: number): Allocation {
    length = Math.ceil(Math.max(length, 1) / 8) * 8;
    const freeIndex = this.#freeBlocks.findIndex((block) => block.length >= length);
    if (freeIndex !== -1) {
      const block = this.#freeBlocks[freeIndex]!;
      const pointer = block.pointer;
      block.pointer += length;
      block.length -= length;
      if (block.length === 0) this.#freeBlocks.splice(freeIndex, 1);
      return { pointer, length };
    }

    const pointer = this.#heapTop;
    const next = pointer + length;
    if (next > this.memory.buffer.byteLength) {
      const pages = Math.ceil((next - this.memory.buffer.byteLength) / 65536);
      try {
        this.memory.grow(pages);
      } catch (error) {
        throw new RangeError(`unable to grow WebAssembly memory to ${next} bytes`, { cause: error });
      }
    }
    this.#heapTop = next;
    return { pointer, length };
  }

  #operation(set: boolean, way: number): FilterOperation {
    const functionName = `PBF${way}_${set ? "Set" : "Test"}` as keyof PbfWasmExports;
    const operation = this.#exports[functionName];
    if (typeof operation !== "function") throw new RangeError(`unsupported way: ${way}`);
    return operation as FilterOperation;
  }

  create(item: number, fpr: number): PageBloomFilter {
    const [way, pageLevel, pageNum] = createLayout(item, fpr);
    return this.#createFilter(way, pageLevel, pageNum);
  }

  restore(
    way: number,
    pageLevel: number,
    data: ArrayBuffer | ArrayBufferView,
    uniqueCount = 0,
  ): PageBloomFilter {
    requireInteger("uniqueCount", uniqueCount);
    const bitmap = bytes(data);
    const pageSize = 2 ** pageLevel;
    if (bitmap.byteLength === 0 || bitmap.byteLength % pageSize !== 0) {
      throw new RangeError("data length must be a positive multiple of the page size");
    }
    const pageNum = bitmap.byteLength / pageSize;
    const expectedSize = validateLayout(way, pageLevel, pageNum);
    if (bitmap.byteLength !== expectedSize) throw new RangeError("invalid bitmap length");
    return this.#createFilter(way, pageLevel, pageNum, bitmap, uniqueCount);
  }

  #createFilter(
    way: number,
    pageLevel: number,
    pageNum: number,
    data?: Uint8Array,
    uniqueCount = 0,
  ): PageBloomFilter {
    const length = pageNum * 2 ** pageLevel;
    const allocation = this.#allocate(length);
    const pointer = allocation.pointer;
    const bitmap = new Uint8Array(this.memory.buffer, pointer, length);
    if (data) bitmap.set(data);
    else bitmap.fill(0);
    const group: AllocationGroup = { blocks: [allocation] };
    const unregisterToken = {};
    const init: PageBloomFilterInit = {
      memory: this.memory,
      setOperation: this.#operation(true, way),
      testOperation: this.#operation(false, way),
      pointer,
      length,
      allocateScratch: (scratchLength) => {
        const block = this.#allocate(scratchLength);
        group.blocks.push(block);
        return block;
      },
      releaseScratch: (scratchAllocation) => {
        const index = group.blocks.findIndex(
          (block) => block.pointer === scratchAllocation.pointer,
        );
        if (index === -1) return;
        const [block] = group.blocks.splice(index, 1);
        this.#releaseBlock(block!);
      },
      release: () => {
        this.#registry.unregister(unregisterToken);
        this.#releaseGroup(group);
      },
    };
    const filter = PageBloomFilter.fromInit(init, way, pageLevel, pageNum, uniqueCount);
    this.#registry.register(filter, group, unregisterToken);
    return filter;
  }
}

let defaultContext: Promise<WasmContext> | undefined;

async function getContext(source?: WasmSource): Promise<WasmContext> {
  if (source !== undefined) return new WasmContext(await instantiate(source));
  defaultContext ??= instantiate().then((instance) => new WasmContext(instance));
  return defaultContext;
}

export async function createPageBloomFilter(
  item: number,
  fpr: number,
  source?: WasmSource,
): Promise<PageBloomFilter> {
  return (await getContext(source)).create(item, fpr);
}

export async function restorePageBloomFilter(
  way: number,
  pageLevel: number,
  data: ArrayBuffer | ArrayBufferView,
  uniqueCount = 0,
  source?: WasmSource,
): Promise<PageBloomFilter> {
  return (await getContext(source)).restore(way, pageLevel, data, uniqueCount);
}
