all: netio_epoll

epoll_example: netio_epoll.c
	gcc -m64 -Wall -Werror -o $@ netio_epoll.c

clean: 
	@rm -v netio_epoll
