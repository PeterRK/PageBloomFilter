#!/bin/bash

clang -O3 -std=c++14 -march=native \
	-fno-asynchronous-unwind-tables -fno-exceptions  \
	-DC_ALL_IN_ONE -S -fPIE -I../include ../src/pbf-c.cc -o origin.asm && \
./wash-asm.py origin.asm washed.asm && \
as washed.asm -o inject.o && \
objdump -s --section=.rodata.func_size inject.o >func-size.txt && \
objdump -s --section=.text inject.o >func-data.txt && \
objdump -d --section=.text inject.o >func-code.txt && \
./go-inject.py func-size.txt func-data.txt func-code.txt inject_amd64.s && \
rm origin.asm washed.asm inject.o func-size.txt func-data.txt func-code.txt
