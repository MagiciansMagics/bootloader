#ifndef _DRAW_H_
#define _DRAW_H_

#include <types.h>
#include <screen/screen.h>

void
draw_pixel(uint32_t x, uint32_t y, uint32_t color);

uint32_t 
rgba_to_hex(uint8_t r, uint8_t g, uint8_t b, uint8_t a);

#endif