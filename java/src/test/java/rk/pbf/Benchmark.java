// Copyright (c) 2023, Ruan Kunliang.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

package rk.pbf;

import rk.pbf.PageBloomFilter;
import java.nio.ByteBuffer;
import java.nio.ByteOrder;
import com.google.common.hash.BloomFilter;
import com.google.common.hash.Funnels;

public class Benchmark {
    private static void intToKey(long num, byte[] buf) {
        ByteBuffer bb = ByteBuffer.wrap(buf);
        bb.order(ByteOrder.LITTLE_ENDIAN);
        bb.putLong(num);
    }

    private static final class DeltaTime {
        public long set = 0;
        public long test = 0;
        DeltaTime(long set, long test) {
            this.set = set;
            this.test = test;
        }
    }


    private static final long N = 1000000;

    private static DeltaTime benchmark( PageBloomFilter bf) {
        byte[] key = new byte[8];

        long start = System.nanoTime();
        for (long i = 0; i < N; i += 2) {
            intToKey(i, key);
            bf.set(key);
        }
        long end = System.nanoTime();
        long deltaSet = end - start;

        start = System.nanoTime();
        for (long i = 0; i < N; i++) {
            intToKey(i, key);
            bf.test(key);
        }
        end = System.nanoTime();
        long deltaTest = end - start;

        return new DeltaTime(deltaSet,deltaTest);
    }

    private static DeltaTime benchmark(BloomFilter<byte[]> bf) {
        byte[] key = new byte[8];

        long start = System.nanoTime();
        for (long i = 0; i < N; i += 2) {
            intToKey(i, key);
            bf.put(key);
        }
        long end = System.nanoTime();
        long deltaSet = end - start;

        start = System.nanoTime();
        for (long i = 0; i < N; i++) {
            intToKey(i, key);
            bf.mightContain(key);
        }
        end = System.nanoTime();
        long deltaTest = end - start;

        return new DeltaTime(deltaSet,deltaTest);
    }

    public static void main(String[] argv) {
        int loop = 100;

        PageBloomFilter bf1 = PageBloomFilter.New(N, 0.01);
        benchmark(bf1); //warm up

        long set = 0;
        long test = 0;
        for (int i = 0; i < loop; i++) {
            DeltaTime delta = benchmark(bf1);
            set += delta.set;
            test += delta.test;
            bf1.clear();
        }
        System.out.printf("pbf-set: %f ns/op\n", set / (double)(loop*N/2));
        System.out.printf("pbf-test: %f ns/op\n", test / (double)(loop*N));


        BloomFilter<byte[]> bf2 = BloomFilter.create(Funnels.byteArrayFunnel(), N, 0.01);
        benchmark(bf2); //warm up

        set = 0;
        test = 0;
        for (int i = 0; i < loop; i++) {
            DeltaTime delta = benchmark(bf2);
            set += delta.set;
            test += delta.test;
            // no clean api
        }
        System.out.printf("guava-set: %f ns/op\n", set / (double)(loop*N/2));
        System.out.printf("guava-test: %f ns/op\n", test / (double)(loop*N));
    }
}
