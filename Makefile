CC=gcc
CFLAGS=-fPIC -Wall -pthread -fwrapv -g3 `pkg-config --cflags bitlbee python2`
LDFLAGS=-ldl -shared `pkg-config --libs python2`

all: bitlbee_cython.so

%.c: %.pyx
	cython2 $<

bitlbee_cython.so: bitlbee_cython.o stub.o
	$(CC) $(CFLAGS) $(LDFLAGS) $^ -o $@

clean:
	rm -f *.so *.o

install:
	install -m 0644 bitlbee_cython.so $(shell pkg-config --variable=plugindir bitlbee)

.PHONY: clean install
