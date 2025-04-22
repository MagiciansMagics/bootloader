#ifndef _STRING_H_
#define _STRING_H_

#include <types.h>

void
memcpy(void *dest, void *src, uint32_t n);

char* 
itoa(int value, char* str, int base);

#endif