all: byte_align.o

byte_align.o: byte_align.c
	gcc -m64 -Wall -Werror -o $@ byte_align.c

clean:
	@rm -v *.o