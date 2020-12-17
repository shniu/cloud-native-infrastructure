all: netio_epoll.o

netio_epoll.o: netio_epoll.c
	gcc -m64 -Wall -Werror -o $@ netio_epoll.c

clean: 
	@rm -v *.o
