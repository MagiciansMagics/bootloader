#include <printf/printf.h>
#include <font/font.h>

static unsigned int pcursor_x = 0;
static unsigned int pcursor_y = 0;

const uint8_t* 
font_bitmap(uint8_t c)
{
  if (c >= 32) // we just wanna skip the unprint able stuff except space
  {
    return &default_font[(c) * 32];
  }
  return NULL;
}

void
put_char(uint8_t c, uint32_t color)
{
  if (pcursor_x >= SCREEN_WIDTH && pcursor_y >= SCREEN_HEIGHT) return;

  if (pcursor_x >= SCREEN_WIDTH)
  {
    pcursor_x = 0;
    pcursor_y += FONT_HEIGHT;
  }
  if (c == '\n')
  {
    pcursor_x = 0;
    pcursor_y += FONT_HEIGHT;
  }
  const uint8_t* bitmap = font_bitmap(c);
  if (!bitmap) return;
  for (uint32_t row = 0; row < FONT_HEIGHT; row++)
  {
    uint8_t row_data1 = bitmap[row * 2];
    uint8_t row_data2 = bitmap[row * 2 + 1];
    for (uint32_t col = 0; col < FONT_WIDTH; col++)
    {
      uint16_t bit = 0;
      if (col < 8)
        bit = (row_data1 >> (7 - col)) & 1;
      else
        bit = (row_data2 >> (15 - col)) & 1;
      if (bit)
        draw_pixel(pcursor_x + col, pcursor_y + row, color);
    }
  }

  pcursor_x += FONT_WIDTH - 1;
}

void 
debug(const uint8_t *str)
{
  if (!str) return;
  while (*str != '\0')
  {
    put_char(*str++, rgba_to_hex(0, 255, 0, 255));
  }
  pcursor_x = 0;
  pcursor_y += FONT_HEIGHT;
}

void
vfprintf(_IO_FLAGS stream, const char *fmt, va_list args)
{
  (void)stream;
  char buffer[32];
  while (*fmt != '\0')
  {
    if (*fmt == '%')
    {
      fmt++;
      if (*fmt == '\0') break;
      switch (*fmt)
      {
        case 'd':
        {
          int a = va_arg(args, int);
          itoa(a, buffer, 10);
          for (char* b = buffer; *b; b++)
            put_char((uint8_t)*b, rgba_to_hex(200, 200, 200, 255));
          break;
        }
        case 'X':
        case 'x':
        {
          int a = va_arg(args, int);
          itoa(a, buffer, 16);
          for (char* b = buffer; *b; b++)
            put_char((uint8_t)*b, rgba_to_hex(200, 200, 200, 255));
          break;
        }
        case 's':
        {
          const char* a = va_arg(args, const char*);
          for (; *a; a++)
            put_char((uint8_t)*a, rgba_to_hex(200, 200, 200, 255));
          break;
        }
        default:
        {
          put_char('%', rgba_to_hex(200, 200, 200, 255));
          put_char((uint8_t)*fmt, rgba_to_hex(200, 200, 200, 255));
          break;
        }
      }
    }
    else
    {
      put_char((uint8_t)*fmt, rgba_to_hex(200, 200, 200, 255));
    }
    fmt++;
  }
}

int
printf(const char *fmt, ...)
{
  va_list args;
  va_start(args, fmt);

  vfprintf(stdout, fmt, args);

  va_end(args);

  return 0;
}