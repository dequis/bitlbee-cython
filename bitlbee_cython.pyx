import sys
import code
from cStringIO import StringIO

cdef extern from "bitlbee.h":
    # this is copied straight from bitlbee.h
    int root_command_add(const char *command, int params, void (*func)(irc_t *, char **args), int flags);
    void irc_rootmsg(irc_t *irc, char *format, ...);

    ctypedef struct irc_t:
        # pretend this is opaque
        pass


def eval_stuff(arg):
    try:
        try:
            # try to eval as an expression
            result = eval(compile(arg, '<bitlbee>', 'eval'))
        except SyntaxError:
            # that didn't work - capture stdout and evaluate as a statement
            old_stdout = sys.stdout
            sys.stdout = StringIO()

            try:
                exec code.compile_command(arg)
            finally:
                result = sys.stdout.getvalue()
                sys.stdout = old_stdout

    except Exception, e:
        result = "Exception: %s" % e

    if not isinstance(result, basestring):
        return repr(result)
    elif isinstance(result, unicode):
        return result.encode("utf-8")
    else:
        return result


cdef void cmd_eval(irc_t *irc, char **args):
    cdef char *result_c;

    result = eval_stuff(args[1]);       # keep this reference around
    result_c = result;                  # cast to char *
    irc_rootmsg(irc, "%s", result_c);


cdef public void init_py_plugin():
    root_command_add("eval", 1, cmd_eval, 0);
