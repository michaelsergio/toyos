; simple boot sector that shows segment offsets

mov ah, 0x0e    ; scrolling tty bios routine

mov al, [the_secret]
int 0x10              ; Will not print x. not in right segment

mov bx, 0x7c0         ; use bx to set ds
mov ds, bx            ; set data segment to 0x7c0
mov al, [the_secret]  
int 0x10              ; This prints X because offset is correct

mov al, [es:the_secret] ; tell cpu to use es as segment
int 0x10              ; fail to print X

mov bx, 0x7c0
mov es, bx
mov al, [es:the_secret] 
int 0x10              ; now it prints X


jmp $

the_secret:
  db "X"

; Padding and magic BIOS number
times 510-($-$$) db 0 ; Program should fit into 512 bytes
                      ; pad 0s (db 0) 510 times

dw 0xaa55	      ; Write last two bytes
		      ; This is a BIOS magic number for a boot sector
