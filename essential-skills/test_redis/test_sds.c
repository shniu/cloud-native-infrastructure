#include <stdio.h>
#include <stdint.h>
#include <sys/types.h>
#include <string.h>
#include <stdlib.h>

struct __attribute__ ((__packed__)) sdshdr8
{
    /* data */
    uint8_t len;
    uint8_t alloc;
    unsigned char flags;
    char buf[];
};  // sizeof: 3 Bytes

struct __attribute__ ((__packed__)) sdshdr32
{
    /* data */
    uint32_t len;
    uint32_t alloc;
    unsigned char flags;
    char buf[];
}; // sizeof: 9 Bytes

struct npsdshdr32
{
    /* data */
    uint32_t len;
    uint32_t alloc;
    unsigned char flags;
    char buf[];
};  // sizeof: 12 Bytes

typedef char *sds;

sds newSDS(uint32_t initlen) {
    void *sp;
    sds s;
    unsigned char *fp;

    int hdrlen = sizeof(struct sdshdr32);
    // +1 是为了在最后加上 \0 字符
    sp = malloc(hdrlen + initlen + 1);
    s = (char *)sp + hdrlen;
    // 定位 flags, 通过柔性数组的地址 - 1
    fp = ((unsigned char*)s)-1;

    s[0] = 'a';
    s[initlen] = '\0';

    return s;
}

int main(int argv, char **argc) {
    printf("The size of struct sdshdr8 is %zu\n", sizeof(struct sdshdr8));

    printf("The size of struct sdshdr32 is %zu\n", sizeof(struct sdshdr32));

    printf("The size of struct npsdshdr32 is %zu\n", sizeof(struct npsdshdr32));

    sds s = newSDS(10);
    printf("sds content is: %s\n", s);

    return 0;
}
