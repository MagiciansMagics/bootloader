#include <draw/draw.h>

void
draw_pixel(uint32_t x, uint32_t y, uint32_t color)
{
  unsigned int* framebuffer = (unsigned int *)(*(unsigned int*)0x2028);
  framebuffer[y * SCREEN_WIDTH + x] = color;
}

uint32_t 
rgba_to_hex(uint8_t r, uint8_t g, uint8_t b, uint8_t a) 
{
  return ((uint32_t)a << 24) | ((uint32_t)r << 16) | ((uint32_t)g << 8) | ((uint32_t)b);
}