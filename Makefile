all: nothing

nothing:

make-os:
	qemu-img create os.iso 256M

asm-boot-sector:
	nasm boot_sect.asm -f bin -o boot_sect.bin

clean:
	rm -f boot_sect boot_sect.asm

boot:
	qemu-system-i386 -drive format=raw,file=boot_sect
