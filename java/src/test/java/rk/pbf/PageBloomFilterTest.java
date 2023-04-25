// Copyright (c) 2023, Ruan Kunliang.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

package rk.pbf;

import rk.pbf.PageBloomFilter;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.Assertions;
import java.nio.ByteBuffer;
import java.nio.ByteOrder;


public class PageBloomFilterTest {

    @Test
    public void createTest() {
        PageBloomFilter bf = PageBloomFilter.New(500, 0.01);
        Assertions.assertEquals(bf.getWay(), 7);
        Assertions.assertEquals(bf.getPageLevel(), 8);
        Assertions.assertEquals(bf.getData().length, 768);
    }


    @Test
    public void operateTest() {
        for (int i = 4; i <= 8; i++) {
            test(i);
        }
    }

    private static void intToKey(long num, byte[] buf) {
        ByteBuffer bb = ByteBuffer.wrap(buf);
        bb.order(ByteOrder.LITTLE_ENDIAN);
        bb.putLong(num);
    }

    private void test(int way) {
        PageBloomFilter bf = new PageBloomFilter(way, 7, 3);
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
