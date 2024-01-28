// Copyright (c) 2023, Ruan Kunliang.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

package com.github.peterrk.pbf;

import org.openjdk.jmh.annotations.*;

import java.nio.ByteBuffer;
import java.nio.ByteOrder;
import java.util.concurrent.TimeUnit;

@Fork(value = 1)
@BenchmarkMode(Mode.AverageTime)
@OutputTimeUnit(TimeUnit.MILLISECONDS)
@Warmup(iterations = 1, time = 1, timeUnit = TimeUnit.SECONDS)
@Measurement(iterations = 3, time = 2, timeUnit = TimeUnit.SECONDS)
public class BloomFilterBenchmark {

    private static final long N = 1000000;
    private static final double falsePositiveRate = 0.01;

    public static void main(String[] args) throws Exception {
        org.openjdk.jmh.Main.main(args);
    }

    @Benchmark
    public void pbfSet(PageBloomFilterSetState ctx) {
        byte[] key = new byte[8];
        for (long i = 0; i < N; i++) {
            ByteBuffer.wrap(key).order(ByteOrder.nativeOrder()).putLong(i);
            ctx.bf.set(key);
        }
    }

    @Benchmark
    public void pbfTest(PageBloomFilterTestState ctx) {
        byte[] key = new byte[8];
        for (long i = 0; i < N; i++) {
            ByteBuffer.wrap(key).order(ByteOrder.nativeOrder()).putLong(i);
            ctx.bf.test(key);
        }
    }

    @Benchmark
    public void guavaSet(GuavaSetState ctx) {
        byte[] key = new byte[8];
        for (long i = 0; i < N; i++) {
            ByteBuffer.wrap(key).order(ByteOrder.nativeOrder()).putLong(i);
            ctx.bf.put(key);
        }
    }

    @Benchmark
    public void guavaTest(GuavaTestState ctx) {
        byte[] key = new byte[8];
        for (long i = 0; i < N; i++) {
            ByteBuffer.wrap(key).order(ByteOrder.nativeOrder()).putLong(i);
            ctx.bf.mightContain(key);
        }
    }

    @Benchmark
    public void nikitinSet(NikitinSetState ctx) {
        byte[] key = new byte[8];
        for (long i = 0; i < N; i++) {
            ByteBuffer.wrap(key).order(ByteOrder.nativeOrder()).putLong(i);
            ctx.bf.add(key);
        }
    }

    @Benchmark
    public void nikitinTest(NikitinTestState ctx) {
        byte[] key = new byte[8];
        for (long i = 0; i < N; i++) {
            ByteBuffer.wrap(key).order(ByteOrder.nativeOrder()).putLong(i);
            ctx.bf.mightContain(key);
        }
    }

    @State(Scope.Thread)
    public static class PageBloomFilterSetState {
        private PageBloomFilter bf;

        @Setup(value = Level.Trial)
        public void setup() {
            bf = PageBloomFilter.New(N, 0.01);
        }

        @TearDown(value = Level.Invocation)
        public void tearDown() {
            bf.clear();
        }
    }

    @State(Scope.Thread)
    public static class PageBloomFilterTestState {
        private PageBloomFilter bf;

        @Setup(value = Level.Trial)
        public void setup() {
            bf = PageBloomFilter.New(N, falsePositiveRate);
            byte[] key = new byte[8];
            for (long i = 0; i < N; i += 2) {
                ByteBuffer.wrap(key).order(ByteOrder.nativeOrder()).putLong(i);
                bf.set(key);
            }
        }
    }

    @State(Scope.Thread)
    public static class GuavaSetState {
        private com.google.common.hash.BloomFilter<byte[]> bf;

        @Setup(value = Level.Trial)
        public void setup() {
            bf = com.google.common.hash.BloomFilter.create(
                    com.google.common.hash.Funnels.byteArrayFunnel(), N, falsePositiveRate);
        }
    }

    @State(Scope.Thread)
    public static class GuavaTestState {
        private com.google.common.hash.BloomFilter<byte[]> bf;

        @Setup(value = Level.Trial)
        public void setup() {
            bf = com.google.common.hash.BloomFilter.create(
                    com.google.common.hash.Funnels.byteArrayFunnel(), N, falsePositiveRate);
            byte[] key = new byte[8];
            for (long i = 0; i < N; i += 2) {
                ByteBuffer.wrap(key).order(ByteOrder.nativeOrder()).putLong(i);
                bf.put(key);
            }
        }
    }

    @State(Scope.Thread)
    public static class NikitinSetState {
        private bloomfilter.mutable.BloomFilter<byte[]> bf;

        @Setup(value = Level.Trial)
        public void setup() {
            bf = bloomfilter.mutable.BloomFilter.apply(
                    N, falsePositiveRate,
                    bloomfilter.CanGenerateHashFrom.CanGenerateHashFromByteArray$.MODULE$);
        }
    }

    @State(Scope.Thread)
    public static class NikitinTestState {
        private bloomfilter.mutable.BloomFilter<byte[]> bf;

        @Setup(value = Level.Trial)
        public void setup() {
            bf = bloomfilter.mutable.BloomFilter.apply(
                    N, falsePositiveRate,
                    bloomfilter.CanGenerateHashFrom.CanGenerateHashFromByteArray$.MODULE$);
            byte[] key = new byte[8];
            for (long i = 0; i < N; i += 2) {
                ByteBuffer.wrap(key).order(ByteOrder.nativeOrder()).putLong(i);
                bf.add(key);
            }
        }
    }
}
