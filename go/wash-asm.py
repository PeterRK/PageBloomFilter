#!/usr/bin/python3

import re
import sys


_PTN_FUNC_BEGIN = re.compile('.*# -- Begin function')
_PTN_FUNC_END = re.compile('.*# -- End function')
_PTN_TEXT = re.compile('\s*\.text')
_PTN_SECTION = re.compile('\s*\.section\s+')
_PTN_GLOBAL_SYMBOL = re.compile('\s*\.globl\s+(\w+)')
_PTN_FUNC_SIZE = re.compile('\s*\.size\s+(\w+),\s*([\w\.]+-\w+)')


def main(src, dest):
	parts = []
	func = None
	with open(src, 'r') as f:
		for line in f:
			line = line.strip('\n')
			if _PTN_FUNC_BEGIN.match(line) is not None:
				assert func is None
				func = [line]
				continue
			if func is None:
				continue
			func.append(line)
			if _PTN_FUNC_END.match(line) is not None:
				parts.append(func)
				func = None

	for i in range(len(parts)):
		text = True
		code = None
		other = []
		for line in parts[i]:
			if _PTN_TEXT.match(line) is not None:
				text = True
				continue
			if _PTN_SECTION.match(line) is not None:
				text = False
				continue

			if code is None:
				m = _PTN_GLOBAL_SYMBOL.match(line)
				if m is not None:
					name = m.groups()[0]
					code = []
					continue
				other.append(line)
				continue

			if not text:
				other.append(line)
				continue

			m = _PTN_FUNC_SIZE.match(line)
			if m is not None:
				target, size = m.groups()
				continue
			code.append(line)

		assert target == name
		parts[i] = (code, other, size)

	with open(dest, 'w') as f:
		print('	.section	.rodata.func_size,"aM",@progbits,4', file=f)
		print('	.p2align	2', file=f)
		for i in range(len(parts)):
			_1, _2, size = parts[i]
			print('	.long	' + size, file=f)
			off = size.find('-')
			print('	.long	.L__END__{}{}'.format(i, size[off:]), file=f)
		print('#===================================', file=f)
		print('	.text', file=f)
		print('	.p2align	5, 0xcc', file=f)
		for i in range(len(parts)):
			code, other, _ = parts[i]
			for line in code:
				print(line, file=f)
			for line in other:
				print(line, file=f)
			print('.L__END__{}:'.format(i), file=f)
			print('#===================================', file=f)
			print('	.p2align	5, 0xcc', file=f)


if __name__ == '__main__':
	if len(sys.argv) != 3:
		print('usage: {} input output'.format(sys.argv[0]))
		quit(1)
	main(sys.argv[1], sys.argv[2])