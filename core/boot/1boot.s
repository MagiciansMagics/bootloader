[ORG 0x7C00]
[BITS 16]

jmp _start

%include "halt.s"
%include "16bit/a20.s"
%include "16bit/variables.s"
%include "16bit/drive.s"
%include "16bit/segment.s"

[BITS 16]

_start:
_mbr_section_1:
  call _store_disk_number

  call _real_mode_segment

  mov ax, 0x0003
  int 0x10

  call _enable_a20

  xor ax, ax
  mov es, ax

  jmp 0x0000:_mbr_section_2

; Next stuff is tried to be copied from: https://en.wikipedia.org/wiki/Master_boot_record

%assign pad1 0x00DA - ($ - $$)
%if pad1 > 0
  times pad1 db 0
%endif

dw 0x0000                           ; Disk timestamp
db disk_number
db 0                                ; Seconds
db 0                                ; Minutes
db 0                                ; Hours

_mbr_section_2:
  mov al, 0x04
  mov ch, 0x00
  mov cl, 0x02
  mov dh, 0x00
  mov dl, [disk_number]
  mov bx, 0x7E00
  
  call _drive_load

  mov al, 0x7F
  mov ch, 0x00
  mov cl, 0x06
  mov dh, 0x00
  mov dl, [disk_number]
  mov bx, 0x8800
  
  call _drive_load

  mov dl, [disk_number]
  mov [0x1000], dl

  jmp 0x7E00

  jmp halt

times 0x01B8 - ($ - $$) db 0        ; At here we are at 440 bytes

dd 0xDEADBEEF                       ; Disk signature
dw 0x0000

times 0x01BE - ($ - $$) db 0
times 16 db 0                       ; Partition #1
times 16 db 0                       ; Partition #2
times 16 db 0                       ; Partition #3
times 16 db 0                       ; Partition #4

dw 0xAA55