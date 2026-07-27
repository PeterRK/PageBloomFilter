# Changelog

This file records user-visible changes to PageBloomFilter. Officially
distributed implementations expanded over successive release lines:

- v1.0.x: C++.
- v1.2.x: C++ and Go.
- v1.3.x: C++, Go, Java, .NET, Python, and Rust.

The TypeScript/WebAssembly implementation was added in v1.3.x, but its npm
distribution is deferred.

## v1.3.0 / v1.3.1

Released 2026-07-26.

- The repository tags `v1.3.0` and `v1.3.1` are aliases for the same source
  release and point to the same commit. There are no source changes between
  them.
- Rust: published `pagebloomfilter` 1.3.1 with the documented API exported
  from the crate root. Rust 1.3.0 is yanked because its README did not match
  the accidentally exposed `pbf::pbf::*` module path.
- Go: both alias versions are available through Go modules.
- Other registries remain on 1.3.0. The `v1.3.1` repository alias does not
  imply a 1.3.1 release for Python, Java, .NET, or npm.

This release expands the officially distributed implementations beyond C++ and
Go by adding Java, .NET, Python, and Rust packages.

### Added

- Added a TypeScript implementation backed by WebAssembly for Node.js and
  browsers, including lifecycle handling, bitmap restoration, tests, and
  benchmarks. The npm package is prepared but was not published in this
  release.
- Added installable CMake targets, C and C++ headers, package configuration
  files, shared/static library support, and CMake install rules.
- Added per-language GitHub Actions workflows for C/C++, Go, Java, .NET,
  Python, Rust, and TypeScript.
- Added registry packaging and metadata for PyPI, Maven Central, NuGet, and
  crates.io, plus Trusted Publishing workflows for Python and .NET.
- Added a shared minimum-filter golden bitmap test across all seven
  implementations to protect the persisted bitmap format.

### Changed

- Standardized the maximum page count to the exclusive limit `1 << 18` in all
  implementations. Filter creation or restoration at or above that limit is
  rejected.
- Made the AES-NI hash an explicit C/C++ opt-in because enabling it changes
  persisted-data compatibility.
- Limited the native C/C++ fast path to supported little-endian x86-64 and
  AArch64 targets and improved GCC, Clang, and MSVC portability.
- Hardened restoration validation: invalid page parameters, empty or
  non-page-aligned bitmaps, and oversized layouts are rejected instead of
  being truncated or causing arithmetic failures.
- Improved Python wheel/sdist portability and added CPython 3.9–3.13 wheels
  for Linux x86-64/AArch64, macOS Apple Silicon, and Windows AMD64.

### Published artifacts

- C/C++: GitHub source archives at the alias repository tags `v1.3.0` and
  `v1.3.1` contain the same source snapshot.
- Go: module `github.com/PeterRK/PageBloomFilter` at `v1.3.0` or `v1.3.1`;
  the public package is imported as
  `github.com/PeterRK/PageBloomFilter/go`.
- Java: `io.github.peterrk:pbf:1.3.0` on Maven Central.
- .NET: `PageBloomFilter` 1.3.0 on NuGet.org.
- Python: `pagebloomfilter` 1.3.0 on PyPI; the import name is `pbf`.
- Rust: use `pagebloomfilter` 1.3.1. Version 1.3.0 is yanked.
- TypeScript: implementation and package metadata are included in the source
  tree, but `pagebloomfilter` was not published to npm.

## Earlier release lines

### v1.2.x

- Added Go as an officially supported and distributed implementation alongside
  C++.

### v1.0.x

- Established the original formally released C++ implementation.
