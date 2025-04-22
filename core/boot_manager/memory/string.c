#include <string.h>

void
memcpy(void *dest, void *src, uint32_t n)
{ 
  uint8_t *csrc = (uint8_t*)src; 
  uint8_t *cdest = (uint8_t*)dest; 

  for (uint32_t i=0; i<n; i++) 
    cdest[i] = csrc[i]; 
}

char* 
itoa(int value, char* str, int base) 
{
  int i = 0;
  int isNegative = 0;

  if (value == 0) 
  {
    str[i++] = '0';
    str[i] = '\0';
    return str;
  }

  if (value < 0 && base == 10) 
  {
    isNegative = 1;
    value = -value;
  }

  while (value != 0) 
  {
    int rem = value % base;
    str[i++] = (rem > 9) ? (char)(rem - 10 + 'a') : (char)(rem + '0');
    value = value / base;
  }

  if (isNegative) 
  {
    str[i++] = '-';
  }

  str[i] = '\0';

  for (int start = 0, end = i - 1; start < end; start++, end--) 
  {
    char temp = str[start];
    str[start] = str[end];
    str[end] = temp;
  }

  return str;
}