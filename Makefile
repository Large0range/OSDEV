.PHONY: build test

INCLUDE_DIR=include
OBJS = $(wildcard $(INCLUDE_DIR)/Build/*.o)
SOURCE = $(wildcard $(INCLUDE_DIR)/C/*.c)

build: Ghost.bin

test:
	echo $(SOURCE)

Ghost.bin: kernel.o boot.o $(INCLUDE_DIR)/Build/memory.o linker.ld
	i686-elf-gcc -T linker.ld -o myos.bin -ffreestanding -O2 -nostdlib boot.o kernel.o $(OBJS) -lgcc

#kernel.o: kernel.c
#	i686-elf-gcc -c kernel.c -o kernel.o -I$(INCLUDE_DIR)headers -std=gnu99 -ffreestanding -O2 -Wall -Wextra

boot.o: boot.s
	i686-elf-as boot.s -o boot.o

.c.o:
	i686-elf-gcc -c $^ -o $@ -I$(INCLUDE_DIR)/headers -std=gnu99 -ffreestanding -O2 -Wall -Wextra
