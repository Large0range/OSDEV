.PHONY: clean run variables

SOURCEDIR=include
SOURCE=$(wildcard $(SOURCEDIR)/C/*.c)
OBJECTS=$(patsubst $(SOURCEDIR)/C/%.c,$(SOURCEDIR)/Build/%.o,$(SOURCE))

disk.img: boot.bin extend.bin
	dd if=/dev/zero of=disk.img bs=512 count=2880
	dd if=boot.bin of=disk.img bs=512 conv=notrunc
	dd if=extend.bin of=disk.img bs=512 seek=1 conv=notrunc
#	dd if=kernel.bin of=disk.img bs=512 seek=2 conv=notrunc

run: disk.img
	qemu-system-x86_64 -drive file=disk.img,format=raw

boot.bin: boot.asm
	nasm -f elf32 -F dwarf boot.asm -o boot.o
	ld -m elf_i386 -Ttext 0x7c00 boot.o -o boot.elf
	objcopy -O binary boot.elf boot.bin
	rm boot.o
	rm boot.elf

kernel.bin: kernel.o linker.ld $(OBJECTS)
	ld -m elf_i386 -Tlinker.ld kernel.o $(OBJECTS) -o kernel.elf
	objcopy -O binary kernel.elf kernel.bin
	rm kernel.elf
	rm kernel.o

kernel.o: kernel.c
	gcc -m32 -c -ffreestanding -I $(SOURCEDIR)/headers kernel.c -o kernel.o

$(SOURCEDIR)/Build/%.o: $(SOURCEDIR)/C/%.c $(SOURCEDIR)/headers/%.h
	gcc -m32 -c -ffreestanding -I $(SOURCEDIR)/headers $< -o $@

extend.bin: extend.asm kernel.o
	nasm -f elf32 -F dwarf extend.asm -o extend.o
	ld -m elf_i386 -Tlinker.ld extend.o kernel.o $(OBJECTS) -o extend.elf
	objcopy -O binary extend.elf extend.bin
	rm extend.o
	rm extend.elf

variables:
	echo $(SOURCEDIR)
	echo $(SOURCE)
	echo $(OBJECTS)

clean:
	rm *.bin
	rm disk.img
