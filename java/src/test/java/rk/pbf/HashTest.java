package rk.pbf;

import rk.pbf.Hash;
import rk.pbf.Hash.V128;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.Assertions;
import java.nio.charset.StandardCharsets;
import java.util.Arrays;


public class HashTest {
    
    @Test
    public void stableTest() {
        V128[] expected = {
                new V128(0x232706fc6bf50919L,0x8b72ee65b4e851c7L),
                new V128(0x50209687d54ec67eL,0x62fe85108df1cf6dL),
                new V128(0xfbe67d8368f3fb4fL,0xb54a5a89706d5a5aL),
                new V128(0x2882d11a5846ccfaL,0x6b21b0e870109222L),
                new V128(0xf5e0d56325d6d000L,0xaf8703c9f9ac75e5L),
                new V128(0x59a0f67b7ae7a5adL,0x84d7aeabc053b848L),
                new V128(0xf01562a268e42c21L,0xdfe994ab22873e7eL),
                new V128(0x16133104620725ddL,0xa5ca36afa7182e6aL),
                new V128(0x7a9378dcdf599479L,0x30f5a569a74ecdd7L),
                new V128(0xd9f07bdc76c20a78L,0x34f0621847f7888aL),
                new V128(0x332a4fff07df83daL,0xfa40557cc0ea6b72L),
                new V128(0x976beeefd11659dcL,0x8a3187b6a72d0039L),
                new V128(0xc3fcc139e4c6832aL,0xdadfeff6e01e2f2eL),
                new V128(0x86130593c7746a6fL,0x8ac9fb14904fe39dL),
                new V128(0x70550dbe5cdde280L,0xddb95757282706c0L),
                new V128(0x67211fbaf6b9122dL,0x68f4e8f3bbc700dbL),
                new V128(0xe2d06846964b80adL,0x6005068ac75c4c20L),
                new V128(0xd55b3c010258ce93L,0x981c8b03659d9950L),
                new V128(0x5a2507daa032fa13L,0x0d1c989bfc0c6cf7L),
                new V128(0xaf8618678ae5cd55L,0xe0b75cfad427eefcL),
                new V128(0xad5a7047e8a139d8L,0x183621cf988a753eL),
                new V128(0x8fc110192723cd5eL,0x203129f80764b844L),
                new V128(0x50170b4485d7af19L,0x7f2c79d145db7d35L),
                new V128(0x7c32444652212bf3L,0x27fd51b9156e2ad2L),
                new V128(0x90e571225cce7360L,0xf743b8f6f7433428L),
                new V128(0x9919537c1add41e1L,0x7ff0158f05b261f2L),
                new V128(0x3a70a8070883029fL,0xc5dcba911815d20aL),
                new V128(0xcc32b418290e2879L,0xbb7945d6d79b5dfbL),
                new V128(0xde493e4646077aebL,0x465c2ea52660973aL),
                new V128(0x4d3ad9b55316f970L,0x9137e3040a7d87bbL),
                new V128(0x1547de75efe848f4L,0x21ae3f08b5330aacL),
                new V128(0xe2ead0cc6aab6affL,0x29a20bccf77e70a7L),
                new V128(0x3dc2f4a9e9b451b4L,0x27de306dde7b60d2L),
                new V128(0xce247654a4de9f51L,0x040097e45e948d66L),
                new V128(0xbc118f2ba2305503L,0x810f05d0ea32853fL),
                new V128(0xb55cd8bdcac2a118L,0x4e93b65164705d2aL),
                new V128(0xb7c97db807c32f38L,0x510723230adef63dL),
        };
        byte[] buf = "0123456789abcdefghijklmnopqrstuvwxyz".getBytes(StandardCharsets.UTF_8);
        for (int i = 0; i < expected.length; i++) {
            V128 code = Hash.hash128(Arrays.copyOfRange(buf, 0, i));
            Assertions.assertEquals(code, expected[i]);
        }


    }
}
