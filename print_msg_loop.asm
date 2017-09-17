; Simple boot sector that prints a message with loops

[org 0x7c00] ;This will set the origin of the program to be the boot sector

mov ah, 0x0e ; int 10/ah = 0eh -> scrolling tty BIOS routine

mov bx, my_string ; Move my_string address into bx

print_string:
  mov al, [bx]  ; Move first character of my_string into al
  cmp al, 0     ; Check for null-term
  jz forever    ; if its zero we are done
  
  mov al, [bx]  ; put char in register
  int 0x10      ; print it
  add bx, 1     ; move on to next register
  jmp print_string ; try again
  

forever:
  jmp $       ; Jump to the current address (forever)

my_string:
  db 'Booting OS', 0  ; Null-terminated string

; Padding and magic BIOS number
times 510-($-$$) db 0 ; Program should fit into 512 bytes
                      ; pad 0s (db 0) 510 times

dw 0xaa55	      ; Write last two bytes
		      ; This is a BIOS magic number for a boot sector
