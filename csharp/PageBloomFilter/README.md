# PageBloomFilter

Fast page-based Bloom filter for .NET 8.

```shell
dotnet add package PageBloomFilter --version 1.3.0
```

```csharp
using System.Text;
using PageBloomFilter;

var filter = PageBloomFilter.PageBloomFilter.New(500, 0.01);
var key = Encoding.UTF8.GetBytes("Hello");
filter.Set(key);
Console.WriteLine(filter.Test(key));
```

Source: https://github.com/PeterRK/PageBloomFilter

License: BSD-3-Clause
