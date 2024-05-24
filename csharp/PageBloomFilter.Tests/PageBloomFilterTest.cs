// Copyright (c) 2023, Ruan Kunliang.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

using NUnit.Framework;
using PageBloomFilter;

namespace PageBloomFilter.Tests {
    public class PageBloomFilterTest {

        [Test]
        public void CreateTest() {
            var bf = PageBloomFilter.New(500, 0.01);
            Assert.AreEqual(7, bf.Way);
            Assert.AreEqual(7, bf.PageLevel);
            Assert.AreEqual(640, bf.Data.Length);
        }

        private void doTest(int way) {
            PageBloomFilter bf = PageBloomFilter.New(way, 7, 3);
            var key = new byte[8];
            for (long i = 0; i < 200; i++) {
                BitConverter.TryWriteBytes(key, i);
                Assert.IsTrue(bf.Set(key));
            }
            for (long i = 0; i < 200; i++) {
                BitConverter.TryWriteBytes(key, i);
                Assert.IsTrue(bf.Test(key));
            }
            for (long i = 200; i < 400; i++) {
                BitConverter.TryWriteBytes(key, i);
                Assert.IsFalse(bf.Test(key));
            }
        }

        [Test]
        public void OperateTest() {
            for (int i = 4; i <= 8; i++) {
                doTest(i);
            }
        }
    }
}
