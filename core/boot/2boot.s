[ORG 0x7E00]
[BITS 16]

jmp _start

%include "halt.s"
%include "16bit/variables.s"
%include "16bit/a20.s"
%include "16bit/segment.s"
%include "16bit/segment_flush.s"
%include "16bit/vbe.s"
%include "16bit/gdt32.s"
%include "32bit/protected_mode_entry.s"

[BITS 16]

_start:
  xor ax, ax
  mov es, ax
  mov ds, ax

  call _get_a20_state

  cmp ax, 0x00                      ; if a20 is not enabled
  je _enable_a20

  call _vbe_video_mode_load

	cli

	lgdt[gdt_descriptor]

	mov eax, cr0
	or al, 0x01
	mov cr0, eax

  jmp CODE_SEG:_protected_mode_entry

  jmp halt

times 2048 - ($-$$) db 0