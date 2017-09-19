; Load DH sectors to ES:BX from drive DL
; DH num sectors
; DL drive number
; Returns ES:BX
disk_load:
  push dx ; Store dx to remember how many sectors were requested

  mov ah, 0x02    ; BIOS Read sector fn
  mov al, dh      ; num of sectors to read
  mov ch, 0x00    ; set cyliner 0
  mov dh, 0x00    ; set head 0
  mov cl, 0x02    ; Start read from second sector (after boot sector)
  int 0x13        ; bios interrupt

  jc disk_error   ; Carry flag set if error happened. Jump to err handler

  pop dx          ; Restore the num of sectors requested
  cmp dh, al      ; if AL (sectors read) != DH (sectors_expected)
  jne disk_error  ; Display error
  ret


disk_error:
  mov bx, DISK_ERROR_MSG
  call puts
  jmp $

; Variables
DISK_ERROR_MSG db "Disk read error!", 0
