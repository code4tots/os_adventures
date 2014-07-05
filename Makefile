.PHONY: all run

all: boot_sect.bin

run: boot_sect.bin bochsrc
	bochs -q

boot_sect.bin: boot_sect.asm
	nasm boot_sect.asm -f bin -o boot_sect.bin
