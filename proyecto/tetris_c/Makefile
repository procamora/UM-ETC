default: tetris

all: tetris

tetris: tetris.c mips-runtime.c mips-runtime.h keyio.c keyio.h
	gcc -Wall -g -std=c99 -O2 -otetris tetris.c mips-runtime.c keyio.c

clean:
	rm -f tetris
