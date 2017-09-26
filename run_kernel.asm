; A boot sector that boots a C kernel in 32-bit protected mode
;
; compile c code into kernel.bin
; cat boot_sect.bin kernel.bin > os-image
; 
; load a floppya with the os-image 
; something like:
; qemu-system-x86_64 -fda os-image
;
[org 0x7c00]


KERNEL_OFFSET equ 0x201 ; This is a the memory offset which we will 
; KERNEL_OFFSET equ 0x1000 ; This is a the memory offset which we will 
                         ; load our kernel



mov [BOOT_DRIVE], dl     ; BIOS stores out boot drive in DL, remember it!

mov bp, 0x9000           ; setup the stack
mov sp, bp

mov bx, MSG_REAL_MODE
call puts

call load_kernel         ; load our kernel

call switch_to_pm

jmp $

%include "print_string.asm" ; puts
%include "vga.asm"
%include "switch_to_pm.asm"  ; switch_to_pm
%include "gdt.asm"
%include "disk_load.asm"

[bits 16]

; load_kernel
load_kernel:
  mov bx, MSG_LOAD_KERNEL
  call puts

  mov bx, KERNEL_OFFSET    ; setup params for disk load routine
  mov dh, 15               ; so we load the first 15 sectors (excluding the
  mov dl, [BOOT_DRIVE]     ; boot sector) from the boot disk (ie. our kernel 
  call disk_load           ; code) to address KERNEL_OFFSET

  mov bx, MSG_LOAD_SUCCESS
  call puts

  ret


[bits 32]
; This is where we arrive after switching
BEGIN_PM:
  mov ebx, MSG_PROT_MODE
  call print_string_pm     ; Announce we're in protected mode

  call KERNEL_OFFSET       ; Now jump to the address of our loaded kernel code

  jmp $                    ; Hang

; Global Variables
BOOT_DRIVE       db 0
MSG_REAL_MODE    db "Started in 16-bit Real mode", 0
MSG_PROT_MODE    db "Successfully landed in 32-bit protected mode", 0
MSG_LOAD_KERNEL  db "Loading kernel into memory", 0
MSG_LOAD_SUCCESS db "Kernel loaded successfully!", 0

; Bootsector padding
times 510-($-$$) db 0 
dw 0xaa55
