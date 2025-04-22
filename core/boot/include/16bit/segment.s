[BITS 16]

_real_mode_segment:
  cli                                   ; Shut down interrupts for combality

  xor ax, ax                            ; Set ax to 0   
  mov ds, ax                            ; Set Data segment to 0
  mov es, ax                            ; Set Extra segment to 0
  mov ss, ax                            ; Set Stack segment to 0

  ret

  jmp 0x0000:_real_mode_continue

_real_mode_continue:
  xor ax, ax                            ; Set ax to 0     
  mov bx, ax                            ; Set bx to 0
  mov cx, ax                            ; Set cx to 0
  mov dx, ax                            ; Set dx to 0
  mov si, ax                            ; Set Source index to 0
  mov di, ax                            ; Set Destination index to 0
  mov bp, ax                            ; Set Base pointer to 0
  mov sp, 0x7C00                        ; Set Stack pointer to 0x7C00

  sti                                   ; Turn on interrupts

  ret