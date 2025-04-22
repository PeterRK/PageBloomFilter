// Copyright (c) 2023, Ruan Kunliang.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

using BloomFilter;
using System.Diagnostics;

namespace PageBloomFilter.Benchmark {
    public class Program {

        public struct DeltaTime {
            public TimeSpan set;
            public TimeSpan test;
            public DeltaTime(TimeSpan set, TimeSpan test) {
                this.set = set;
                this.test = test;
            }
        }

        private const long N = 1000000L;

        private static DeltaTime DoBenchmark(PageBloomFilter bf) {
            var key = new Span<byte>(new byte[8]);

            var set = new Stopwatch();
            set.Start();
            for (long i = 0; i < N; i += 2) {
                BitConverter.TryWriteBytes(key, i);
                bf.Set(key);
            }
            set.Stop();

            var test = new Stopwatch();
            test.Start();
            for (long i = 0; i < N; i++) {
                BitConverter.TryWriteBytes(key, i);
                bf.Test(key);
            }
            test.Stop();

            return new DeltaTime(set.Elapsed, test.Elapsed);
        }

        private static DeltaTime DoBenchmark(IBloomFilter bf) {
            var key = new Span<byte>(new byte[8]);

            var set = new Stopwatch();
            set.Start();
            for (long i = 0; i < N; i += 2) {
                BitConverter.TryWriteBytes(key, i);
                bf.Add(key);
            }
            set.Stop();

            var test = new Stopwatch();
            test.Start();
            for (long i = 0; i < N; i++) {
                BitConverter.TryWriteBytes(key, i);
                bf.Contains(key);
            }
            test.Stop();

            return new DeltaTime(set.Elapsed, test.Elapsed);
        }

        public static void Main(string[] args) {
            var bf = PageBloomFilter.New(N, 0.01);
            var key = new Span<byte>(new byte[8]);

            // warm up
            for (long i = 0; i < N; i++) {
                BitConverter.TryWriteBytes(key, i);
                bf.Set(key);
                bf.Test(key);
            }

            const int loop = 100;
            var set = new TimeSpan(0);
            var test = new TimeSpan(0);
            for (int i = 0; i < loop; i++) {
                bf.Clear();
                var delta = DoBenchmark(bf);
                set += delta.set;
                test += delta.test;
            }

            Console.Write("pbf-set: {0} ns/op\n", set.TotalNanoseconds / (loop * N / 2));
            Console.Write("pbf-test: {0} ns/op\n", test.TotalNanoseconds / (loop * N));


            var bf2 = FilterBuilder.Build(N, 0.01);
            // warm up
            for (long i = 0; i < N; i++) {
                BitConverter.TryWriteBytes(key, i);
                bf2.Add(key);
                bf2.Contains(key);
            }

            set = new TimeSpan(0);
            test = new TimeSpan(0);
            for (int i = 0; i < loop; i++) {
                bf.Clear();
                var delta = DoBenchmark(bf2);
                set += delta.set;
                test += delta.test;
            }

            Console.Write("bf.nc-set: {0} ns/op\n", set.TotalNanoseconds / (loop * N / 2));
            Console.Write("bf.nc-test: {0} ns/op\n", test.TotalNanoseconds / (loop * N));
        }
    }
}
