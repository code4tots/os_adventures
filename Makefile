C_SOURCES = $(wildcard *.c)
OBJECTS = $(C_SOURCES:.c=.o)
DISASSEMBLIES = $(C_SOURCES:.c=.dis)

.PHONY: all run clean

all: boot_sect.bin $(DISASSEMBLIES)

run: boot_sect.bin bochsrc
	bochs -q > /dev/null 2>&1

clean:
	rm -rf *.bin *.o *.dis

boot_sect.bin: *.asm
	nasm boot_sect.asm -f bin -o boot_sect.bin

%.o: %.c
	gcc -ffreestanding -c $< -o $@

%.bin: %.o
	ld -o $@ -Ttext 0x0 --oformat binary $<

%.dis: %.bin
	ndisasm -b 32 $< > $@


