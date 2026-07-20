// Copyright (c) 2023, Ruan Kunliang.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

package pbf

import (
	"bytes"
	"encoding/binary"
	"encoding/hex"
	"testing"
	"unsafe"
)

func assert(t *testing.T, state bool) {
	if !state {
		t.FailNow()
	}
}

func TestNew(t *testing.T) {
	bf := NewBloomFilter(500, 0.01)
	assert(t, bf != nil)
	assert(t, bf.Way() == 7)
	assert(t, bf.PageLevel() == 7)
	assert(t, len(bf.Data()) == 640)
}

func TestSmallEstimate(t *testing.T) {
	bf := NewBloomFilter(1, 0.1)
	assert(t, bf != nil)
	assert(t, bf.Way() == 4)
	assert(t, bf.PageLevel() == 6)
	assert(t, len(bf.Data()) == 64)
}

func TestPageNumLimit(t *testing.T) {
	if bf := NewPageBloomFilter(4, 6, 1<<18); bf != nil {
		t.Fatal("page count at the exclusive limit must be rejected")
	}
}

func TestCreateRejectsInvalidLayoutWithoutPanicking(t *testing.T) {
	tests := []struct {
		name      string
		way       uint32
		pageLevel uint32
	}{
		{name: "way below range", way: 0, pageLevel: 7},
		{name: "way above range", way: 9, pageLevel: 7},
		{name: "page level below range", way: 4, pageLevel: 5},
		{name: "page level above range", way: 4, pageLevel: 14},
		{name: "page level maximum uint32", way: 4, pageLevel: ^uint32(0)},
	}
	for _, test := range tests {
		t.Run(test.name, func(t *testing.T) {
			if bf := CreatePageBloomFilter(test.way, test.pageLevel, []byte{0}, 0); bf != nil {
				t.Fatal("invalid layout must be rejected")
			}
		})
	}
}

func TestCreateCopiesValidBitmap(t *testing.T) {
	data := make([]byte, 1<<6)
	data[3] = 0x80
	bf := CreatePageBloomFilter(4, 6, data, 7)
	if bf == nil {
		t.Fatal("valid layout was rejected")
	}
	if bf.Unique() != 7 || !bytes.Equal(bf.Data(), data) {
		t.Fatal("restored state does not match input")
	}
	data[3] = 0
	if bf.Data()[3] != 0x80 {
		t.Fatal("restored bitmap must not alias input data")
	}
}

func TestStableBitmapLayout(t *testing.T) {
	bf := NewBloomFilter(1, 0.01)
	if bf == nil {
		t.Fatal("failed to create minimal bloom filter")
	}
	keys := []string{
		"alpha",
		"中文键",
		"",
		string([]byte{0x00, 0x01, 0x02, 0x03, 0xff}),
	}
	for _, key := range keys {
		if !bf.Set(key) {
			t.Fatalf("key %x was unexpectedly already present", []byte(key))
		}
	}

	expected, err := hex.DecodeString(
		"0000000010000000000000004000000000000000000000100100000000010000" +
			"0000000200000000000000000000040000000000040000008040000000000000" +
			"0000004000004180020000002000000000000100080080000000800000000010" +
			"0000000080000000000000000000410000800040000000800000000000002000",
	)
	if err != nil {
		t.Fatal(err)
	}
	if !bytes.Equal(expected, bf.Data()) {
		t.Fatalf("bitmap mismatch: want %x; got %x", expected, bf.Data())
	}
}

func doTest(t *testing.T, way uint32) {
	bf := NewPageBloomFilter(way, 7, 3)
	assert(t, bf != nil)

	var tmp [8]byte
	slc := tmp[:]
	key := *(*string)(unsafe.Pointer(&slc))
	for i := uint64(0); i < 200; i++ {
		binary.LittleEndian.PutUint64(slc, i)
		assert(t, bf.Set(key))
	}
	for i := uint64(0); i < 200; i++ {
		binary.LittleEndian.PutUint64(slc, i)
		assert(t, bf.Test(key))
	}
	for i := uint64(200); i < 400; i++ {
		binary.LittleEndian.PutUint64(slc, i)
		assert(t, !bf.Test(key))
	}
}

func TestW4(t *testing.T) { doTest(t, 4) }
func TestW5(t *testing.T) { doTest(t, 5) }
func TestW6(t *testing.T) { doTest(t, 6) }
func TestW7(t *testing.T) { doTest(t, 7) }
func TestW8(t *testing.T) { doTest(t, 8) }

func benchSet(b *testing.B, way uint32) {
	b.StopTimer()
	tmp := make([]byte, b.N*8)
	keys := make([]string, b.N)
	for i := 0; i < b.N; i++ {
		slc := tmp[i*8 : (i+1)*8]
		keys[i] = *(*string)(unsafe.Pointer(&slc))
		binary.LittleEndian.PutUint64(slc, uint64(i))
	}
	bf := NewPageBloomFilter(way, 12, uint32(b.N/2048)+1)
	b.StartTimer()
	for i := 0; i < b.N; i++ {
		bf.Set(keys[i])
	}
}

func benchTest(b *testing.B, way uint32) {
	b.StopTimer()
	tmp := make([]byte, b.N*8)
	keys := make([]string, b.N)
	for i := 0; i < b.N; i++ {
		slc := tmp[i*8 : (i+1)*8]
		keys[i] = *(*string)(unsafe.Pointer(&slc))
	}
	bf := NewPageBloomFilter(way, 12, uint32(b.N/4096)+1)
	for i := 0; i < b.N/2; i++ {
		binary.LittleEndian.PutUint64(tmp[:8], uint64(i))
		bf.Set(keys[0])
	}
	for i := 0; i < b.N; i++ {
		binary.LittleEndian.PutUint64(tmp[i*8:(i+1)*8], uint64(i))
	}
	b.StartTimer()
	for i := 0; i < b.N; i++ {
		bf.Test(keys[i])
	}
}

func BenchmarkSet4(b *testing.B)  { benchSet(b, 4) }
func BenchmarkTest4(b *testing.B) { benchTest(b, 4) }
func BenchmarkSet5(b *testing.B)  { benchSet(b, 5) }
func BenchmarkTest5(b *testing.B) { benchTest(b, 5) }
func BenchmarkSet6(b *testing.B)  { benchSet(b, 6) }
func BenchmarkTest6(b *testing.B) { benchTest(b, 6) }
func BenchmarkSet7(b *testing.B)  { benchSet(b, 7) }
func BenchmarkTest7(b *testing.B) { benchTest(b, 7) }
func BenchmarkSet8(b *testing.B)  { benchSet(b, 8) }
func BenchmarkTest8(b *testing.B) { benchTest(b, 8) }
