_store_disk_number:
  mov [disk_number], dl
  ret

_drive_load:
  pusha

  mov si, 0x0000              ; Counter for how many times have been tried to read the sector

  mov ah, 0x02
    
.loop_read:
  inc si

  int 0x13

  jc .drive_load_error

  jmp .loop_read_done

.drive_load_error:
  cmp si, read_retrys
  je .loop_read_end

  jmp .loop_read

.loop_read_end:
  popa
  cli
  hlt

.loop_read_done:
  popa
  ret