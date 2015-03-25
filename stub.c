#include <Python.h>
#include "bitlbee_cython.h"

void init_plugin() {
    PyObject* m = NULL;

    /* passing 0 here to skip initialization of signal handlers */
    Py_InitializeEx(0);

#if PY_MAJOR_VERSION < 3
    initbitlbee_cython();  /* python2-style module initializer name */
#else
    m = PyInit_bitlbee_cython();
#endif
    Py_XDECREF(m);

    init_py_plugin();
}

/* this is needed to prevent segfaults at exit (most of the time)
 * bitlbee doesn't call this, glib does, thankfully */
void g_module_unload(void *module) {
    Py_Finalize();
}
