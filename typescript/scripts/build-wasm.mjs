import { existsSync, mkdirSync } from "node:fs";
import { spawnSync } from "node:child_process";
import { fileURLToPath } from "node:url";
import { dirname, join, resolve } from "node:path";

const packageRoot = resolve(dirname(fileURLToPath(import.meta.url)), "..");
const repoRoot = resolve(packageRoot, "..");
const outputDir = join(packageRoot, "dist");
const output = join(outputDir, "pagebloomfilter.wasm");
mkdirSync(outputDir, { recursive: true });

const compiler = process.env.CXX || "clang++";
const linkerCandidates = [
  process.env.WASM_LD,
  "/usr/bin/wasm-ld",
  "/usr/bin/wasm-ld-20",
  "/usr/bin/wasm-ld-19",
  "/usr/bin/wasm-ld-18",
  "/usr/bin/wasm-ld-17",
].filter((candidate) => typeof candidate === "string");
const linker = linkerCandidates.find((candidate) => existsSync(candidate));

const args = [
  "--target=wasm32",
  "-O3",
  "-std=c++14",
  "-fno-exceptions",
  "-fno-rtti",
  "-fno-strict-aliasing",
  "-nostdlib",
  "-DC_ALL_IN_ONE",
  `-I${join(repoRoot, "include")}`,
  `-I${join(repoRoot, "src")}`,
  join(repoRoot, "src", "pbf-c.cc"),
  "-Wl,--no-entry",
  "-Wl,--export-memory",
  "-Wl,--export=__heap_base",
  "-Wl,--export=PBF4_Set",
  "-Wl,--export=PBF4_Test",
  "-Wl,--export=PBF5_Set",
  "-Wl,--export=PBF5_Test",
  "-Wl,--export=PBF6_Set",
  "-Wl,--export=PBF6_Test",
  "-Wl,--export=PBF7_Set",
  "-Wl,--export=PBF7_Test",
  "-Wl,--export=PBF8_Set",
  "-Wl,--export=PBF8_Test",
  "-Wl,--initial-memory=131072",
  "-Wl,--max-memory=2147483648",
  "-Wl,-z,stack-size=65536",
  "-Wl,--strip-all",
  "-o",
  output,
];
if (linker) {
  args.unshift(`-fuse-ld=${linker}`);
}

const result = spawnSync(compiler, args, { stdio: "inherit" });
if (result.error) throw result.error;
if (result.status !== 0) process.exit(result.status ?? 1);
console.log(output);
