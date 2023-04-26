#define PY_SSIZE_T_CLEAN
#include <string.h>
#include <Python.h>
#include "pbf-c.h"

#define DEFINE_PY_FUNC(way) \
static PyObject* set##way(PyObject *self, PyObject *args) { \
	FETCH_ARGS \
	return PyBool_FromLong(PBF8_Set(space.buf, page_level, page_num, key, key_len)); \
} \
static PyObject* test##way(PyObject *self, PyObject *args) { \
	FETCH_ARGS \
	return PyBool_FromLong(PBF8_Test(space.buf, page_level, page_num, key, key_len)); \
}

#define FETCH_ARGS \
	Py_buffer space; \
	unsigned page_level, page_num; \
	const uint8_t* key; \
	Py_ssize_t key_len; \
	if (!PyArg_ParseTuple(args, "y*IIs#", \
		&space, &page_level, &page_num, &key, &key_len)) return NULL;

DEFINE_PY_FUNC(4)
DEFINE_PY_FUNC(5)
DEFINE_PY_FUNC(6)
DEFINE_PY_FUNC(7)
DEFINE_PY_FUNC(8)


static PyObject* clear(PyObject *self, PyObject *args) {
	Py_buffer space;
	if (!PyArg_ParseTuple(args, "y*", &space)) return NULL;
	memset(space.buf, 0, space.itemsize * space.len);
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
