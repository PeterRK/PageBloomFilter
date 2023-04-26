#!/usr/bin/python3

import os
from distutils.core import setup, Extension

base_dir = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

pbf = Extension('_pbf',
                include_dirs=[base_dir+'/include'],
                sources=['bind.c', base_dir+'/src/pbf-c.cc', base_dir+'/src/hash.cc'])

setup(name='pbf', version='0.1', description='Page Bloom Filter', 
	py_modules=['pbf'], ext_modules=[pbf])
