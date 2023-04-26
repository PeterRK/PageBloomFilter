# PageBloomFilter

采用分页设计的布隆过滤器，兼顾存储密度与访问性能。

## Benchmark
![](images/Xeon-8374C.png)
在Xeon-8374C上测试50万元素，平均每次操作小于25ns，SIMD能有效加速查询操作。

![](images/EPYC-7K83.png)
在EPYC-7K83上测试表现略逊，SIMD加速效果不明显。

## Go版

```go
// 有效容量500，假阳率0.01
bf := NewBloomFilter(500, 0.01)
if bf.Set("Hello") {
    fmt.Println("set new Hello")
}
if bf.Test("Hello") {
    fmt.Println("find Hello")
}
```

除了原生实现，在AMD64环境中还提供基于**函数注入技术**的实现，具体而言就是将C函数编译后注入到Go程序中以免除CGO的调用开销。在Xeon-8374C上测试50万元素，Go注入版较原生版有一倍左右的性能提升，仅比C++版略慢。

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

AMD64环境中注入版默认开启，编译前最好先执行[go-inject.sh](pbf/go-inject.sh)生成新的注入函数。注入函数生成脚本依赖clang和binutils，以及python，建议在Linux环境执行。

[测评](https://gist.github.com/PeterRK/b0df9e80caaaee1e9349e295cb435a67) 表明本实现比知名的 [bits-and-blooms](https://github.com/bits-and-blooms/bloom)要快3倍：
```
cpu: Intel(R) Core(TM) i7-10710U CPU @ 1.10GHz
BenchmarkBitsAndBloomSet-6               1000000               140.0 ns/op
BenchmarkBitsAndBloomTest-6              1000000                81.68 ns/op
BenchmarkPageBloomFilterSet-6            1000000                32.12 ns/op
BenchmarkPageBloomFilterTest-6           1000000                20.58 ns/op
```

## Java版
```java
PageBloomFilter bf = PageBloomFilter.New(500, 0.01);
byte[] hello = "Hello".getBytes("UTF-8");
if (bf.set(hello)) {
    System.out.println("set new Hello");
}
if (bf.test(hello)) {
    System.out.println("find Hello");
}
```
[测评](java/src/test/java/rk/pbf/Benchmark.java) 表明本实现比Google的Guava要快很多。不过，由于缺少针对性优化，Java版没有Go版快。
```
// i7-10710U & OpenJDK-17
pbf-set:     61.864632 ns/op
pbf-test:    45.849427 ns/op
guava-set:  144.784601 ns/op
guava-test: 122.613304 ns/op
```

## C#版
```csharp
var bf = PageBloomFilter.New(N, 0.01);
var hello = Encoding.ASCII.GetBytes("Hello")
if (bf.Set(hello)) {
    Console.WriteLine("set new Hello");
}
if (bf.Test(hello)) {
    Console.WriteLine("find Hello");
}
```
C#版代码和Java版高度一致，不过跑出来要慢不少。
```
// i7-10710U & .NET-7
pbf-set:  84.150676 ns/op
pbf-test: 76.069641 ns/op
```

## Python版
```python
bf = pbf.create(500, 0.01)
if bf.set("Hello"):
    print("set new Hello")
if bf.test("Hello"):
    print("find Hello")
```
Python版基于C扩展实现，不过还是慢。
```
// i7-10710U & Python-3.11.3
pbf-set:  307.835638 ns/op
pbf-test: 289.679349 ns/op
```

## 理论分析

### 每元素字节数与假阳率的关系
![](images/byte.png)

### 容积率与假阳率的关系
![](images/ratio.png)

---
[【中文】](README-CN.md) [【英文】](README.md)