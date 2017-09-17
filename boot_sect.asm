; Simple Boot sector program that loops forever

loopforever:	      ; Loop forever label
  jmp loopforever     ; Goto 1

times 510-($-$$) db 0 ; Program should fit into 512 bytes
                      ; pad 0s (db 0) 510 times

dw 0xaa55	      ; Write last two bytes
		      ; This is a BIOS magic number for a boot sector
