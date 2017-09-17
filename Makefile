all: nothing

nothing:

make-os:
	qemu-img create os.iso 256M

asm-boot-sector:
	nasm boot_sect.asm -f bin -o boot_sect.bin

clean:
	rm -f boot_sect boot_sect.bin

boot:
	qemu-system-i386 -drive format=raw,file=boot_sect.bin

show-boot-sect:
	od -t x1 -A n boot_sect.bin

asm-boot-sector-msg:
	nasm print_msg.asm -f bin -o boot_sect.bin

