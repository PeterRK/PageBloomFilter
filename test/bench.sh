#!/bin/bash

COMPILE="clang++ -O3 -std=c++14 -march=native"

echo "robin-hood-set"
${COMPILE} set-wrapper.cc set-bench.cc
	for ((i=0;i<10;i++)); do
		./a.out
	done
echo ""

SOURCE="../hash.cc ../pbf.cc bench.cc"

for w in 4 5 6 7 8; do
	echo "way-${w}"
	${COMPILE} -DBENCHMARK_WAY=${w} -DDISABLE_SIMD_OPTIMIZE ${SOURCE}
	for ((i=0;i<10;i++)); do
		./a.out
	done
	echo ""
done

for w in 4 5 6 7 8; do
	echo "way-${w}-xx"
	${COMPILE} -DBENCHMARK_WAY=${w} -DDISABLE_SIMD_OPTIMIZE -DUSE_XXHASH ${SOURCE}
	for ((i=0;i<10;i++)); do
		./a.out
	done
	echo ""
done

for w in 5 6 7 8; do
	${COMPILE} -DBENCHMARK_WAY=${w} ${SOURCE}
	echo "way-simd-${w}"
	for ((i=0;i<10;i++)); do
		./a.out
	done
	echo ""
done

for w in 5 6 7 8; do
	${COMPILE} -DBENCHMARK_WAY=${w} -DUSE_XXHASH ${SOURCE}
	echo "way-simd-${w}-xx"
	for ((i=0;i<10;i++)); do
		./a.out
	done
	echo ""
done

rm a.out