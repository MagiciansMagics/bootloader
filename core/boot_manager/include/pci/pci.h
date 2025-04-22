#ifndef _PCI_H_
#define _PCI_H_

#include <types.h>
#include <io.h>
#include <printf/printf.h>

#define PCI_CONFIG_ADDRESS 0xCF8
#define PCI_CONFIG_DATA    0xCFC

typedef enum
{
  PCI_ERROR = 0,
  PCI_SUCCESS = 1,
} PCI_RET_VALS;

uint8_t 
PCIConfigReadByte(uint8_t bus, uint8_t slot, uint8_t func, uint8_t offset);

uint16_t 
PCIConfigReadWord(uint8_t bus, uint8_t slot, uint8_t func, uint8_t offset);

uint32_t 
PCIConfigReadDWord(uint8_t bus, uint8_t slot, uint8_t func, uint8_t offset);

uint16_t 
PCIRetVendorID(uint8_t bus, uint8_t device, uint8_t func);

uint16_t
PCIRetDeviceID(uint8_t bus, uint8_t device, uint8_t func);

uint8_t
PCIRetHeaderType(uint8_t bus, uint8_t device, uint8_t func);

bool
PCISafetyCheck(uint8_t bus, uint8_t device, uint8_t func);

bool
PCISafety(uint8_t bus, uint8_t device, uint8_t func);

void
PciScan(void);

#endif