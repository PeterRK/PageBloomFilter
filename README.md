# PageBloomFilter

Bloom filter with page, designed for storage density and query speed.

## Benchmark
![](images/Xeon-8374C.png)
We got average latency per operation under 25ns in a benchmark with 500k elements on a Xeon-8374C machine. SIMD brings significant speed-up.

![](images/EPYC-7K83.png)
It runs slower on EPYC-7K83 machine.

## Go Version

```go
// BloomFilter with 0.01 false positive rate for 500 items
bf := NewBloomFilter(500, 0.01)
if bf.Set("Hello") {
	fmt.Println("set new Hello")
}
if bf.Test("Hello") {
	fmt.Println("find Hello")
}
```

**Function injection techique** is avaliable for AMD64. It uses code compiled by clang in Go without CGO. A benchmark with 500k elements on a Xeon-8374C machine shows new implement runs much fast than the pure go implement.

```
name   old time/op  new time/op  delta
Set4   53.6ns ± 6%  26.5ns ± 6%  -50.52%  (p=0.000 n=20+20)
Test4  40.5ns ± 5%  21.2ns ± 5%  -47.63%  (p=0.000 n=20+18)
Set5   56.4ns ± 5%  28.0ns ± 5%  -50.34%  (p=0.000 n=20+19)
Test5  41.5ns ± 3%  18.8ns ± 7%  -54.72%  (p=0.000 n=20+19)
Set6   57.6ns ± 5%  29.1ns ± 5%  -49.44%  (p=0.000 n=20+20)
Test6  42.2ns ± 4%  18.5ns ± 7%  -56.22%  (p=0.000 n=20+18)
Set7   58.8ns ± 4%  30.8ns ± 9%  -47.68%  (p=0.000 n=20+20)
Test7  43.9ns ± 6%  18.9ns ± 8%  -56.98%  (p=0.000 n=20+19)
Set8   58.4ns ± 9%  32.4ns ± 5%  -44.53%  (p=0.000 n=20+19)
Test8  44.8ns ± 2%  18.4ns ± 7%  -58.86%  (p=0.000 n=19+20)
```

We suggest that user should execute [go-inject.sh](pbf/go-inject.sh) to gnerate new injecting code before build. Clang, binutils and python are needed.

[Benchmark](https://gist.github.com/PeterRK/b0df9e80caaaee1e9349e295cb435a67) shows it runs 3x time faster than another famous bloom filter implement [bits-and-blooms](https://github.com/bits-and-blooms/bloom):
```
cpu: Intel(R) Core(TM) i7-10710U CPU @ 1.10GHz
BenchmarkBitsAndBloomSet-6               1000000               140.0 ns/op
BenchmarkBitsAndBloomTest-6              1000000                81.68 ns/op
BenchmarkPageBloomFilterSet-6            1000000                32.12 ns/op
BenchmarkPageBloomFilterTest-6           1000000                20.58 ns/op
```

## Java Version
```java
PageBloomFilter bf = PageBloomFilter.New(500, 0.01);
byte[] hello = "Hello".getBytes("UTF-8");
if (bf.set(hello)) {
	System.out.println("set new Hello")
}
if (bf.test(hello)) {
	System.out.println("find Hello")
}
```
[Benchmark](java/src/test/java/rk/pbf/Benchmark.java) shows it runs much faster than Google's Guava. We see Java version without dedicated optimization is inferior to the Go version.
```
// i7-10710U & OpenJDK-17
pbf-set:     61.864632 ns/op
pbf-test:    45.849427 ns/op
guava-set:  144.784601 ns/op
guava-test: 122.613304 ns/op
```

## Theoretical Analysis

### Bytes per element - False positive rate
![](images/byte.png)

### Occupied ratio - False positive rate
![](images/ratio.png)

---
[【Chinese】](README-CN.md) [【English】](README.md)