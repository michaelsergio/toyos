; Simple boot sector program that shows addressing

; [org 0x7c00] This will set the origin of the program to be the boot sector

mov ah, 0x0e ; int 10/h = 0eh -> scrolling tty BIOS routine

; Trying to make it print 'X':

; First attempt
mov al, the_secret
int 0x10 

; Second attempt
mov al, [the_secret]
int 0x10

; Third attempt
mov bx, the_secret
add bx, 0x7c00
mov al, [bx]
int 0x10

; Fourth Attempt
mov al, [0x7c1e]
int 0x10

jmp $              ; Loop forever

the_secret:
  db "X"

; Padding and magic BIOS number
times 510-($-$$) db 0 ; Program should fit into 512 bytes
                      ; pad 0s (db 0) 510 times

dw 0xaa55	      ; Write last two bytes
		      ; This is a BIOS magic number for a boot sector
