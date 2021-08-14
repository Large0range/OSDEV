.PHONY: build test clean

build: boot.bin ExtendedProgram.bin
	cat boot.bin ExtendedProgram.bin > os-image

boot.bin: boot.asm print.asm DiskRead.asm
	nasm -f bin boot.asm -o boot.bin

ExtendedProgram.bin: ExtendedProgram.o terminal.o
	i686-elf-ld -Ttext 0x7e00 --oformat binary ExtendedProgram.o terminal.o -o ExtendedProgram.bin

ExtendedProgram.o: ExtendedProgram.asm gdt.asm DiskRead.asm
	nasm -f elf32 ExtendedProgram.asm -o ExtendedProgram.o

terminal.o: terminal.c
	i686-elf-gcc -c terminal.c

clean:
	rm terminal.o
	rm boot.bin
	rm ExtendedProgram.bin
	rm ExtendedProgram.o
