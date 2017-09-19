; Read some dectors from the boot disk using disk_read fn
[org 0x7c00]

mov [BOOT_DRIVE], dl ; BIOS stores boot drive in dl, so store it 

mov bp, 0x8000       ; put our stack safely out of the way
mov sp, bp

mov bx, 0x9000       ; Load 5 sectors to 0x0000 (ES):0x9000(BX)
mov dh, 5            ; from the boot disk
mov dl, [BOOT_DRIVE] 
call disk_load       ; es:bx now set

mov bx, [0x9000]     ; print out first loaded word
call putx            ; we expect it to be 0xdada, store in 0x9000

mov bx, [0x9000 + 512] ; Also print first word from second sector
call putx              ; it should be face

jmp $


%include "print_string.asm" ; puts and putx
%include "disk_load.asm"    ; disk_load

; Global Variables
BOOT_DRIVE: db 0   ; 0 is floppy drive

; Bootsector padding
times 510-($-$$) db 0 ; Program should fit into 512 bytes
                      ; pad 0s (db 0) 510 times

dw 0xaa55	      ; Write last two bytes
		      ; This is a BIOS magic number for a boot sector

; We know BIOS will load only the first 512 byte from disk
; so if we add a few more sectors to our code, we can prove that
; we actually loaded those two sectors from the disk we booted from
; Sector 2
times 256 dw 0xdada
times 256 dw 0xface
; Sector 3-5
times 512 dw 0x0000
times 512 dw 0x0000
times 512 dw 0x0000
