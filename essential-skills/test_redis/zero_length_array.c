#include <stdio.h>
#include <stdint.h>
#include <string.h>
#include <stdlib.h>

#define MAX_LENGTH      1024
#define CURR_LENGTH      512

// Zero length array
struct zero_length_array
{
    /* data */
    int len;
    char data[0];
}__attribute__ ((packed));

// Fixec array
struct fixed_array
{
    /* data */
    int len;
    char data[MAX_LENGTH];
}__attribute__ ((packed));

// Pointer array
struct pointer_array {
    int len;
    char *data;
}__attribute__ ((packed));

int main(void) {
    // 声明
    struct zero_length_array *zarray = NULL;
    struct fixed_array *farray = NULL;
    struct pointer_array *parray = NULL;

    /////////// zero length array
    // 占用
    printf("The size of zero array is %zu\n", sizeof(struct zero_length_array));
    // (zbuffer = (struct zero_buffer *)malloc(sizeof(struct zero_buffer) + sizeof(char) * CURR_LENGTH))

    // 分配
    zarray = (struct zero_length_array *)malloc(sizeof(struct zero_length_array) + sizeof(char) * CURR_LENGTH);
    if (zarray != NULL) {
        zarray->len = CURR_LENGTH;
        memcpy(zarray->data, "Hello World, i'm back.", CURR_LENGTH);

        printf("%d, %s\n", zarray->len, zarray->data);
    }

    // 销毁
    free(zarray);
    zarray = NULL;

    ////////// fixed array
    // 占用
    printf("The size of fixed array is %zu\n", sizeof(struct fixed_array));

    // 分配
    farray = (struct fixed_array *)malloc(sizeof(struct fixed_array));
    if (farray != NULL) {
        farray->len = CURR_LENGTH;
        memcpy(farray->data, "Hahahah....", CURR_LENGTH);

        printf("%d, %s\n", farray->len, farray->data);
    }

    free(farray);
    farray = NULL;

    ///////// pointer array
    printf("The size of fixed array is %zu\n", sizeof(struct pointer_array));

    // 分配
    parray = (struct pointer_array *)malloc(sizeof(struct pointer_array));
    if (parray != NULL) {
        parray->len = CURR_LENGTH;

        // 分配存储数据的内存
        if((parray->data = (char *)malloc(sizeof(char) * parray->len)) != NULL) {
            memcpy(parray->data, "666666666", parray->len);

            printf("%d, %s\n", parray->len, parray->data);
        }
    }

    // 释放
    free(parray->data);
    free(parray);
    parray = NULL;

    return 0;
}
