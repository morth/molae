
CPPFLAGS=-DDEBUG
CFLAGS=-g -Os -Wall
LDLIBS=-framework Cocoa
LDFLAGS=-g

test: molae.o test.o

depend:
	mkdep ${CPPFLAGS} ${CFLAGS} *.c *.m

clean:
	rm -f test *.o

-include .depend
