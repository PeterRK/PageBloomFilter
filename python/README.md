# pagebloomfilter

Fast page-based Bloom filter for CPython 3.9–3.13. The package name is
`pagebloomfilter`; the import name is `pbf`.

```shell
python -m pip install pagebloomfilter==1.3.0
```

```python
from pbf import PageBloomFilter

filter = PageBloomFilter.create(500, 0.01)
filter.set("Hello")
print(filter.test("Hello"))
```

Wheels are provided for Linux x86-64/AArch64, macOS Apple Silicon, and Windows
AMD64. Other supported x86-64/AArch64 platforms can build from the sdist.

Source: https://github.com/PeterRK/PageBloomFilter

License: BSD-3-Clause
