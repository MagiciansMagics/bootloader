_pm_mode_segment:
  mov ax, DATA_SEG
  mov ds, ax
  mov es, ax
  mov fs, ax
  mov gs, ax
  mov ss, ax

  xor eax, eax
  mov ebx, eax
  mov ecx, eax
  mov edx, eax
  mov edi, eax
  mov esi, eax
  ret