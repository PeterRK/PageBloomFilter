// Copyright (c) 2023, Ruan Kunliang.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

package pbf

import (
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
	Set(key string) bool
	Test(key string) bool
}

func NewPageBloomFilter(way, pageLevel, pageNum uint32) PageBloomFilter {
	if way < 4 || way > 8 || pageNum == 0 ||
		pageLevel < (8-8/way) || pageLevel > 13 {
		return nil
	}
	bf := &pageBloomFilter{
		pageLevel: pageLevel,
		pageNum:   pageNum,
		uniqueCnt: 0,
		data:      make([]byte, int(pageNum)<<pageLevel),
	}

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

func CreatePageBloomFilter(way, pageLevel uint32, data []byte) PageBloomFilter {
	pageSize := int(1) << pageLevel
	if pageSize == 0 || len(data)%pageSize != 0 {
		return nil
	}
	bf := NewPageBloomFilter(way, pageLevel, uint32(len(data)/pageSize))
	if bf != nil {
		copy(bf.Data(), data)
	}
	return bf
}

type pageBloomFilter struct {
	pageLevel uint32
	pageNum   uint32
	uniqueCnt int
	data      []byte
}

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

func (bf *pageBloomFilter) Data() []byte {
	return bf.data
}

func (bf *pageBloomFilter) Unique() int {
	return bf.uniqueCnt
}

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
