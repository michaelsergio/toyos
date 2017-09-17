; Function that prints a string
; args: bx address of null-terminated string to print.
;      

print_string:
  pusha          ; Pushes all registers onto stack
  mov ah, 0x0e   ; int=10/ah=0xoe -> BIOS tty support

  endofstringcheck:
    mov al, [bx]      ; Move first character of my_string into al
    cmp al, 0         ; Check for null-term
    jz endofstring    ; if its zero we are done

  putchar:
    int 0x10             ; print char
    add bx, 1            ; increment to next characters address
    jmp endofstringcheck ; Check if at end

  endofstring:
  popa           ; restores original registers values
  ret

puts:
  call print_string
  push ax
  mov ah, 0x0e   ; int=10/ah=0xoe -> BIOS tty support
  mov al, 13     ; add carrige return \r
  int 0x10       ; put char
  mov al, 10     ; add new line \n
  int 0x10       ; put char
  pop ax
  ret
