// Copyright (c) 2023, Ruan Kunliang.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

//go:build amd64 && !go1.21

package pbf

import (
	"reflect"
	"unsafe"
)

//go:noescape
func pbf4Set(space uintptr, pageLevel, pageNum uint, key string) bool

//go:noescape
func pbf4Test(space uintptr, pageLevel, pageNum uint, key string) bool

func (bf *pbfW4) Set(key string) bool {
	space := (*reflect.SliceHeader)(unsafe.Pointer(&bf.data)).Data
	if pbf4Set(space, uint(bf.pageLevel), uint(bf.pageNum), key) {
		bf.uniqueCnt++
		return true
	}
	return false
}

func (bf *pbfW4) Test(key string) bool {
	space := (*reflect.SliceHeader)(unsafe.Pointer(&bf.data)).Data
	return pbf4Test(space, uint(bf.pageLevel), uint(bf.pageNum), key)
}

//go:noescape
func pbf5Set(space uintptr, pageLevel, pageNum uint, key string) bool

//go:noescape
func pbf5Test(space uintptr, pageLevel, pageNum uint, key string) bool

func (bf *pbfW5) Set(key string) bool {
	space := (*reflect.SliceHeader)(unsafe.Pointer(&bf.data)).Data
	if pbf5Set(space, uint(bf.pageLevel), uint(bf.pageNum), key) {
		bf.uniqueCnt++
		return true
	}
	return false
}

func (bf *pbfW5) Test(key string) bool {
	space := (*reflect.SliceHeader)(unsafe.Pointer(&bf.data)).Data
	return pbf5Test(space, uint(bf.pageLevel), uint(bf.pageNum), key)
}

//go:noescape
func pbf6Set(space uintptr, pageLevel, pageNum uint, key string) bool

//go:noescape
func pbf6Test(space uintptr, pageLevel, pageNum uint, key string) bool

func (bf *pbfW6) Set(key string) bool {
	space := (*reflect.SliceHeader)(unsafe.Pointer(&bf.data)).Data
	if pbf6Set(space, uint(bf.pageLevel), uint(bf.pageNum), key) {
		bf.uniqueCnt++
		return true
	}
	return false
}

func (bf *pbfW6) Test(key string) bool {
	space := (*reflect.SliceHeader)(unsafe.Pointer(&bf.data)).Data
	return pbf6Test(space, uint(bf.pageLevel), uint(bf.pageNum), key)
}

//go:noescape
func pbf7Set(space uintptr, pageLevel, pageNum uint, key string) bool

//go:noescape
func pbf7Test(space uintptr, pageLevel, pageNum uint, key string) bool

func (bf *pbfW7) Set(key string) bool {
	space := (*reflect.SliceHeader)(unsafe.Pointer(&bf.data)).Data
	if pbf7Set(space, uint(bf.pageLevel), uint(bf.pageNum), key) {
		bf.uniqueCnt++
		return true
	}
	return false
}

func (bf *pbfW7) Test(key string) bool {
	space := (*reflect.SliceHeader)(unsafe.Pointer(&bf.data)).Data
	return pbf7Test(space, uint(bf.pageLevel), uint(bf.pageNum), key)
}

//go:noescape
func pbf8Set(space uintptr, pageLevel, pageNum uint, key string) bool

//go:noescape
func pbf8Test(space uintptr, pageLevel, pageNum uint, key string) bool

func (bf *pbfW8) Set(key string) bool {
	space := (*reflect.SliceHeader)(unsafe.Pointer(&bf.data)).Data
	if pbf8Set(space, uint(bf.pageLevel), uint(bf.pageNum), key) {
		bf.uniqueCnt++
		return true
	}
	return false
}

func (bf *pbfW8) Test(key string) bool {
	space := (*reflect.SliceHeader)(unsafe.Pointer(&bf.data)).Data
	return pbf8Test(space, uint(bf.pageLevel), uint(bf.pageNum), key)
}
