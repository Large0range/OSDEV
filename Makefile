.PHONY: clean variables

SOURCEDIR=include
SOURCE=$(wildcard $(SOURCEDIR)/C/*.c)
OBJECTS=$(patsubst $(SOURCEDIR)/C/%.c,$(SOURCEDIR)/Build/%.o,$(SOURCE))

disk.img: boot.bin kernel.bin
	dd if=/dev/zero of=disk.img bs=512 count=2880
	dd if=boot.bin of=disk.img bs=512 conv=notrunc
	dd if=kernel.bin of=disk.img bs=512 seek=1 conv=notrunc

boot.bin: boot.asm
	nasm -f elf32 -F dwarf boot.asm -o boot.o
	ld -m elf_i386 -Ttext 0x7c00 boot.o -o boot.elf
	objcopy -O binary boot.elf boot.bin
	rm boot.o
	rm boot.elf

kernel.bin: kernel.c linker.ld
	gcc -m32 -c -ffreestanding kernel.c -o kernel.o
	ld -m elf_i386 -Tlinker.ld kernel.o -o kernel.elf
	objcopy -O binary kernel.elf kernel.bin
	rm kernel.elf
	rm kernel.o

variables:
	echo $(SOURCEDIR)
	echo $(SOURCE)
	echo $(OBJECTS)

clean:
	rm *.bin
	rm disk.img
