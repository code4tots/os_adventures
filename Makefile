C_SOURCES = $(wildcard *.c)
OBJECTS = $(C_SOURCES:.c=.o)

.PHONY: all run clean

all: os_image

run: all bochsrc
	bochs -q > /dev/null 2>&1

clean:
	rm -rf *.bin *.o *.dis

os_image: kernel.bin boot_sect.bin
	cat boot_sect.bin kernel.bin > os_image

boot_sect.bin: boot_sect.asm
	nasm boot_sect.asm -f bin -o boot_sect.bin

kernel.o: kernel.c
	gcc -m32 -ffreestanding -c kernel.c -o kernel.o

kernel.bin: kernel.o
	ld -o kernel.bin -Ttext 0x1000 kernel.o --oformat binary


