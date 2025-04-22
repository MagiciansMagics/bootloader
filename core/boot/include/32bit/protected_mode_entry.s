[BITS 32]

%include "32bit/variables.s"
%include "32bit/pm_mode_segment.s"

_protected_mode_entry:
  call _pm_mode_segment

  mov ebp, 0x90000
  mov esp, ebp

  mov esi, ModeInfoBlock
  mov edi, 0x2000
  mov ecx, 64                 ; Mode info block is 256 bytes / 4 = # of dbl words
  rep movsd

  mov dl, [vbe_enabled]
  mov [0x1500], dl

  jmp 0x8800

  jmp halt