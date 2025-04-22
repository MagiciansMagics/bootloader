_vbe_video_mode_load:
  call _flush_registers_real_mode

  mov ax, 0x4F00
  mov di, VbeInfoBlock
  int 0x10

  cmp ax, 0x004F
  jne ._vbe_video_mode_load_error

  mov ax, [VbeInfoBlock.VideoModePtr]
  mov [VBE_offset], ax
  mov ax, [VbeInfoBlock.VideoModePtr+2]
  mov [VBE_segment], ax

  mov fs, [VBE_segment]
  mov si, [VBE_offset]

._vbe_video_mode_load_loop:
  mov dx, [fs:si]
  add si, 0x02
  mov [VBE_offset], si
  mov [VBE_Video_mode], dx

  cmp dx, word 0xFFFF
  je ._vbe_video_load_end_error

  mov ax, 0x4F01
  mov cx, [VBE_Video_mode]
  mov di, ModeInfoBlock
  int 0x10

  cmp ax, 0x004F
  jne ._vbe_video_mode_load_error

  mov ax, [VBE_Width]
  cmp ax, [ModeInfoBlock.XResolution]
  jne ._vbe_video_mode_load_next_mode

  mov ax, [VBE_Height]
  cmp ax, [ModeInfoBlock.YResolution]
  jne ._vbe_video_mode_load_next_mode

  mov al, [VBE_BPP]
  cmp al, [ModeInfoBlock.BitsPerPixel]
  jne ._vbe_video_mode_load_next_mode

  xor ax, ax
  mov es, ax

  mov ax, 0x4F02
  mov bx, [VBE_Video_mode]
  or bx, 0x4000
  int 0x10

  cmp ax, 0x004F
  jne ._vbe_video_mode_load_error

  mov byte [vbe_enabled], 0x01

  ret

._vbe_video_mode_load_next_mode:
  mov ax, [VBE_segment]
  mov fs, ax
  mov si, [VBE_offset]

  jmp ._vbe_video_mode_load_loop

._vbe_video_mode_load_error:
  mov byte [vbe_enabled], 0x00
  ret

._vbe_video_load_end_error:
  mov ax, 0x0e63
  int 0x10
  mov byte [vbe_enabled], 0x00
  ret

VbeInfoBlock:
  .VbeSignature:                    db      'VESA'        ; VBE Signature
  .VbeVersion:                      dw      0             ; VBE Version
  .OemStringPtr:                    dd      0             ; VBEFarPtr to OEM String
  .Capabilities:                    dd      0             ; Capabilities of graphics controller.
  .VideoModePtr:                    dd      0             ; VBEFarPtr to VideoModeList
  .TotalMemory:                     dw      0             ; Number of 64kb memory blocks
  ; Added for VBE 2.0+
  .OemSoftwareRev:                  dw      0             ; VBE implementation SoftwareRevision
  .OemVendorNamePtr:                dd      0             ; VbeFarPtr to Vendor Name String
  .OemProductNamePtr:               dd      0             ; VbeFarPtr to Product Name String
  .OemProductRevPtr:                dd      0             ; VbeFarPtr to Product Revision String

  .Reserved:                        times   222 db 0      ; Reserved for VBE implementation area

  .OemData:                         times   256 db 0      ; Data Area for OEM Strings

ModeInfoBlock:

  ; Mandatory information for all VBE revisions

  .ModeAttributes:                  dw      0             ; mode attributes
  .WinAAttributes:                  db      0             ; window A attributes
  .WinBAttributes:                  db      0             ; window B attributes
  .WinGranularity:                  dw      0             ; window granularity
  .WinSize:                         dw      0             ; window size
  .WinASegment:                     dw      0             ; window A start segment
  .WinBSegment:                     dw      0             ; window B start segment
  .WinFuncPtr:                      dd      0             ; real mode pointer to window function
  .BytesPerScanLine:                dw      0             ; bytes per scan line

  ; Mandatory information for VBE 1.2 and above

  .XResolution:                     dw      0             ; horizontal resolution in pixels or characters³
  .YResolution:                     dw      0             ; vertical resolution in pixels or characters
  .XcharSize:                       db      0             ; character cell width in pixels
  .YCharSize:                       db      0             ; character cell height in pixels
  .NumberOfPlanes:                  db      0             ; number of memory planes
  .BitsPerPixel:                    db      0             ; bits per pixel
  .NumberOfBanks:                   db      0             ; number of banks
  .MemoryModel:                     db      0             ; memory model type
  .BankSize:                        db      0             ; bank size in KB
  .Reserved0:                       db      1             ; reserved for page function

  ; Direct color fields (required for direct/6 and YUV/7 memory models)

  .RedMaskSize:                     db      0             ; size of direct color red mask in bits
  .RedFieldPosition:                db      0             ; bit position of lsb of red mask
  .GreenMaskSize:                   db      0             ; size of direct color green mask in bits
  .GreenFieldPosition:              db      0             ; bit position of lsb of green mask
  .BlueMaskSize:                    db      0             ; size of direct color blue mask in bits
  .BlueFieldPosition:               db      0             ; bit position of lsb of blue mask
  .RsvdMaskSize:                    db      0             ; size of direct color reserved mask in bits
  .RsvdFieldPosition:               db      0             ; bit position of lsb of reserved mask in bits
  .DirectColorModeInfo:             db      0             ; direct color mode attributes

  ; Mandatory information for VBE 2.0 and above

  .PhysBasePtr:                     dd      0             ; physical address for flat memory frame buffer
  .Reserved1:                       dd      0             ; Reserved - always set to 0
  .Reserved2:                       dw      0             ; Reserved - always set to 0

  ; Mandatory information for VBE 3.0 and above

  .LinBytesPerScanLine:             dw      0             ; bytes per scan line for linear modes
  .BnkNumberOfImagePages:           db      0             ; number of images for banked modes
  .LinNumberOfImagePages:           db      0             ; number of images for linear modes
  .LinRedMaskSize:                  db      0             ; size of direct color red mask (linear modes)
  .LinRedFieldPosition:             db      0             ; bit position of lsb of red mask (linear modes)
  .LinGreenMaskSize:                db      0             ; size of direct color green mask (linear modes)
  .LinGreenFieldPosition:           db      0             ; bit positon of lsb of green mask (linear modes)
  .LinBlueMaskSize:                 db      0             ; size of direcct color blue mask (linear modes)
  .LinBlueFieldPosition:            db      0             ; bit position of lsb of blue mask (linear modes)
  .LinRsvdMaskSize:                 db      0             ; size of direct color reserved mask (linear modes)
  .LinRsvdFieldPosition:            db      0             ; bit position of lsb of reserver mask (linear mode)
  .MaxPixelClock:                   dd      0             ; maxium pixel clock (in Hz) for graphics mode

  .Reserved3:                       times   190 db 0      ; remainder of ModeInfoBlock

CRTCInfoBlock:
  .HorizontalTotal:                 dw      0             ; Horizontal total in pixels
  .HorizontalSyncStart:             dw      0             ; Horizontal sync start in pixels
  .HorizontalSyncEnd:               dw      0             ; Horizontal sync end in pixels
  .VerticalTotal:                   dw      0             ; Vertical total in lines
  .VerticalSyncStart:               dw      0             ; Vertical sync start in lines
  .VerticalSyncEnd:                 dw      0             ; Vertical sync end in lines
  .Flags                            db      0             ; Flags (Interlaced, Double Scan etc)
  .PixelClock:                      dd      0             ; Pixel clock in units of Hz
  .RefreshRate:                     dw      0             ; Refrest rate in units of 0.01 Hz

  .Reserved:                        times   40 db 0       ; Remainder of CRTCInfoBlock


VBE_Width: dw 1024
VBE_Height: dw 768
VBE_BPP: db 32
VBE_segment: dw 0
VBE_offset: dw 0
VBE_Video_mode: dd 0
vbe_enabled: db 0