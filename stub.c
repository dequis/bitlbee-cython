#include <Python.h>
#include "bitlbee_cython.h"

void init_plugin() {
    Py_Initialize();
    initbitlbee_cython();  /* python2-style module initializer name */
    init_py_plugin();
}

/* this is needed to prevent segfaults at exit (most of the time)
 * bitlbee doesn't call this, glib does, thankfully */
void g_module_unload(void *module) {
    Py_Finalize();
}
