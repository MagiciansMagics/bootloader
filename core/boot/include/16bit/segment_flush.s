[BITS 16]

_flush_registers_real_mode:
  cli                                   ; Disable interrupts for safety

  xor ax, ax                            ; AX = 0
  mov ds, ax
  mov es, ax
  mov fs, ax
  mov gs, ax
  mov ss, ax

  xor ax, ax                            ; Flush general purpose registers
  xor bx, bx
  xor cx, cx
  xor dx, dx
  xor si, si
  xor di, di
  xor bp, bp

  clc                                   ; clear carry flag 

  sti

  ret