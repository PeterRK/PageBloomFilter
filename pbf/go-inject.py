#!/usr/bin/python3

import re
import sys
import struct
import binascii


_PTN_DATA_LINE = re.compile('^\s*[0-9a-z]+\s(.+)')
_PTN_FUNC = re.compile('^([0-9a-z]+)\s<(\w+)>')
_PTN_CODE = re.compile('^\s*([0-9a-z]+):\t([0-9a-z ]+)\t(.+)')
_PTN_CODE_EXT = re.compile('^\s*([0-9a-z]+):\t([0-9a-z ]+)$')
_PTN_CALL = re.compile('^call\s+([0-9a-z]+)\s<([^\s<>]+)>')


def load_data(filename):
	data = bytearray()
	with open(filename, 'r') as f:
		for line in f:
			line = line.strip('\n')
			m = _PTN_DATA_LINE.match(line)
			if m is None:
				continue
			tail = m.groups()[0][:-18]
			data += binascii.a2b_hex(tail.replace(' ', ''))
	return data


def bytes_to_go(bs):
	code = []
	while len(bs) >= 8:
		x = bytearray(8)
		x[0] = bs[7]
		x[1] = bs[6]
		x[2] = bs[5]
		x[3] = bs[4]
		x[4] = bs[3]
		x[5] = bs[2]
		x[6] = bs[1]
		x[7] = bs[0]
		bs = bs[8:]
		code.append('QUAD $0x'+binascii.b2a_hex(x).decode('ascii'))
	if len(bs) >= 4:
		x = bytearray(4)
		x[0] = bs[3]
		x[1] = bs[2]
		x[2] = bs[1]
		x[3] = bs[0]
		bs = bs[4:]
		code.append('LONG $0x'+binascii.b2a_hex(x).decode('ascii'))
	if len(bs) >= 2:
		x = bytearray(2)
		x[0] = bs[1]
		x[1] = bs[0]
		bs = bs[2:]
		code.append('WORD $0x'+binascii.b2a_hex(x).decode('ascii'))
	if len(bs) >= 1:
		code.append('BYTE $0x'+binascii.b2a_hex(bs).decode('ascii'))
	return '; '.join(code)


def main(size_file, data_file, code_file, out_file):
	data = load_data(size_file)
	assert len(data) % 8 == 0
	func_size = []
	for off in range(0, len(data), 8):
		func_size.append(struct.unpack('<II', data[off:off+8]))

	func_data = load_data(data_file)

	with open(code_file, 'r') as f:
		text = f.readlines()

	func_names = {}
	func_body = None
	func_list = []
	for line in text:
		line = line.strip('\n')
		m = _PTN_FUNC.match(line)
		if m is not None:
			if func_body is not None:
				func_list.append((name, func_body))
			func_body = []
			addr, name = m.groups()
			addr = int(addr, 16)
			cend, dend = func_size[0]
			cend += addr
			dend += addr
			func_size = func_size[1:]
			func_names[name] = addr
			continue
		if func_body is None:
			continue
		m = _PTN_CODE.match(line)
		if m is None:
			m = _PTN_CODE_EXT.match(line)
			if m is None:
				continue
			off, bs = m.groups()
			off = int(off, 16)
			bs = binascii.a2b_hex(bs.replace(' ', ''))
			assert bs == func_data[off:off+len(bs)]
			code, raw = func_body[-1]
			raw += bs
			func_body[-1] = (code, raw)
			continue
		off, bs, code = m.groups()
		off = int(off, 16)
		if off >= cend:
			if dend > cend:
				func_body.append(('data '+str(dend-cend), func_data[cend:dend]))
			func_list.append((name, func_body))
			func_body = None
			continue
		bs = binascii.a2b_hex(bs.replace(' ', ''))
		assert bs == func_data[off:off+len(bs)]
		func_body.append((code, bs))

	assert len(func_size) == 0
	if func_body is not None:
		func_list.append((name, func_body))
		func_body = None

	with open(out_file, 'w') as f:
		print('#include "textflag.h"', file=f)
		print('', file=f)
		for name, body in func_list:
			print('TEXT {}(SB), NOSPLIT, $0'.format(name), file=f)
			for code, bs in body:
				print('	// ' + code, file=f)
				m = _PTN_CALL.match(code)
				if m is not None:
					addr, target = m.groups()
					addr = int(addr, 16)
					assert func_names[target] == addr
					assert len(bs) == 5
					print('	CALL {}(SB)'.format(target), file=f)
					continue
				print('	'+bytes_to_go(bs), file=f)
			print('', file=f)


if __name__ == '__main__':
	if len(sys.argv) != 5:
		print('usage: {} size-file data-file code-file output'.format(sys.argv[0]))
		quit(1)
	main(sys.argv[1], sys.argv[2], sys.argv[3], sys.argv[4])