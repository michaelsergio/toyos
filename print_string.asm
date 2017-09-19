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

newline:
  push ax
  mov ah, 0x0e   ; int=10/ah=0xoe -> BIOS tty support mov al, 13     
  mov al, 13     ; add carrige return \r
  int 0x10       ; put char
  mov al, 10     ; add new line \n
  int 0x10       ; put char
  pop ax
  ret

puts:
  call print_string
  call newline
  ret


; print a hex address
; bx has a hex address
putx:
  pusha
  mov cx, 0      ; stack counter

  get_nibble:
    mov ax, bx     ; working copy of hex addres
    and ax, 0x0f   ; Get right most nibble
    push ax        ; put nibble on stack and inc count
    inc cx          
    shr bx, 4      ; move to next nibble
    cmp bx, 0      ; if non zero, then repeat
  jnz get_nibble

  mov ah, 0x0e     ; int=10/ah=0xoe -> BIOS tty support mov al, 13     
  mov al, '0'      ; print 0x
  int 0x10         ; print char
  mov al, 'x'      ; move ascii char into register
  int 0x10         ; print char

  pop_stack:
    pop ax
    call convert_hex_to_ascii ; mutate ax into an ascii char

    mov bh, 0x0e   ; int=10/ah=0xoe -> BIOS tty support mov al, 13     
    mov bl, al     ; move ascii char into register
    mov ax, bx     ; move tmp register bx into ax
    int 0x10       ; print char
    
    dec cx
    cmp cx, 0
  jnz pop_stack

  call newline
  popa
  ret


; mutable arg ax
convert_hex_to_ascii
  cmp ax, 10     ; Check where on the ascii table we should look

  jl not_hex_char_range
  add ax, 7      ; Add a total of 55 ('A' at 65) 
                 ;(sub 10 to make it start at 0) (so 7 total)
  not_hex_char_range:
  add ax, 48     ; if its a number add 48 
  ret





