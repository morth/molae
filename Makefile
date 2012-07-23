
CFLAGS=-g -Os -Wall
LDLIBS=-framework Cocoa
LDFLAGS=-g

test: molae.o test.o

-include .depend
