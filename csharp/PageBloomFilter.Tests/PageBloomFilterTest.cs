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

        [Test]
        public void CreateSmallTest() {
            var bf = PageBloomFilter.New(1, 0.1);
            Assert.That(bf.Way, Is.EqualTo(4));
            Assert.That(bf.PageLevel, Is.EqualTo(6));
            Assert.That(bf.PageNum, Is.EqualTo(1));
            Assert.That(bf.Data.Length, Is.EqualTo(64));
        }

        [Test]
        public void PageNumLimitTest() {
            Assert.Throws<ArgumentException>(() => PageBloomFilter.New(4, 6, 1U << 18));
        }

        [Test]
        public void StableBitmapLayoutTest() {
            var bf = PageBloomFilter.New(1, 0.01);
            byte[][] keys = {
                System.Text.Encoding.UTF8.GetBytes("alpha"),
                System.Text.Encoding.UTF8.GetBytes("中文键"),
                System.Array.Empty<byte>(),
                new byte[] { 0x00, 0x01, 0x02, 0x03, 0xff },
            };
            foreach (var key in keys) {
                Assert.That(bf.Set(key), Is.True);
            }

            var expected = System.Convert.FromHexString(
                "0000000010000000000000004000000000000000000000100100000000010000" +
                "0000000200000000000000000000040000000000040000008040000000000000" +
                "0000004000004180020000002000000000000100080080000000800000000010" +
                "0000000080000000000000000000410000800040000000800000000000002000");
            Assert.That(bf.Data.ToArray(), Is.EqualTo(expected));
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

        [Test]
        public void ClearResetsUniqueCountTest() {
            PageBloomFilter bf = PageBloomFilter.New(4, 7, 3);
            var key = new Span<byte>(new byte[8]);
            BitConverter.TryWriteBytes(key, 123L);

            Assert.That(bf.Set(key), Is.True);
            Assert.That(bf.UniqueCnt, Is.EqualTo(1));
            Assert.That(bf.Test(key), Is.True);

            bf.Clear();

            Assert.That(bf.UniqueCnt, Is.EqualTo(0));
            Assert.That(bf.Test(key), Is.False);
        }
    }
}
