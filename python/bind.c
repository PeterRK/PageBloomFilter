#define PY_SSIZE_T_CLEAN
#include <math.h>
#include <string.h>
#include <Python.h>
#include "pbf-c.h"

typedef struct {
    PyObject_HEAD
    unsigned way;
    unsigned page_level;
    unsigned page_num;
    size_t unique_cnt;
    Py_ssize_t data_size;
    PyObject* data;
} PyPageBloomFilter;

typedef struct {
    const void* data;
    Py_ssize_t len;
    Py_buffer view;
    PyObject* encoded;
} KeyArg;

static PyTypeObject PyPageBloomFilterType;

static int validate_layout(unsigned way, unsigned page_level, unsigned page_num, Py_ssize_t data_size) {
    unsigned min_page_level;

    if (way < 4 || way > 8) {
        PyErr_SetString(PyExc_ValueError, "way must be in [4, 8]");
        return 0;
    }
    min_page_level = 8U - 8U / way;
    if (page_level < min_page_level || page_level > 13) {
        PyErr_SetString(PyExc_ValueError, "page_level is out of range for this way");
        return 0;
    }
    if (page_num == 0) {
        PyErr_SetString(PyExc_ValueError, "page_num must be positive");
        return 0;
    }
    if (page_level >= 63) {
        PyErr_SetString(PyExc_ValueError, "page_level is too large");
        return 0;
    }
    if (data_size != ((Py_ssize_t)page_num << page_level)) {
        PyErr_SetString(PyExc_ValueError, "data length does not match page_level/page_num");
        return 0;
    }
    return 1;
}

static int validate_page_buffer(Py_buffer* space, unsigned page_level) {
    Py_ssize_t page_size;

    if (page_level > 31) {
        PyErr_SetString(PyExc_ValueError, "page_level is too large");
        return 0;
    }
    page_size = (Py_ssize_t)1 << page_level;
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

static int key_arg_init(PyObject* obj, KeyArg* key) {
    memset(key, 0, sizeof(*key));
    if (PyUnicode_Check(obj)) {
        key->encoded = PyUnicode_AsUTF8String(obj);
        if (key->encoded == NULL) {
            return 0;
        }
        key->data = PyBytes_AS_STRING(key->encoded);
        key->len = PyBytes_GET_SIZE(key->encoded);
        return 1;
    }
    if (PyObject_GetBuffer(obj, &key->view, PyBUF_CONTIG_RO) == 0) {
        key->data = key->view.buf;
        key->len = key->view.len;
        return 1;
    }
    PyErr_SetString(PyExc_TypeError, "key must be str or a contiguous bytes-like object");
    return 0;
}

static void key_arg_release(KeyArg* key) {
    if (key->view.obj != NULL) {
        PyBuffer_Release(&key->view);
    }
    Py_XDECREF(key->encoded);
}

static int raw_set(unsigned way, void* space, unsigned page_level, unsigned page_num,
                   const void* key, unsigned len) {
    switch (way) {
        case 4: return PBF4_Set(space, page_level, page_num, key, len);
        case 5: return PBF5_Set(space, page_level, page_num, key, len);
        case 6: return PBF6_Set(space, page_level, page_num, key, len);
        case 7: return PBF7_Set(space, page_level, page_num, key, len);
        case 8: return PBF8_Set(space, page_level, page_num, key, len);
        default:
            PyErr_SetString(PyExc_ValueError, "way must be in [4, 8]");
            return -1;
    }
}

static int raw_test(unsigned way, const void* space, unsigned page_level, unsigned page_num,
                    const void* key, unsigned len) {
    switch (way) {
        case 4: return PBF4_Test(space, page_level, page_num, key, len);
        case 5: return PBF5_Test(space, page_level, page_num, key, len);
        case 6: return PBF6_Test(space, page_level, page_num, key, len);
        case 7: return PBF7_Test(space, page_level, page_num, key, len);
        case 8: return PBF8_Test(space, page_level, page_num, key, len);
        default:
            PyErr_SetString(PyExc_ValueError, "way must be in [4, 8]");
            return -1;
    }
}

static PyObject* new_filter_object(unsigned way, unsigned page_level, unsigned page_num,
                                   size_t unique_cnt, const char* init_data) {
    PyPageBloomFilter* self;
    Py_ssize_t data_size = (Py_ssize_t)page_num << page_level;

    if (!validate_layout(way, page_level, page_num, data_size)) {
        return NULL;
    }

    self = (PyPageBloomFilter*)PyPageBloomFilterType.tp_alloc(&PyPageBloomFilterType, 0);
    if (self == NULL) {
        return NULL;
    }

    self->way = way;
    self->page_level = page_level;
    self->page_num = page_num;
    self->unique_cnt = unique_cnt;
    self->data_size = data_size;
    Py_CLEAR(self->data);
    if (init_data == NULL) {
        self->data = PyByteArray_FromStringAndSize(NULL, data_size);
        if (self->data == NULL) {
            Py_DECREF(self);
            return NULL;
        }
        memset(PyByteArray_AS_STRING(self->data), 0, (size_t)data_size);
    } else {
        self->data = PyByteArray_FromStringAndSize(init_data, data_size);
        if (self->data == NULL) {
            Py_DECREF(self);
            return NULL;
        }
    }

    return (PyObject*)self;
}

static PyObject* module_restore(PyObject* self, PyObject* args, PyObject* kwargs) {
    static char* kwlist[] = {"way", "page_level", "data", "unique_cnt", NULL};
    unsigned way;
    unsigned page_level;
    size_t unique_cnt = 0;
    PyObject* data_obj;
    Py_buffer data = {0};
    unsigned page_num;
    PyObject* result = NULL;

    if (!PyArg_ParseTupleAndKeywords(args, kwargs, "IIO|K", kwlist,
                                     &way, &page_level, &data_obj, &unique_cnt)) {
        return NULL;
    }
    if (PyObject_GetBuffer(data_obj, &data, PyBUF_CONTIG_RO) != 0) {
        PyErr_SetString(PyExc_TypeError, "data must be a contiguous bytes-like object");
        return NULL;
    }
    if (!validate_page_buffer(&data, page_level)) {
        PyBuffer_Release(&data);
        return NULL;
    }

    page_num = (unsigned)(data.len >> page_level);
    result = new_filter_object(way, page_level, page_num, unique_cnt, (const char*)data.buf);
    PyBuffer_Release(&data);
    return result;
}

static PyObject* PyPageBloomFilter_new(PyTypeObject* type, PyObject* args, PyObject* kwargs) {
    PyPageBloomFilter* self = (PyPageBloomFilter*)type->tp_alloc(type, 0);
    if (self != NULL) {
        self->way = 0;
        self->page_level = 0;
        self->page_num = 0;
        self->unique_cnt = 0;
        self->data_size = 0;
        self->data = NULL;
    }
    return (PyObject*)self;
}

static int PyPageBloomFilter_init(PyPageBloomFilter* self, PyObject* args, PyObject* kwargs) {
    static char* kwlist[] = {"way", "page_level", "page_num", "unique_cnt", "data", NULL};
    unsigned way;
    unsigned page_level;
    unsigned page_num;
    size_t unique_cnt = 0;
    PyObject* data_obj = Py_None;
    Py_buffer data = {0};
    PyObject* bytearray = NULL;
    Py_ssize_t data_size;

    if (!PyArg_ParseTupleAndKeywords(args, kwargs, "III|KO", kwlist,
                                     &way, &page_level, &page_num, &unique_cnt, &data_obj)) {
        return -1;
    }

    data_size = (Py_ssize_t)page_num << page_level;
    if (!validate_layout(way, page_level, page_num, data_size)) {
        return -1;
    }

    if (data_obj == Py_None) {
        bytearray = PyByteArray_FromStringAndSize(NULL, data_size);
        if (bytearray == NULL) {
            return -1;
        }
        memset(PyByteArray_AS_STRING(bytearray), 0, (size_t)data_size);
        unique_cnt = 0;
    } else {
        if (PyObject_GetBuffer(data_obj, &data, PyBUF_CONTIG_RO) != 0) {
            PyErr_SetString(PyExc_TypeError, "data must be a contiguous bytes-like object");
            return -1;
        }
        if (data.len != data_size) {
            PyErr_SetString(PyExc_ValueError, "data length does not match page_level/page_num");
            PyBuffer_Release(&data);
            return -1;
        }
        bytearray = PyByteArray_FromStringAndSize((const char*)data.buf, data_size);
        PyBuffer_Release(&data);
        if (bytearray == NULL) {
            return -1;
        }
    }

    Py_XDECREF(self->data);
    self->way = way;
    self->page_level = page_level;
    self->page_num = page_num;
    self->unique_cnt = unique_cnt;
    self->data_size = data_size;
    self->data = bytearray;
    return 0;
}

static void PyPageBloomFilter_dealloc(PyPageBloomFilter* self) {
    Py_XDECREF(self->data);
    Py_TYPE(self)->tp_free((PyObject*)self);
}

static PyObject* PyPageBloomFilter_clear(PyPageBloomFilter* self, PyObject* Py_UNUSED(ignored)) {
    self->unique_cnt = 0;
    memset(PyByteArray_AS_STRING(self->data), 0, (size_t)self->data_size);
    Py_RETURN_NONE;
}

static PyObject* PyPageBloomFilter_set(PyPageBloomFilter* self, PyObject* key_obj) {
    KeyArg key;
    int ret;

    if (!key_arg_init(key_obj, &key)) {
        return NULL;
    }
    ret = raw_set(self->way, PyByteArray_AS_STRING(self->data), self->page_level, self->page_num,
                  key.data, (unsigned)key.len);
    key_arg_release(&key);
    if (ret < 0) {
        return NULL;
    }
    if (ret) {
        self->unique_cnt++;
    }
    return PyBool_FromLong(ret);
}

static PyObject* PyPageBloomFilter_test(PyPageBloomFilter* self, PyObject* key_obj) {
    KeyArg key;
    int ret;

    if (!key_arg_init(key_obj, &key)) {
        return NULL;
    }
    ret = raw_test(self->way, PyByteArray_AS_STRING(self->data), self->page_level, self->page_num,
                   key.data, (unsigned)key.len);
    key_arg_release(&key);
    if (ret < 0) {
        return NULL;
    }
    return PyBool_FromLong(ret);
}

static PyObject* PyPageBloomFilter_capacity(PyPageBloomFilter* self, PyObject* Py_UNUSED(ignored)) {
    return PyLong_FromSsize_t((self->data_size * 8) / (Py_ssize_t)self->way);
}

static PyObject* PyPageBloomFilter_virtual_capacity(PyPageBloomFilter* self, PyObject* args) {
    double fpr;
    double t;

    if (!PyArg_ParseTuple(args, "d", &fpr)) {
        return NULL;
    }
    if (!(fpr > 0.0 && fpr < 1.0)) {
        PyErr_SetString(PyExc_ValueError, "fpr must be between 0 and 1");
        return NULL;
    }

    t = log1p(-pow(fpr, 1.0 / (double)self->way)) / log1p(-1.0 / (double)(self->data_size * 8));
    return PyLong_FromSize_t((size_t)t / self->way);
}

static PyObject* PyPageBloomFilter_export_state(PyPageBloomFilter* self, PyObject* Py_UNUSED(ignored)) {
    PyObject* data = PyBytes_FromStringAndSize(PyByteArray_AS_STRING(self->data), self->data_size);
    PyObject* result;

    if (data == NULL) {
        return NULL;
    }
    result = Py_BuildValue("(IIOn)", self->way, self->page_level, data, (Py_ssize_t)self->unique_cnt);
    Py_DECREF(data);
    return result;
}

static PyObject* PyPageBloomFilter_repr(PyPageBloomFilter* self) {
    return PyUnicode_FromFormat(
        "PageBloomFilter(way=%u, page_level=%u, page_num=%u, unique_cnt=%zu)",
        self->way, self->page_level, self->page_num, self->unique_cnt
    );
}

static int PyPageBloomFilter_contains(PyObject* obj, PyObject* key_obj) {
    PyObject* ret = PyPageBloomFilter_test((PyPageBloomFilter*)obj, key_obj);
    int truth;

    if (ret == NULL) {
        return -1;
    }
    truth = PyObject_IsTrue(ret);
    Py_DECREF(ret);
    return truth;
}

static PyObject* PyPageBloomFilter_get_way(PyPageBloomFilter* self, void* closure) {
    return PyLong_FromUnsignedLong(self->way);
}

static PyObject* PyPageBloomFilter_get_page_level(PyPageBloomFilter* self, void* closure) {
    return PyLong_FromUnsignedLong(self->page_level);
}

static PyObject* PyPageBloomFilter_get_page_num(PyPageBloomFilter* self, void* closure) {
    return PyLong_FromUnsignedLong(self->page_num);
}

static PyObject* PyPageBloomFilter_get_unique_cnt(PyPageBloomFilter* self, void* closure) {
    return PyLong_FromSize_t(self->unique_cnt);
}

static PyObject* PyPageBloomFilter_get_data(PyPageBloomFilter* self, void* closure) {
    Py_buffer view;

    if (PyBuffer_FillInfo(&view, (PyObject*)self, PyByteArray_AS_STRING(self->data),
                          self->data_size, 1, PyBUF_CONTIG_RO) != 0) {
        return NULL;
    }
    return PyMemoryView_FromBuffer(&view);
}

static PyMethodDef PyPageBloomFilter_methods[] = {
    {"clear", (PyCFunction)PyPageBloomFilter_clear, METH_NOARGS, "clear buffer"},
    {"set", (PyCFunction)PyPageBloomFilter_set, METH_O, "insert a key"},
    {"test", (PyCFunction)PyPageBloomFilter_test, METH_O, "test a key"},
    {"capacity", (PyCFunction)PyPageBloomFilter_capacity, METH_NOARGS, "return nominal capacity"},
    {"virtual_capacity", (PyCFunction)PyPageBloomFilter_virtual_capacity, METH_VARARGS,
     "estimate capacity by false-positive rate"},
    {"virual_capacity", (PyCFunction)PyPageBloomFilter_virtual_capacity, METH_VARARGS,
     "deprecated misspelling kept for compatibility"},
    {"export_state", (PyCFunction)PyPageBloomFilter_export_state, METH_NOARGS,
     "return (way, page_level, data, unique_cnt)"},
    {NULL, NULL, 0, NULL}
};

static PyGetSetDef PyPageBloomFilter_getset[] = {
    {"way", (getter)PyPageBloomFilter_get_way, NULL, "number of probes", NULL},
    {"page_level", (getter)PyPageBloomFilter_get_page_level, NULL, "log2(page size)", NULL},
    {"page_num", (getter)PyPageBloomFilter_get_page_num, NULL, "number of pages", NULL},
    {"unique_cnt", (getter)PyPageBloomFilter_get_unique_cnt, NULL, "approximate unique count", NULL},
    {"data", (getter)PyPageBloomFilter_get_data, NULL, "read-only bitmap view", NULL},
    {NULL, NULL, NULL, NULL, NULL}
};

static PySequenceMethods PyPageBloomFilter_as_sequence = {
    .sq_contains = PyPageBloomFilter_contains,
};

static PyTypeObject PyPageBloomFilterType = {
    PyVarObject_HEAD_INIT(NULL, 0)
    .tp_name = "_pbf.PageBloomFilter",
    .tp_basicsize = sizeof(PyPageBloomFilter),
    .tp_itemsize = 0,
    .tp_dealloc = (destructor)PyPageBloomFilter_dealloc,
    .tp_flags = Py_TPFLAGS_DEFAULT | Py_TPFLAGS_BASETYPE,
    .tp_doc = "Page Bloom Filter backed by the native C implementation",
    .tp_methods = PyPageBloomFilter_methods,
    .tp_getset = PyPageBloomFilter_getset,
    .tp_as_sequence = &PyPageBloomFilter_as_sequence,
    .tp_init = (initproc)PyPageBloomFilter_init,
    .tp_new = PyPageBloomFilter_new,
    .tp_repr = (reprfunc)PyPageBloomFilter_repr,
};

#define PARSE_RW_BUFFER_AND_KEY()                                             \
    Py_buffer space = {0};                                                    \
    const uint8_t* key = NULL;                                                \
    Py_ssize_t key_len = 0;                                                   \
    unsigned page_level = 0;                                                  \
    if (!PyArg_ParseTuple(args, "w*Is#",                                       \
                          &space, &page_level, &key, &key_len)) {             \
        return NULL;                                                          \
    }

#define DEFINE_PY_FUNC(way) \
static PyObject* set##way(PyObject* self, PyObject* args) { \
    int ret; \
    PARSE_RW_BUFFER_AND_KEY() \
    if (!validate_page_buffer(&space, page_level)) { \
        PyBuffer_Release(&space); \
        return NULL; \
    } \
    ret = PBF##way##_Set(space.buf, page_level, (unsigned)(space.len >> page_level), key, (unsigned)key_len); \
    PyBuffer_Release(&space); \
    return PyBool_FromLong(ret); \
} \
static PyObject* test##way(PyObject* self, PyObject* args) { \
    int ret; \
    PARSE_RW_BUFFER_AND_KEY() \
    if (!validate_page_buffer(&space, page_level)) { \
        PyBuffer_Release(&space); \
        return NULL; \
    } \
    ret = PBF##way##_Test(space.buf, page_level, (unsigned)(space.len >> page_level), key, (unsigned)key_len); \
    PyBuffer_Release(&space); \
    return PyBool_FromLong(ret); \
}

DEFINE_PY_FUNC(4)
DEFINE_PY_FUNC(5)
DEFINE_PY_FUNC(6)
DEFINE_PY_FUNC(7)
DEFINE_PY_FUNC(8)

static PyObject* raw_clear(PyObject* self, PyObject* args) {
    Py_buffer space = {0};
    if (!PyArg_ParseTuple(args, "w*", &space)) {
        return NULL;
    }
    memset(space.buf, 0, (size_t)space.len);
    PyBuffer_Release(&space);
    Py_RETURN_NONE;
}

static PyMethodDef funcs[] = {
    {"restore", (PyCFunction)(void(*)(void))module_restore, METH_VARARGS | METH_KEYWORDS,
     "restore a PageBloomFilter from bytes"},
    {"clear", raw_clear, METH_VARARGS, "clear raw buffer"},
    {"set4", set4, METH_VARARGS, "4-way raw set"},
    {"test4", test4, METH_VARARGS, "4-way raw test"},
    {"set5", set5, METH_VARARGS, "5-way raw set"},
    {"test5", test5, METH_VARARGS, "5-way raw test"},
    {"set6", set6, METH_VARARGS, "6-way raw set"},
    {"test6", test6, METH_VARARGS, "6-way raw test"},
    {"set7", set7, METH_VARARGS, "7-way raw set"},
    {"test7", test7, METH_VARARGS, "7-way raw test"},
    {"set8", set8, METH_VARARGS, "8-way raw set"},
    {"test8", test8, METH_VARARGS, "8-way raw test"},
    {NULL, NULL, 0, NULL}
};

static struct PyModuleDef module = {
    PyModuleDef_HEAD_INIT,
    "_pbf",
    NULL,
    -1,
    funcs
};

PyMODINIT_FUNC PyInit__pbf(void) {
    PyObject* m;

    if (PyType_Ready(&PyPageBloomFilterType) < 0) {
        return NULL;
    }

    m = PyModule_Create(&module);
    if (m == NULL) {
        return NULL;
    }

    Py_INCREF(&PyPageBloomFilterType);
    if (PyModule_AddObject(m, "PageBloomFilter", (PyObject*)&PyPageBloomFilterType) < 0) {
        Py_DECREF(&PyPageBloomFilterType);
        Py_DECREF(m);
        return NULL;
    }

    return m;
}
