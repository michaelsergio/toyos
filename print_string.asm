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


; Put unsigned int
; bx is a value to print
putui:
  pusha
  mov cx, 0  ; count for poping


  mov ax, bx  ; copy bx into ax
  put_int_on_stack:
    mov dx, 10
    div dx      ; do the divison  ax/dx = ax rem: dx
    push dx     ; put remainder onto stack
    add cx, 1   ; inc count
    cmp ax, 0  ; check that bx is > 0
    jg put_int_on_stack

  unwind_stack:
    pop bx       ; get last digit
    add bx, 48   ; convert num to ascii val
    mov ax, bx
    mov ah, 0x0e   ; int=10/ah=0xoe -> BIOS tty support
    int 0x10     ; print char
    sub cx, 1    ; dec counter
    cmp cx, 0    ; keep going if > 0
    jg unwind_stack

  call newline
  popa
  ret


; print_hex - prints a hex address
; dx: the address we want to print
print_hex:
  pusha

  mov bx, 5      ; bx holds the write position

  mov cx, dx     ; Keep the hex so we can shift it

  write_nibble_value:

  mov ax, cx     ; get a working copy of the hex
  and ax, 0x0f   ; Get rightmost nibble value
  cmp ax, 10     ; Check where on the ascii table we should look

  jl not_hex_char_range
  add ax, 7      ; Add a total of 55 ('A' at 65) 
                 ;(sub 10 to make it start at 0) (so 7 total)

  not_hex_char_range:
  add ax, 48     ; if its a number add 48 

  ; mov [HEX_OUT], byte ax  ; write to current position
  mov [HEX_OUT+bx], byte ax  ; write to current position

  push bx
  mov bx, HEX_OUT
  call puts
  pop bx

  shr cx, 1            ; Move to next nibble

  sub bx, 1            ; Decrement position
  cmp bx, 2            ; Continue only if >= 2
  jge write_nibble_value



  mov bx, HEX_OUT       ;; Write to HEX_OUT
  ; call puts

  popa
  ret

; Global variable hex buffer
HEX_OUT: db'0x0000', 0


; Put binary
; bx is a 16-bit value to print
putbin:
  pusha
  mov cx, 16  ; count for poping

  put_bit:
    mov ah, 0x0e    ; int=10/ah=0xoe -> BIOS tty support

    shl bx, 1       ; put bit into carry flag

    mov al, '1'     ; assume 1 is in carry flag
    jc carry_is_1   ; if carry flag is set dont set 0 
    mov al, '0'     ; if carry flag is not set, print 0
    carry_is_1:     ; else print 1
                   
    int 0x10        ; print char

    sub cx, 1       ; sub 1 from cx
    cmp cx, 0       ; check that bx is 0
    jnz put_bit


  call newline
  popa
  ret


