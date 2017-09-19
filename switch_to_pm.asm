; Switch to protected mode
[bits 16]


switch_to_pm:
  cli                 ; we must switch off interrupts until we have set up the
                      ; protected mode interrupt vector or hell breaks loose

  lgdt [gdt_descriptor]  ; Load out global descriptor table
                         ; which defines protected mode segments (code + data)
  
  mov eax, cr0           ; to switch to protected mode we need to set the 
  or eax, 0x1            ; the first bit of cr0, a control register
  mov cr0, eax

  jmp CODE_SEG:init_pm   ; Make a far jump (to the new segment) to our 32b code
                         ; This also forces the cpu to flush its cache of 
			 ; pre-fetched and real mode decoded instructions,
			 ; which can cause problems


  [bits 32]
  ; Initizalize the registers and the stack once in PM
  init_pm:

  mov ax, DATA_SEG     ; Now in PM, our old segments are meaningless
  mov ds, ax           ; so we point all the segment registers to the 
  mov ss, ax           ; data selector we defined in GDT
  mov es, ax
  mov fs, ax
  mov gs, ax

  mov ebp, 0x90000     ; Update our stack position so it is right at the top
  mov esp, ebp         ; of the free space

  call BEGIN_PM        ; Finally, call some well known label

