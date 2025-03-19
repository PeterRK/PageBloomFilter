# PageBloomFilter

采用分页设计的布隆过滤器，兼顾存储密度与访问性能。

## C++
```cpp
auto bf = NEW_BLOOM_FILTER(500, 0.01);
if (bf.set("Hello")) {
    std::cout << "set new Hello" << std::endl;
}
if (bf.test("Hello")) {
    std::cout << "find Hello" << std::endl;
}
```

## Go

```go
// import "github.com/PeterRK/PageBloomFilter/go"
// 有效容量500，假阳率0.01
bf := pbf.NewBloomFilter(500, 0.01)
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

AMD64环境中注入版默认开启，编译前最好先执行[go-inject.sh](go/go-inject.sh)生成新的注入函数。注入函数生成脚本依赖clang和binutils，以及python，建议在Linux环境执行。

[测评](https://gist.github.com/PeterRK/b0df9e80caaaee1e9349e295cb435a67) 表明本实现比知名的 [bits-and-blooms](https://github.com/bits-and-blooms/bloom)和[Tyler Treat版](https://github.com/tylertreat/BoomFilters)要快2倍：
```
// i7-10710U & Go-1.20
BenchmarkPageBloomFilterSet-6        1000000            32.70 ns/op
BenchmarkPageBloomFilterTest-6       1000000            20.23 ns/op
BenchmarkBitsAndBloomSet-6           1000000           120.5  ns/op
BenchmarkBitsAndBloomTest-6          1000000            81.46 ns/op
BenchmarkTylerTreatSet-6             1000000            98.30 ns/op
BenchmarkTylerTreatTest-6            1000000            60.69 ns/op

// U7-155H & Go-1.20
BenchmarkPageBloomFilterSet-16       1000000            13.95 ns/op
BenchmarkPageBloomFilterTest-16      1000000             8.40 ns/op
BenchmarkBitsAndBloomSet-16          1000000            44.57 ns/op
BenchmarkBitsAndBloomTest-16         1000000            37.94 ns/op
BenchmarkTylerTreatSet-16            1000000            43.94 ns/op
BenchmarkTylerTreatTest-16           1000000            20.80 ns/op

// U7-155H & Go-1.24 (to fix: injection is broken since Go-1.21)
BenchmarkPageBloomFilterSet-16       1000000            26.35 ns/op
BenchmarkPageBloomFilterTest-16      1000000            23.97 ns/op
```

## Java
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
[测评](java/src/test/java/com/github/peterrk/pbf/BloomFilterBenchmark.java) 表明本实现比Google的[Guava](https://github.com/google/guava)要快很多，而有时稍逊于Alexandr Nikitin的[bloom-filter-scala](https://github.com/alexandrnikitin/bloom-filter-scala)。由于缺少针对性优化，Java版没有Go版快。
```
// i7-10710U & OpenJDK-17
pbfSet       50.962 ns/op
pbfTest      40.465 ns/op
pbfTest     133.514 ns/op
guavaTest   112.318 ns/op
nikitinSet   86.931 ns/op
nikitinTest  62.133 ns/op

// U7-155H & OpenJDK-21
pbfSet       24.562 ns/op
pbfTest      20.511 ns/op
guavaSet     44.889 ns/op
guavaTest    45.652 ns/op
nikitinSet   22.474 ns/op
nikitinTest  18.489 ns/op
```

## C#
```csharp
var bf = PageBloomFilter.New(500, 0.01);
var hello = Encoding.ASCII.GetBytes("Hello")
if (bf.Set(hello)) {
    Console.WriteLine("set new Hello");
}
if (bf.Test(hello)) {
    Console.WriteLine("find Hello");
}
```
C#版代码和Java版高度一致，不过跑出来要慢不少。性能胜过[BloomFilter.NetCore](https://github.com/vla/BloomFilter.NetCore)。
```
// i7-10710U & .NET-7
pbf-set:  83.461274 ns/op
pbf-test: 74.953785 ns/op

// U7-155H & .NET-9
pbf-set:     28.63103 ns/op
pbf-test:    22.88545 ns/op
bf.net-set:  41.66280 ns/op
bf.net-test: 40.12608 ns/op
```

## Python
```python
bf = pbf.create(500, 0.01)
if bf.set("Hello"):
    print("set new Hello")
if bf.test("Hello"):
    print("find Hello")
```
Python版基于C扩展实现，虽然还是慢，不过足以吊打[pybloom](https://github.com/jaybaird/python-bloomfilter)。
```
// i7-10710U & Python-3.11
pbf-set:       307.835638 ns/op
pbf-test:      289.679349 ns/op
pybloom-set:  2770.372372 ns/op
pybloom-test: 2417.377588 ns/op

// U7-155H & Python-3.12
pbf-set:  156.87409 ns/op
pbf-test: 115.30198 ns/op
```

## Rust
```rust
let mut bf = pbf::new_bloom_filter(500, 0.01);
let hello = "Hello".as_bytes();
if (bf.set(hello)) {
    println!("set new Hello");
}
if (bf.test(hello)) {
    println!("find Hello");
}
```
Rust版也缺少针对性优化，照样快过Java。看上去比[fastbloom](https://github.com/tomtomwombat/fastbloom)和[rust-bloom-filter](https://github.com/jedisct1/rust-bloom-filter)强。
```
// i7-10710U & Rust-1.65
pbf-set:  45.99ns/op
pbf-test: 27.81ns/op

// U7-155H & Rust-1.80
pbf-set:        19.85ns/op
pbf-test:       12.50ns/op
fastbloom-set:  19.97ns/op
fastbloom-test: 14.93ns/op
rbf-set:        36.51ns/op
rbf-test:       24.93ns/op
```

## 横向比较
![](images/U7-155H.png)
将在U7-155H上的测试数据放到一起看，可以得到性能排位：C++，Go，Rust，Java，C#，Python。

## 序列化与反序列化
不同语言实现的数据结构是一致，可以跨语言使用。虽然这里不提供专门的序列化和反序列化API，但也很容易实现：保存和加载`way`、`page_level`、`unique_cnt`三个参数，以及`data`的位图即可。其中`way`和`page_level`是个很小的整数， 可以分别用4bit表示。
```cpp
// C++
auto bf = pbf::New(500, 0.01);
auto bf2 = pbf::New(bf->way(), bf->page_level(), bf->data(), bf->data_size(), bf->unique_cnt());

// 示例格式（并非标准）
struct Pack {
    uint32_t way : 4;
    uint32_t page_level : 4;
    uint32_t unique_cnt : 24;
    uint32_t data_size;
    uint8_t data[0];
};
```
```go
// GO
bf := pbf.NewBloomFilter(500, 0.01)
bf2 := pbf.CreatePageBloomFilter(bf.Way(), bf.PageLevel(), bf.Data(), bf.Unique())
```
```java
// Java
PageBloomFilter bf = PageBloomFilter.New(500, 0.01);
PageBloomFilter bf2 = PageBloomFilter.New(bf.getWay(), bf.getPageLevel(), bf.getData(), bf.getUniqueCnt());
```
```csharp
// C#
var bf = PageBloomFilter.New(500, 0.01);
var bf2 = PageBloomFilter.New(bf.Way, bf.PageLevel, bf.Data, bf.UniqueCnt);
```
```python
# Python
bf = pbf.create(500, 0.01)
bf2 = pbf.restore(bf.way, bf.page_level, bf.data, bf.unique_cnt)
```
```rust
// Rust
let mut bf = pbf::new_bloom_filter(500, 0.01);
let mut bf2 = pbf::restore_pbf(bf.get_way(), bf.get_page_level(), bf.get_data(), bf.get_unique_cnt());
```

## 详细测试
![](images/Xeon-8374C.png)
在Xeon-8374C上测试50万元素，平均每次操作小于25ns，SIMD能有效加速查询操作。

![](images/EPYC-7K83.png)
在EPYC-7K83上测试表现略逊，SIMD加速效果不明显。

![](images/Xeon-8475B.png)
在Xeon-8475B上测试SIMD模式，使用aesni-hash可获得显著加速（**小于7ns的test操作**）。

![](images/EPYC-9T24.png)
在EPYC-9T24上测试SIMD模式，使用aesni-hash也可获得显著加速，但没有Intel平台上显著。

## 理论分析

### 每元素字节数与假阳率的关系
![](images/byte.png)

### 容积率与假阳率的关系
![](images/ratio.png)

---
[【中文】](README-CN.md) [【英文】](README.md)
