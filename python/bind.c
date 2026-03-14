// Copyright (c) 2023, Ruan Kunliang.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

#define PY_SSIZE_T_CLEAN
#include <string.h>
#include <Python.h>
#include "pbf-c.h"

static int validate_page_buffer(Py_buffer* space, unsigned page_level) {
	if (page_level > 31) {
		PyErr_SetString(PyExc_ValueError, "page_level is too large");
		return 0;
	}
	Py_ssize_t page_size = (Py_ssize_t)1 << page_level;
	if (space->len < page_size) {
		PyErr_SetString(PyExc_ValueError, "buffer is smaller than one page");
		return 0;
	}
	if (space->len % page_size != 0) {
		PyErr_SetString(PyExc_ValueError, "buffer length must be a multiple of page size");
		return 0;
	}
	return 1;
}

#define PARSE_RW_BUFFER_AND_KEY()                                             \
	Py_buffer space = {0};                                                    \
	const uint8_t* key = NULL;                                                \
	Py_ssize_t key_len = 0;                                                   \
	unsigned page_level = 0;                                                  \
	if (!PyArg_ParseTuple(args, "w*Is#",                                       \
		&space, &page_level, &key, &key_len)) {                               \
		return NULL;                                                           \
	}

#define DEFINE_PY_FUNC(way) \
static PyObject* set##way(PyObject *self, PyObject *args) { \
	PARSE_RW_BUFFER_AND_KEY() \
	if (!validate_page_buffer(&space, page_level)) { \
		PyBuffer_Release(&space); \
		return NULL; \
	} \
	int ret = PBF##way##_Set(space.buf, page_level, space.len>>page_level, key, key_len); \
	PyBuffer_Release(&space); \
	return PyBool_FromLong(ret); \
} \
static PyObject* test##way(PyObject *self, PyObject *args) { \
	PARSE_RW_BUFFER_AND_KEY() \
	if (!validate_page_buffer(&space, page_level)) { \
		PyBuffer_Release(&space); \
		return NULL; \
	} \
	int ret = PBF##way##_Test(space.buf, page_level, space.len>>page_level, key, key_len); \
	PyBuffer_Release(&space); \
	return PyBool_FromLong(ret); \
}

DEFINE_PY_FUNC(4)
DEFINE_PY_FUNC(5)
DEFINE_PY_FUNC(6)
DEFINE_PY_FUNC(7)
DEFINE_PY_FUNC(8)


static PyObject* clear(PyObject *self, PyObject *args) {
	Py_buffer space = {0};
	if (!PyArg_ParseTuple(args, "w*", &space)) return NULL;
	memset(space.buf, 0, space.itemsize * space.len);
	PyBuffer_Release(&space);
	Py_RETURN_NONE;
}

static PyMethodDef funcs[] = {
	{"clear", clear, METH_VARARGS, "clear buffer"},
	{"set4",   set4, METH_VARARGS, "4-way pbf set"},
	{"test4", test4, METH_VARARGS, "4-way pbf test"},
	{"set5",   set5, METH_VARARGS, "5-way pbf set"},
	{"test5", test5, METH_VARARGS, "5-way pbf test"},
	{"set6",   set6, METH_VARARGS, "6-way pbf set"},
	{"test6", test6, METH_VARARGS, "6-way pbf test"},
	{"set7",   set7, METH_VARARGS, "7-way pbf set"},
	{"test7", test7, METH_VARARGS, "7-way pbf test"},
	{"set8",   set8, METH_VARARGS, "8-way pbf set"},
	{"test8", test8, METH_VARARGS, "8-way pbf test"},
	{NULL, NULL, 0, NULL} // Sentinel
};

static struct PyModuleDef module = {
	PyModuleDef_HEAD_INIT,
	"_pbf",	// name of module
	NULL,	// module documentation, may be NULL
	-1,		/* size of per-interpreter state of the module,
			or -1 if the module keeps state in global variables. */
	funcs
};

PyMODINIT_FUNC PyInit__pbf(void) { return PyModule_Create(&module); }
