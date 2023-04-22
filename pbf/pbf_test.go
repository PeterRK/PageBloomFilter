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

func Test_W4(t *testing.T) { doTest(t, 4) }
func Test_W5(t *testing.T) { doTest(t, 5) }
func Test_W6(t *testing.T) { doTest(t, 6) }
func Test_W7(t *testing.T) { doTest(t, 7) }
func Test_W8(t *testing.T) { doTest(t, 8) }

func benchSet(b *testing.B, way uint32) {
	b.StopTimer()
	n := uint64(b.N)
	tmp := make([]byte, n*8)
	keys := make([]string, n)
	for i := uint64(0); i < n; i++ {
		slc := tmp[i*8 : (i+1)*8]
		keys[i] = *(*string)(unsafe.Pointer(&slc))
		binary.LittleEndian.PutUint64(slc, i)
	}
	bf := NewPageBloomFilter(way, 12, uint32(n/2048)+1)
	b.StartTimer()
	for i := 0; i < b.N; i++ {
		bf.Set(keys[i])
	}
}

func benchTest(b *testing.B, way uint32) {
	b.StopTimer()
	n := uint64(b.N)
	tmp := make([]byte, n*8)
	keys := make([]string, n)
	for i := uint64(0); i < n; i++ {
		slc := tmp[i*8 : (i+1)*8]
		keys[i] = *(*string)(unsafe.Pointer(&slc))
		binary.LittleEndian.PutUint64(slc, i)
	}
	bf := NewPageBloomFilter(way, 12, uint32(n/4096)+1)
	for i := uint64(0); i < n/2; i++ {
		binary.LittleEndian.PutUint64(tmp[:8], i)
		bf.Set(keys[0])
	}
	for i := uint64(0); i < n; i++ {
		binary.LittleEndian.PutUint64(tmp[i*8:(i+1)*8], i)
	}
	b.StartTimer()
	for i := 0; i < b.N; i++ {
		bf.Test(keys[i])
	}
}

func Benchmark_Set4(b *testing.B)  { benchSet(b, 4) }
func Benchmark_Test4(b *testing.B) { benchTest(b, 4) }
func Benchmark_Set5(b *testing.B)  { benchSet(b, 5) }
func Benchmark_Test5(b *testing.B) { benchTest(b, 5) }
func Benchmark_Set6(b *testing.B)  { benchSet(b, 6) }
func Benchmark_Test6(b *testing.B) { benchTest(b, 6) }
func Benchmark_Set7(b *testing.B)  { benchSet(b, 7) }
func Benchmark_Test7(b *testing.B) { benchTest(b, 7) }
func Benchmark_Set8(b *testing.B)  { benchSet(b, 8) }
func Benchmark_Test8(b *testing.B) { benchTest(b, 8) }