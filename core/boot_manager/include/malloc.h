#ifndef _MALLOC_H_
#define _MALLOC_H_

#include <types.h>

#define MEM_POOL_SIZE (1024 * 1024)                     // 1 MB
#define MAX_ALLOC_SIZE (MEM_POOL_SIZE * 500)            // 500 MB
#define BLOCK_SIZE sizeof(malloc_header_t)

typedef struct 
malloc_header_t
{
  uint32_t size;
  uint32_t used;
  struct malloc_header_t* next;
  struct malloc_header_t* prev;
} malloc_header_t;

void 
init_malloc(void);

void 
*malloc(size_t size);

void
free(void *ptr);

#endif