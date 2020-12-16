/**
 * Network IO with epoll.
 *
 * via: https://github.com/onestraw/epoll-example/blob/master/epoll.c
 *      http://hushi55.github.io/2015/01/28/liunx-epoll-example
 *      https://blog.csdn.net/liuruiqun/article/details/51162651
 *      https://my.oschina.net/frankak/blog/341582
 */

#include <stdio.h>
#include <sys/epoll.h>
#include <unistd.h>

int main(int argc, char **argv) {
    short port = 7654;
    int epoll_fd = epoll_create(1);
    
}
