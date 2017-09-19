; A boot sector that enters 32-bit protected mode.
[org 0x7c00]

mov bp, 0x9000           ; set the stack
mov sp, bp

mov bx, MSG_REAL_MODE
call puts

call switch_to_pm

jmp $

%include "print_string.asm" ; puts
%include "vga.asm"
%include "switch_to_pm.asm"  ; switch_to_pm
%include "gdt.asm"


[bits 32]
; This is where we arrive after switching
BEGIN_PM:
  mov ebx, MSG_PROT_MODE
  call print_string_pm

  jmp $

; Global Variables
MSG_REAL_MODE db "Started in 16-bit Real mode", 0
MSG_PROT_MODE db "Successfully landed in 32-bit protected mode", 0

; Bootsector padding
times 510-($-$$) db 0 
dw 0xaa55
