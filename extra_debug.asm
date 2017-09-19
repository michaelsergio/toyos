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


; Put unsigned int
; bx is a value to print
putui:
  pusha
    mov ax, bx
    mov cx, 0      ; set a stack counter
    
    get_rightmost_digit:
      mov dx, 0    ; 0 is first part of word
      mov bx, 10   ; operand is byte 10 (dx ax/10)
      idiv bx      ; 

      push dx      ; Put Modulus result onto stack
      inc cx       ; increase number of items on stack

      cmp ax, 0    ; if result not zero, repeat
      jnz get_rightmost_digit

      mov ah, 0x0e ; int=10/ah=0xoe -> BIOS tty support
      pop_stack_item:
	pop dx       ; Get modulus off stack
		     ; print digit
	add dx, 48   ; convert num to ascii val
	mov al, dl   ; put contents into register (only al matters)
	int 0x10     ; print char
	dec cx
	cmp cx, 0    ; if we havent pop'd everything, loop
	jnz pop_stack_item

  call newline
  popa
  ret



; Character should be in bl
putc: 
  push bx
  mov ah, 0x0e   ; int=10/ah=0xoe -> BIOS tty support mov al, 13     
  mov al, bl     ; char
  int 0x10       ; put char
  call newline
  pop bx
  ret

