; GDT

gdt_start:

gdt_null:  ; mandatory null descriptor. Catchess segment adressing bugs
  dd 0x0   ; dd means double word (ie. 4 bytes) 
  dd 0x0

gdt_code:  ; code segment descriptor
  ; base=0x0, limit=0xffff
  ; 1st flags: (present) 1 (privilege)00 (desc_type) 1 -> 1001b
  ; type flags: (code) 1 (conform)0 (readble)1 (64b seg)0 (avl)0 ->  1010b
  ; 2nd flags: (granularity)1 (32b def)1 (64b seg)0 (avl)0 -> 1100b
  dw 0xffff    ; limit
  dw 0x0       ; base (bits 0-16)
  db 0x0       ; base (bits 16-23)
  db 10011010b ; 1st flag, type flags
  db 11001111b ; 2nd flags, limit (bits 16-19)
  db 0x0       ; base (bits 24-31)

gdt_data:      ; data segment descriptor
  ; same as code segment except for the type flags
  ; type flags: (code)0 (expand down)0 (writeable)1 (accessed)0 -> 0010b
  dw 0xffff    ; limit
  dw 0x0       ; base (bits 0-16)
  db 0x0       ; base (bits 16-23)
  db 10010010b ; 1st flag, type flags
  db 11001111b ; 2nd flags, limit (bits 16-19)
  db 0x0       ; base (bits 24-31)

gdt_end: ; reason for this label is so the assembler can calculate sizeof

; GDT descriptor 
gdt_descriptor:
  dw gdt_end - gdt_start - 1 ; sizeof gdt always - 1 the true size
  dd gdt_start               ; start address of our gdt

; constants for gdt segment descriptor offsets
; segment registers must have these in protected mode
; ex: when we set ds=0x10 in PM, the cpu knows we mean it to use the segment
;     described at offset 0x10 (16 bytes) in our GDT, which is the
;     data segment (0x0 -> NULL; 0x08 -> code; 0x10 -> data;)
CODE_SEG equ gdt_code - gdt_start
DATA_SEG equ gdt_data - gdt_start

