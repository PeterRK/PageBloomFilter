# PageBloomFilter

Fast page-based Bloom filter for .NET 8.

```csharp
using System.Text;
using PageBloomFilter;

var filter = PageBloomFilter.PageBloomFilter.New(500, 0.01);
var key = Encoding.UTF8.GetBytes("Hello");
filter.Set(key);
Console.WriteLine(filter.Test(key));
```

The bitmap format is compatible with the other PageBloomFilter language
implementations. Licensed under the BSD 3-Clause License.

Source and full documentation:
https://github.com/PeterRK/PageBloomFilter.
