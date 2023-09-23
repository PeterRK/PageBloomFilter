// Copyright (c) 2023, Ruan Kunliang.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

package pbf

import (
	"math"
	"reflect"
	"unsafe"
)

type PageBloomFilter interface {
	Clear()
	Data() []byte
	Unique() int
	PageLevel() uint32
	Way() uint32
	Cap() int
	Set(key string) bool  // return true if key not exists
	Test(key string) bool // return true if key exists
}

// item: number of items to hold
// fpr: expected false positive rate, 0.0005-0.1
// New clean PageBloomFilter with auto-selected parameters
func NewBloomFilter(item int, fpr float64) PageBloomFilter {
	if item < 1 {
		item = 1
	}
	if fpr > 0.1 {
		fpr = 0.1
	} else if fpr < 0.0005 {
		fpr = 0.0005
	}
	w := -math.Log2(fpr)
	bpi := w / (math.Ln2 * 8)
	way := uint32(math.Round(w))
	if way < 4 {
		way = 4
	} else if way > 8 {
		way = 8
		bpi *= 1.025
	} else {
		bpi *= 1.01
	}

	n := uint64(bpi * float64(item))
	pageLevel := uint32(0)
	for i := uint32(6); i < 12; i++ {
		if n < (1 << (i + 2)) {
			pageLevel = i
			if pageLevel < (8 - 8/way) {
				pageLevel++
			}
			break
		}
	}
	if pageLevel == 0 {
		pageLevel = 12
	}

	m := (n + (1 << pageLevel) - 1) >> pageLevel
	if m > math.MaxInt32 {
		return nil
	}
	pageNum := uint32(m)
	return NewPageBloomFilter(way, pageLevel, pageNum)
}

// way: 4-8
// pageLevel: log2(page size), 7-13
// pageNum: number of pages
// New clean PageBloomFilter
func NewPageBloomFilter(way, pageLevel, pageNum uint32) PageBloomFilter {
	if way < 4 || way > 8 || pageNum == 0 ||
		pageLevel < (8-8/way) || pageLevel > 13 {
		return nil
	}
	return cast(way, &pageBloomFilter{
		pageLevel: pageLevel,
		pageNum:   pageNum,
		uniqueCnt: 0,
		data:      make([]byte, int(pageNum)<<pageLevel),
	})
}

func cast(way uint32, bf *pageBloomFilter) PageBloomFilter {
	switch way {
	case 4:
		return (*pbfW4)(unsafe.Pointer(bf))
	case 5:
		return (*pbfW5)(unsafe.Pointer(bf))
	case 6:
		return (*pbfW6)(unsafe.Pointer(bf))
	case 7:
		return (*pbfW7)(unsafe.Pointer(bf))
	case 8:
		return (*pbfW8)(unsafe.Pointer(bf))
	}
	return nil
}

// Create PageBloomFilter with data
func CreatePageBloomFilter(way, pageLevel uint32, data []byte,
	uniqueCnt int) PageBloomFilter {
	pageSize := int(1) << pageLevel
	if way < 4 || way > 8 ||
		pageLevel < (8-8/way) || pageLevel > 13 ||
		len(data) == 0 || len(data)%pageSize != 0 {
		return nil
	}
	temp := make([]byte, len(data))
	copy(temp, data)
	return cast(way, &pageBloomFilter{
		pageLevel: pageLevel,
		pageNum:   uint32(len(data) / pageSize),
		uniqueCnt: uniqueCnt,
		data:      temp,
	})
}

type pageBloomFilter struct {
	pageLevel uint32
	pageNum   uint32
	uniqueCnt int
	data      []byte
}

// clear data
func (bf *pageBloomFilter) Clear() {
	bf.uniqueCnt = 0
	slc := (*reflect.SliceHeader)(unsafe.Pointer(&bf.data))
	var vec []uint64
	ref := (*reflect.SliceHeader)(unsafe.Pointer(&vec))
	ref.Data = slc.Data
	ref.Len = slc.Len / 8
	ref.Cap = ref.Len
	for i := 0; i < len(vec); i++ {
		vec[i] = 0
	}
}

// get inner data
func (bf *pageBloomFilter) Data() []byte {
	return bf.data
}

// approximate number of unique items
func (bf *pageBloomFilter) Unique() int {
	return bf.uniqueCnt
}

// log2(page size)
func (bf *pageBloomFilter) PageLevel() uint32 {
	return bf.pageLevel
}

type pbfW4 struct {
	pageBloomFilter
}

func (bf *pbfW4) Way() uint32 {
	return 4
}

func (bf *pbfW4) Cap() int {
	return len(bf.data) * 8 / int(bf.Way())
}

type pbfW5 struct {
	pageBloomFilter
}

func (bf *pbfW5) Way() uint32 {
	return 5
}

func (bf *pbfW5) Cap() int {
	return len(bf.data) * 8 / int(bf.Way())
}

type pbfW6 struct {
	pageBloomFilter
}

func (bf *pbfW6) Way() uint32 {
	return 6
}

func (bf *pbfW6) Cap() int {
	return len(bf.data) * 8 / int(bf.Way())
}

type pbfW7 struct {
	pageBloomFilter
}

func (bf *pbfW7) Way() uint32 {
	return 7
}

func (bf *pbfW7) Cap() int {
	return len(bf.data) * 8 / int(bf.Way())
}

type pbfW8 struct {
	pageBloomFilter
}

func (bf *pbfW8) Way() uint32 {
	return 8
}

func (bf *pbfW8) Cap() int {
	return len(bf.data) * 8 / int(bf.Way())
}
