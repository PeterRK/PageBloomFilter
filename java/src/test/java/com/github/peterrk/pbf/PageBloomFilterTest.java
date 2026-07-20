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
    public void pageNumLimitTest() {
        Assertions.assertThrows(IllegalArgumentException.class,
                () -> PageBloomFilter.New(4, 6, 1 << 18));
    }

    @Test
    public void stableBitmapLayoutTest() {
        PageBloomFilter bf = PageBloomFilter.New(1, 0.01);
        byte[][] keys = {
                "alpha".getBytes(java.nio.charset.StandardCharsets.UTF_8),
                "中文键".getBytes(java.nio.charset.StandardCharsets.UTF_8),
                new byte[0],
                new byte[] {0x00, 0x01, 0x02, 0x03, (byte)0xff},
        };
        for (byte[] key : keys) {
            Assertions.assertTrue(bf.set(key));
        }

        byte[] expected = fromHex(
                "0000000010000000000000004000000000000000000000100100000000010000"
              + "0000000200000000000000000000040000000000040000008040000000000000"
              + "0000004000004180020000002000000000000100080080000000800000000010"
              + "0000000080000000000000000000410000800040000000800000000000002000");
        ByteBuffer view = bf.getData();
        byte[] actual = new byte[view.remaining()];
        view.get(actual);
        Assertions.assertArrayEquals(expected, actual);
    }

    private static byte[] fromHex(String hex) {
        byte[] result = new byte[hex.length() / 2];
        for (int i = 0; i < result.length; i++) {
            result[i] = (byte)Integer.parseInt(hex.substring(i * 2, i * 2 + 2), 16);
        }
        return result;
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
