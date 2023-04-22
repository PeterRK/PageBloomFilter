// Copyright (c) 2023, Ruan Kunliang.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

package pbf

import (
	"encoding/binary"
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
	assert(t, bf.PageLevel() == 8)
	assert(t, len(bf.Data()) == 768)
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
