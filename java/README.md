# PageBloomFilter for Java

Fast page-based Bloom filter for Java 11 and newer.

```xml
<dependency>
    <groupId>com.github.peterrk</groupId>
    <artifactId>pbf</artifactId>
    <version>1.3.0</version>
</dependency>
```

```java
import com.github.peterrk.pbf.PageBloomFilter;
import java.nio.charset.StandardCharsets;

PageBloomFilter filter = PageBloomFilter.New(500, 0.01);
byte[] key = "Hello".getBytes(StandardCharsets.UTF_8);

filter.set(key);
System.out.println(filter.test(key));
```

Source: https://github.com/PeterRK/PageBloomFilter

License: BSD-3-Clause
