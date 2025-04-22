#include <malloc.h>
#include <printf/printf.h>
#include <pci/pci.h>

void 
main(void)
{
  init_malloc();

  debug((const uint8_t*)"Welcome to shitty boot manager!"); // ignore this

  PciScan();
}