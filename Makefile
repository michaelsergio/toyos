all: nothing
nothing:

make-os:
	qemu-img create os.iso 256M

asm-boot-sector:
	nasm boot_sect.asm -f bin -o boot_sect.bin

clean:
	rm -f boot_sect *.bin *.o os-image

boot:
	qemu-system-i386 -drive format=raw,file=boot_sect.bin

show-boot-sect:
	od -t x1 -A n boot_sect.bin

asm-boot-sector-msg:
	nasm print_msg.asm -f bin -o boot_sect.bin

asm-boot-sector-addressing:
	nasm addressing.asm -f bin -o boot_sect.bin

asm-boot-sector-loop-print:
	nasm print_msg_loop.asm -f bin -o boot_sect.bin

asm-stack-test:
	nasm stack_test.asm -f bin -o boot_sect.bin

asm-boot-sector-print-fun:
	nasm print_msg_fun.asm -f bin -o boot_sect.bin
	
asm-boot-sector-disk_seg:
	nasm disk_segment.asm -f bin -o boot_sect.bin

asm-boot-sector-disk-drive:
	nasm disk_drive.asm -f bin -o boot_sect.bin

asm-boot-sector-protected-mode:
	nasm protected_mode.asm -f bin -o boot_sect.bin

c-simple-build:
	gcc -ffreestanding -c basic.c -o basic.o

c-kernel-basic:
	gcc -ffreestanding -c kernel.c -o kernel.o

asm-boot-sector-kernel-build:
	nasm run_kernel.asm -f bin -o boot_sect.bin

kernel-boot: combine-c-code
	qemu-system-i386 -fda os-image -drive format=raw,file=os-image

compiled-c-kernel: c-kernel-basic
	ld kernel.o -o kernel.bin -segaddr __TEXT 0x1000 -r -U start


combine-c-code: asm-boot-sector-kernel-build compiled-c-kernel
	cat boot_sect.bin kernel.bin > os-image

#  Buld with -g for symbols
#  Need to connect with gdb to 'target remote localhost:1234'
debug:
	qemu-system-i386 -s -S -drive format=raw,file=boot_sect.bin
