# PageBloomFilter

Bloom filter with page, designed for storage density and query speed.

## Benchmark
![](images/Xeon-8374C.png)
We got average latency per operation under 25ns in a benchmark with 500k elements on a Xeon-8374C machine. SIMD brings significant speed-up.

![](images/EPYC-7K83.png)
It runs slower on EPYC-7K83 machine.

## Theoretical Analysis

### Bytes per element - False positive rate
![](images/byte.png)

### Occupied ratio - False positive rate
![](images/ratio.png)

---
[【Chinese】](README-CN.md) [【English】](README.md)