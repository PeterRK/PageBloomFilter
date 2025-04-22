// Copyright (c) 2023, Ruan Kunliang.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

using NUnit.Framework;

namespace PageBloomFilter.Tests {
    public class PageBloomFilterTest {

        [Test]
        public void CreateTest() {
            var bf = PageBloomFilter.New(500, 0.01);
            Assert.That(bf.Way, Is.EqualTo(7));
            Assert.That(bf.PageLevel, Is.EqualTo(7));
            Assert.That(bf.Data.Length, Is.EqualTo(640));
        }

        private static void DoTest(int way) {
            PageBloomFilter bf = PageBloomFilter.New(way, 7, 3);
            var key = new Span<byte>(new byte[8]);
            for (long i = 0; i < 200; i++) {
                BitConverter.TryWriteBytes(key, i);
                Assert.That(bf.Set(key), Is.True);
            }
            for (long i = 0; i < 200; i++) {
                BitConverter.TryWriteBytes(key, i);
                Assert.That(bf.Test(key), Is.True);
            }
            for (long i = 200; i < 400; i++) {
                BitConverter.TryWriteBytes(key, i);
                Assert.That(bf.Test(key), Is.False);
            }
        }

        [Test]
        public void OperateTest() {
            for (int i = 4; i <= 8; i++) {
                DoTest(i);
            }
        }
    }
}