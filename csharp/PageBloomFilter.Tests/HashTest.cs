// Copyright (c) 2023, Ruan Kunliang.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

using NUnit.Framework;
using System.Text;
using static PageBloomFilter.Hash;

namespace PageBloomFilter.Tests {
    public class HashTest {

        [Test]
        public void StableTest() {

            V128[] expected = 
            {
                new V128(0x232706fc6bf50919UL,0x8b72ee65b4e851c7UL),
                new V128(0x50209687d54ec67eUL,0x62fe85108df1cf6dUL),
                new V128(0xfbe67d8368f3fb4fUL,0xb54a5a89706d5a5aUL),
                new V128(0x2882d11a5846ccfaUL,0x6b21b0e870109222UL),
                new V128(0xf5e0d56325d6d000UL,0xaf8703c9f9ac75e5UL),
                new V128(0x59a0f67b7ae7a5adUL,0x84d7aeabc053b848UL),
                new V128(0xf01562a268e42c21UL,0xdfe994ab22873e7eUL),
                new V128(0x16133104620725ddUL,0xa5ca36afa7182e6aUL),
                new V128(0x7a9378dcdf599479UL,0x30f5a569a74ecdd7UL),
                new V128(0xd9f07bdc76c20a78UL,0x34f0621847f7888aUL),
                new V128(0x332a4fff07df83daUL,0xfa40557cc0ea6b72UL),
                new V128(0x976beeefd11659dcUL,0x8a3187b6a72d0039UL),
                new V128(0xc3fcc139e4c6832aUL,0xdadfeff6e01e2f2eUL),
                new V128(0x86130593c7746a6fUL,0x8ac9fb14904fe39dUL),
                new V128(0x70550dbe5cdde280UL,0xddb95757282706c0UL),
                new V128(0x67211fbaf6b9122dUL,0x68f4e8f3bbc700dbUL),
                new V128(0xe2d06846964b80adUL,0x6005068ac75c4c20UL),
                new V128(0xd55b3c010258ce93UL,0x981c8b03659d9950UL),
                new V128(0x5a2507daa032fa13UL,0x0d1c989bfc0c6cf7UL),
                new V128(0xaf8618678ae5cd55UL,0xe0b75cfad427eefcUL),
                new V128(0xad5a7047e8a139d8UL,0x183621cf988a753eUL),
                new V128(0x8fc110192723cd5eUL,0x203129f80764b844UL),
                new V128(0x50170b4485d7af19UL,0x7f2c79d145db7d35UL),
                new V128(0x7c32444652212bf3UL,0x27fd51b9156e2ad2UL),
                new V128(0x90e571225cce7360UL,0xf743b8f6f7433428UL),
                new V128(0x9919537c1add41e1UL,0x7ff0158f05b261f2UL),
                new V128(0x3a70a8070883029fUL,0xc5dcba911815d20aUL),
                new V128(0xcc32b418290e2879UL,0xbb7945d6d79b5dfbUL),
                new V128(0xde493e4646077aebUL,0x465c2ea52660973aUL),
                new V128(0x4d3ad9b55316f970UL,0x9137e3040a7d87bbUL),
                new V128(0x1547de75efe848f4UL,0x21ae3f08b5330aacUL),
                new V128(0xe2ead0cc6aab6affUL,0x29a20bccf77e70a7UL),
                new V128(0x3dc2f4a9e9b451b4UL,0x27de306dde7b60d2UL),
                new V128(0xce247654a4de9f51UL,0x040097e45e948d66UL),
                new V128(0xbc118f2ba2305503UL,0x810f05d0ea32853fUL),
                new V128(0xb55cd8bdcac2a118UL,0x4e93b65164705d2aUL),
                new V128(0xb7c97db807c32f38UL,0x510723230adef63dUL),
            };
            byte[] buf = Encoding.ASCII.GetBytes("0123456789abcdefghijklmnopqrstuvwxyz");
            for (int i = 0; i < expected.Length; i++) {
                V128 code = Hash128(buf[0..i]);
                Assert.AreEqual(expected[i]， code);
            }
        }
    }
}