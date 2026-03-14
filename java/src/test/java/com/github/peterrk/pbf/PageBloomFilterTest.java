// Copyright (c) 2023, Ruan Kunliang.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

package com.github.peterrk.pbf;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.Assertions;
import java.nio.ByteBuffer;
import java.nio.ByteOrder;


public class PageBloomFilterTest {

    @Test
    public void createTest() {
        PageBloomFilter bf = PageBloomFilter.New(500, 0.01);
        Assertions.assertEquals(7, bf.getWay());
        Assertions.assertEquals(7, bf.getPageLevel());
        Assertions.assertEquals(640, bf.getData().remaining());
    }

    @Test
    public void createSmallTest() {
        PageBloomFilter bf = PageBloomFilter.New(1, 0.1);
        Assertions.assertEquals(4, bf.getWay());
        Assertions.assertEquals(6, bf.getPageLevel());
        Assertions.assertEquals(1, bf.getPageNum());
        Assertions.assertEquals(64, bf.getData().remaining());
    }


    @Test
    public void operateTest() {
        for (int i = 4; i <= 8; i++) {
            test(i);
        }
    }

    @Test
    public void clearResetsUniqueCountTest() {
        PageBloomFilter bf = PageBloomFilter.New(4, 7, 3);
        byte[] key = new byte[8];
        intToKey(123, key);

        Assertions.assertTrue(bf.set(key));
        Assertions.assertEquals(1, bf.getUniqueCnt());
        Assertions.assertTrue(bf.test(key));

        bf.clear();

        Assertions.assertEquals(0, bf.getUniqueCnt());
        Assertions.assertFalse(bf.test(key));
    }

    private static void intToKey(long num, byte[] buf) {
        ByteBuffer bb = ByteBuffer.wrap(buf);
        bb.order(ByteOrder.LITTLE_ENDIAN);
        bb.putLong(num);
    }

    private void test(int way) {
        PageBloomFilter bf = PageBloomFilter.New(way, 7, 3);
        byte[] key = new byte[8];
        for (long i = 0; i < 200; i++) {
            intToKey(i, key);
            Assertions.assertTrue(bf.set(key));
        }
        for (long i = 0; i < 200; i++) {
            intToKey(i, key);
            Assertions.assertTrue(bf.test(key));
        }
        for (long i = 200; i < 400; i++) {
            intToKey(i, key);
            Assertions.assertFalse(bf.test(key));
        }
    }
}
