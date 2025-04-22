[BITS 32]

[GLOBAL start]
[GLOBAL _start]

[EXTERN main]

jmp _start

%include "halt.s"

start:
_start:
  call main
  
  jmp halt