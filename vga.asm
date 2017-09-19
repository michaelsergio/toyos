; Video memory is sequential
; char cell is two bytes in memory
; address of col 5 row 3
; 0xb8000 + 2 * (row * 80 + col)
[bits 32]

; Constants
VIDEO_MEMORY equ 0xb8000
WHITE_ON_BLACK equ 0x0f

; print a c-string pointed to by edx
print_string_pm:
  pusha
  mov edx, VIDEO_MEMORY   ; edx is start of v-mem

print_string_pm_loop:
  mov al, [ebx]           ; store the char at ebx in al
  mov ah, WHITE_ON_BLACK  ; store the attribute in ah

  cmp al, 0               ; if al== 0 (end of string)
  je print_string_pm_done ; goto done

  mov [edx], ax           ; store char and attr at current char cell
  add ebx, 1              ; inc ebx to next char
  add edx, 2              ; move to next char cell in v-mem

  jmp print_string_pm_loop ; loop to print next char

print_string_pm_done:
  popa
  ret
