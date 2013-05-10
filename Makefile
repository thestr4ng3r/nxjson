
all: nxjson

nxjson: nxjson.c
	gcc -O0 -g -DDEBUG ${CFLAGS} nxjson.c -o nxjson

clean:
	rm nxjson

.PHONY: clean
