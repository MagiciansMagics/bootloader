#ifndef _PRINT_H_
#define _PRINT_H_

#include <types.h>
#include <string.h>
#include <draw/draw.h>

#define FONT_WIDTH  12
#define FONT_HEIGHT 16

typedef enum
{
  stdin = 0,
  stdout = 1,
  stderr = 2,
} _IO_FLAGS;

const unsigned char* 
font_bitmap(unsigned char c);

void
put_char(uint8_t c, uint32_t color);

void 
debug(const uint8_t* str);

void
vfprintf(_IO_FLAGS stream, const char *fmt, va_list arg);

int
printf(const char *fmt, ...);

#endif