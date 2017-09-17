; Simple boot sector that prints a message with loops

mov ah, 0x0e ; int 10/ah = 0eh -> scrolling tty BIOS routine

mov bp, 0x8000 ; Set base of stack a litte above where BIOS
mov sp, bp     ; loads out boot sector. So it wont override us.

push 'A'       ; Characters are pushed on as 16-bit values so MSB will be 0x00
push 'B'
push 'C'

pop bx         ; we can only pop 16 bits
mov al, bl     ; then copy 8 bit bl to al
int 0x10       ; print al

pop bx         ; Again!
mov al, bl
int 0x10

mov al, [0x7ffe] ; To prove out stack grows downwards from bp
		 ; fetch the char at 0x8000 - 0x2 (16 bits)
int 0x10


forever:
  jmp $       ; Jump to the current address (forever)

; Padding and magic BIOS number
times 510-($-$$) db 0 ; Program should fit into 512 bytes
                      ; pad 0s (db 0) 510 times

dw 0xaa55	      ; Write last two bytes
		      ; This is a BIOS magic number for a boot sector
