#include <pci/pci.h>

// 

uint8_t 
PCIConfigReadByte(uint8_t bus, uint8_t slot, uint8_t func, uint8_t offset) 
{
  uint32_t address;
  uint32_t lbus  = (uint32_t)bus;
  uint32_t lslot = (uint32_t)slot;
  uint32_t lfunc = (uint32_t)func;
  address = (lbus << 16) | (lslot << 11) | (lfunc << 8) | (offset & 0xFC) | 0x80000000;
  outb(0xCF8, address);
  return inb(0xCFC + (offset & 3));
}


uint16_t 
PCIConfigReadWord(uint8_t bus, uint8_t slot, uint8_t func, uint8_t offset) 
{
  uint32_t address;
  uint32_t lbus  = (uint32_t)bus;
  uint32_t lslot = (uint32_t)slot;
  uint32_t lfunc = (uint32_t)func;
  address = (uint32_t)((lbus << 16) | (lslot << 11) | (lfunc << 8) | (offset & 0xFC) | ((uint32_t)0x80000000));
  outw(0xCF8, address);
  return inw(0xCFC + (offset & 3));
}

uint32_t 
PCIConfigReadDWord(uint8_t bus, uint8_t slot, uint8_t func, uint8_t offset) 
{
  uint32_t address;
  uint32_t lbus  = (uint32_t)bus;
  uint32_t lslot = (uint32_t)slot;
  uint32_t lfunc = (uint32_t)func;
  address = (uint32_t)((lbus << 16) | (lslot << 11) | (lfunc << 8) | (offset & 0xFC) | ((uint32_t)0x80000000));
  outl(0xCF8, address);
  return inl(0xCFC);
}

uint16_t 
PCIRetVendorID(uint8_t bus, uint8_t device, uint8_t func) 
{
  uint16_t a = PCIConfigReadWord(bus, device, func, 0);
  if (a != 0xFFFF) 
    return a;
  return PCI_ERROR;
}

uint16_t
PCIRetDeviceID(uint8_t bus, uint8_t device, uint8_t func)
{
  uint16_t a = PCIConfigReadWord(bus, device, func, 0x02);
  if (a != 0xFFFF)
    return a;
  return PCI_ERROR;
}

uint8_t
PCIRetHeaderType(uint8_t bus, uint8_t device, uint8_t func)
{
  uint8_t a = PCIConfigReadByte(bus, device, func, 0xE);
  if ((a & 0x7F) > 2)
    return a;
  return PCI_ERROR;
}

bool
PCISafetyCheck(uint8_t bus, uint8_t device, uint8_t func)
{
  if (!PCIRetVendorID(bus, device, func))       return PCI_ERROR;
  if (!PCIRetDeviceID(bus, device, func))       return PCI_ERROR;
  if (!PCIRetHeaderType(bus, device, func))     return PCI_ERROR;
  return PCI_SUCCESS;
}

bool
PCISafety(uint8_t bus, uint8_t device, uint8_t func)
{
  if (!PCISafetyCheck(bus, device, func))
  {
    // probably store the error somewhere and handle it
    return PCI_ERROR;
  }
  return PCI_SUCCESS;
}

void
PciScan(void)
{
  for (uint16_t bus = 0; bus < 256; bus++)
  {
    for (uint8_t device = 0; device < 32; device++)
    {
      for (uint8_t func = 0; func < 8; func++)
      {
        if (PCISafety((uint8_t)bus, device, func))
        {
          uint16_t vendor_id = PCIRetVendorID((uint8_t)bus, device, func);
          uint16_t device_id = PCIRetDeviceID((uint8_t)bus, device, func);
          uint8_t revision_id = PCIConfigReadByte((uint8_t)bus, device, func, 0x08);
          uint8_t prog_if = PCIConfigReadByte((uint8_t)bus, device, func, 0x09);
          uint8_t subclass = PCIConfigReadByte((uint8_t)bus, device, func, 0x0A);
          uint8_t class_code = PCIConfigReadByte((uint8_t)bus, device, func, 0x0B);
          uint8_t header_type = PCIConfigReadByte((uint8_t)bus, device, func, 0x0E);
/*
          printf("PCI Device Found: Bus %d, Device %d, Function %d\n", bus, device, func);
          printf("  Vendor ID    : 0x%x\n", vendor_id);
          printf("  Device ID    : 0x%x\n", device_id);
          printf("  Class Code   : 0x%x\n", class_code);
          printf("  Subclass     : 0x%x\n", subclass);
          printf("  Prog IF      : 0x%x\n", prog_if);
          printf("  Revision ID  : 0x%x\n", revision_id);
          printf("  Header Type  : 0x%x\n", header_type);
*/

          if (class_code == 0x01)
          {  debug((const uint8_t*)"Storage device found!");
          }
          else if (class_code == 0x02)
          {
            debug((const uint8_t*)"Found network controller");
          }
          else
          {
            printf("%x ", class_code);
          }
        }
      }
    }
  }
}