#include <stdio.h>
#include <stdint.h>

struct test
{
    /* data */
    int a;
    char b;
    int c;
    short d;
};  // sizeof: 16 Bytes

struct test2
{
    /* data */
    int a;
    int b;
    char c;
    short d;
};  // sizeof: 12 Bytes

struct test3
{
    /* data */
    char c;
    short d;
    int a;
    int b;
};  // sizeof: 12 Bytes

// 伪指令 #pragma pack(n)（n为字节对齐数）来使得结构间一字节对齐
#pragma pack(1)
struct test4
{
    /* data */
    int a;
    char b;
    int c;
    short d;
};  // sizeof: 11 Bytes

#pragma pack()

// 另外一种 pack 的方式
struct test5
{
    int a;
    char b;
    int c;
    short d;
}__attribute__ ((packed));  // sizeof: 11 Bytes

struct test6
{
    int a;
    char b;
    int c;
    short d;
    char e[];
}__attribute__ ((packed));  // sizeof: 11 Bytes

int main(int argc, char **argv) {
    printf("The size of struct test is %zu\n", sizeof(struct test));
    printf("The size of struct test2 is %zu\n", sizeof(struct test2));
    printf("The size of struct test3 is %zu\n", sizeof(struct test3));
    printf("The size of struct test4 is %zu\n", sizeof(struct test4));
    printf("The size of struct test5 is %zu\n", sizeof(struct test5));
    printf("The size of struct test6 is %zu\n", sizeof(struct test6));
    return 0;
}

// Build: gcc -m64 -o byte_align byte_align.c
// Run: 
//  chmod +x byte_align
//  ./byte_align
// https://www.cnblogs.com/clover-toeic/p/3853132.html