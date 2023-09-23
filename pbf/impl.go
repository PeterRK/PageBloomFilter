// Copyright (c) 2023, Ruan Kunliang.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

//go:build !amd64 || go1.21

package pbf

import (
	"encoding/binary"
	"unsafe"
)

func (bf *pbfW4) Set(key string) bool {
	return bf.set(4, key)
}

func (bf *pbfW4) Test(key string) bool {
	return bf.test(4, key)
}

func (bf *pbfW5) Set(key string) bool {
	return bf.set(5, key)
}

func (bf *pbfW5) Test(key string) bool {
	return bf.test(5, key)
}

func (bf *pbfW6) Set(key string) bool {
	return bf.set(6, key)
}

func (bf *pbfW6) Test(key string) bool {
	return bf.test(6, key)
}

func (bf *pbfW7) Set(key string) bool {
	return bf.set(7, key)
}

func (bf *pbfW7) Test(key string) bool {
	return bf.test(7, key)
}

func (bf *pbfW8) Set(key string) bool {
	return bf.set(8, key)
}

func (bf *pbfW8) Test(key string) bool {
	return bf.test(8, key)
}

func (bf *pageBloomFilter) set(way uint32, key string) bool {
	code, v := hash(key)
	page := bf.data[int(code%bf.pageNum)<<bf.pageLevel:]

	hit := byte(1)
	mask := uint16((1 << (bf.pageLevel + 3)) - 1)
	for i := uint32(0); i < way; i++ {
		idx := v[i] & mask
		bit := byte(1) << (idx & 7)
		hit &= page[idx>>3] >> (idx & 7)
		page[idx>>3] |= bit
	}
	if hit != 0 {
		return false
	}
	bf.uniqueCnt++
	return true
}

func (bf *pageBloomFilter) test(way uint32, key string) bool {
	code, v := hash(key)
	page := bf.data[int(code%bf.pageNum)<<bf.pageLevel:]

	mask := uint16((1 << (bf.pageLevel + 3)) - 1)
	for i := uint32(0); i < way; i++ {
		idx := v[i] & mask
		bit := byte(1) << (idx & 7)
		if (page[idx>>3] & bit) == 0 {
			return false
		}
	}
	return true
}

func rot32(x uint32, k int) uint32 {
	return (x << k) | (x >> (32 - k))
}

func hash(str string) (uint32, [8]uint16) {
	l, h := hash128(str)
	w := [4]uint32{uint32(l), uint32(l >> 32), uint32(h), uint32(h >> 32)}
	return rot32(w[0], 8) ^ rot32(w[1], 6) ^ rot32(w[2], 4) ^ rot32(w[3], 2),
		[8]uint16{
			uint16(w[0]), uint16(w[0] >> 16),
			uint16(w[1]), uint16(w[1] >> 16),
			uint16(w[2]), uint16(w[2] >> 16),
			uint16(w[3]), uint16(w[3] >> 16),
		}
}

func rot64(x uint64, k int) uint64 {
	return (x << k) | (x >> (64 - k))
}

type state struct {
	a, b, c, d uint64
}

func (s *state) mix() {
	s.c = rot64(s.c, 50)
	s.c += s.d
	s.a ^= s.c
	s.d = rot64(s.d, 52)
	s.d += s.a
	s.b ^= s.d
	s.a = rot64(s.a, 30)
	s.a += s.b
	s.c ^= s.a
	s.b = rot64(s.b, 41)
	s.b += s.c
	s.d ^= s.b
	s.c = rot64(s.c, 54)
	s.c += s.d
	s.a ^= s.c
	s.d = rot64(s.d, 48)
	s.d += s.a
	s.b ^= s.d
	s.a = rot64(s.a, 38)
	s.a += s.b
	s.c ^= s.a
	s.b = rot64(s.b, 37)
	s.b += s.c
	s.d ^= s.b
	s.c = rot64(s.c, 62)
	s.c += s.d
	s.a ^= s.c
	s.d = rot64(s.d, 34)
	s.d += s.a
	s.b ^= s.d
	s.a = rot64(s.a, 5)
	s.a += s.b
	s.c ^= s.a
	s.b = rot64(s.b, 36)
	s.b += s.c
	s.d ^= s.b
}

func (s *state) end() {
	s.d ^= s.c
	s.c = rot64(s.c, 15)
	s.d += s.c
	s.a ^= s.d
	s.d = rot64(s.d, 52)
	s.a += s.d
	s.b ^= s.a
	s.a = rot64(s.a, 26)
	s.b += s.a
	s.c ^= s.b
	s.b = rot64(s.b, 51)
	s.c += s.b
	s.d ^= s.c
	s.c = rot64(s.c, 28)
	s.d += s.c
	s.a ^= s.d
	s.d = rot64(s.d, 9)
	s.a += s.d
	s.b ^= s.a
	s.a = rot64(s.a, 47)
	s.b += s.a
	s.c ^= s.b
	s.b = rot64(s.b, 54)
	s.c += s.b
	s.d ^= s.c
	s.c = rot64(s.c, 32)
	s.d += s.c
	s.a ^= s.d
	s.d = rot64(s.d, 25)
	s.a += s.d
	s.b ^= s.a
	s.a = rot64(s.a, 63)
	s.b += s.a
}

func unsafeStrToBytes(s string) []byte {
	return *(*[]byte)(unsafe.Pointer(
		&struct {
			string
			Cap int
		}{s, len(s)},
	))
}

func u64to64(str string) uint64 {
	return binary.LittleEndian.Uint64(unsafeStrToBytes(str))
}

func u32to64(str string) uint64 {
	return uint64(binary.LittleEndian.Uint32(unsafeStrToBytes(str)))
}

func u16to64(str string) uint64 {
	return uint64(binary.LittleEndian.Uint16(unsafeStrToBytes(str)))
}

func hash128(str string) (uint64, uint64) {
	const magic uint64 = 0xdeadbeefdeadbeef
	s := state{0, 0, magic, magic}
	l := uint64(len(str))

	for ; len(str) >= 32; str = str[32:] {
		s.c += u64to64(str)
		s.d += u64to64(str[8:])
		s.mix()
		s.a += u64to64(str[16:])
		s.b += u64to64(str[24:])
	}
	if len(str) >= 16 {
		s.c += u64to64(str)
		s.d += u64to64(str[8:])
		s.mix()
		str = str[16:]
	}

	s.d += l << 56
	switch len(str) {
	case 15:
		s.d += uint64(str[14]) << 48
		fallthrough
	case 14:
		s.d += uint64(str[13]) << 40
		fallthrough
	case 13:
		s.d += uint64(str[12]) << 32
		fallthrough
	case 12:
		s.d += u32to64(str[8:])
		s.c += u64to64(str)
	case 11:
		s.d += uint64(str[10]) << 16
		fallthrough
	case 10:
		s.d += uint64(str[9]) << 8
		fallthrough
	case 9:
		s.d += uint64(str[8])
		fallthrough
	case 8:
		s.c += u64to64(str)
	case 7:
		s.c += uint64(str[6]) << 48
		fallthrough
	case 6:
		s.c += uint64(str[5]) << 40
		fallthrough
	case 5:
		s.c += uint64(str[4]) << 32
		fallthrough
	case 4:
		s.c += u32to64(str)
	case 3:
		s.c += uint64(str[2]) << 16
		fallthrough
	case 2:
		s.c += uint64(str[1]) << 8
		fallthrough
	case 1:
		s.c += uint64(str[0])
	case 0:
		s.c += magic
		s.d += magic
	}
	s.end()
	return s.a, s.b
}
