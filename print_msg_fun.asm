; A boot sector that prints a string using a function

[org 0x7c00] ; Tell the assembler where the code is loaded

mov bx, HELLO_MSG   ; Use bx as a param to out function
call puts

mov bx, GOODBYE_MSG ; 
call puts

jmp $               ; Hang


%include "print_string.asm"

; Data
HELLO_MSG:
  db 'Hello, World!', 0  ; null-terminated

GOODBYE_MSG:
  db 'Goodbye!', 0

; Padding and magic BIOS number
times 510-($-$$) db 0 ; Program should fit into 512 bytes
                      ; pad 0s (db 0) 510 times

dw 0xaa55	      ; Write last two bytes
		      ; This is a BIOS magic number for a boot sector
