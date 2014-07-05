.PHONY: all run clean

run: boot_sect.bin bochsrc
	bochs -q > /dev/null 2>&1

all: boot_sect.bin

clean:
	rm -rf boot_sect.bin

boot_sect.bin: *.asm
	nasm boot_sect.asm -f bin -o boot_sect.bin
