#include <malloc.h>

struct malloc_header_t* malloc_ht;

void 
init_malloc(void)
{
  malloc_ht = (malloc_header_t*)MEM_POOL_SIZE;
  malloc_ht->next = NULL;
  malloc_ht->prev = NULL;
  malloc_ht->size = MEM_POOL_SIZE - BLOCK_SIZE;
  malloc_ht->used = 0; 
}

void 
*malloc(size_t size)
{
  if (size > MAX_ALLOC_SIZE)
    return NULL;
  malloc_header_t* current = malloc_ht;
  while (current)
  {
    if (!current->used && current->size >= size)
    {
      if (current->size > size + BLOCK_SIZE)
      {
        malloc_header_t* new_block = (malloc_header_t*)((uint8_t*)current + BLOCK_SIZE + size);
        new_block->size = current->size - size - BLOCK_SIZE;
        new_block->used = 0;
        new_block->next = current->next;
        new_block->prev = current;
        if (current->next)
          current->next->prev = new_block;
        current->next = new_block;
        current->size = size;
      }
      current->used = 1;
      return (uint8_t*)current + BLOCK_SIZE;
    }
    current = current->next;
  }
  return NULL;
}

void
free(void *ptr)
{
  if (!ptr) return;
  malloc_header_t *block = (malloc_header_t*)((uint8_t*)ptr - BLOCK_SIZE);
  block->used = 0;
  if (block->next && !block->next->used)
  {
    block->size += BLOCK_SIZE + block->next->size;
    block->next = block->next->next;
    if (block->next)
      block->next->prev = block;
  }
  if (block->prev && !block->prev->used)
  {
    block->prev->size += BLOCK_SIZE + block->size;
    block->prev->next = block->next;
    if (block->next)
      block->next->prev = block->prev;
  }
}