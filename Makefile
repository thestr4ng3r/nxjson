
all: nxjson

nxjson: nxjson.c test.c nxjson.h
	gcc -O0 -g -Wall ${CFLAGS} nxjson.c test.c -o nxjson

clean:
	rm nxjson

.PHONY: clean
