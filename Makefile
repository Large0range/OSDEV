.PHONY: build test
.SUFFIX: .o .c .h

INCLUDE_DIR=include
SOURCE = $(wildcard $(INCLUDE_DIR)/C/*.c)
HEADERS = $(wildcard $(INCLUDE_DIR)/headers/*.h)
OBJS = $(subst include/C/,include/Build/,$(patsubst %.c,%.o, $(SOURCE)))

build: Ghost.bin

test:
	$(OBJS)

Ghost.bin: kernel.o boot.o $(OBJS) linker.ld
	i686-elf-gcc -T linker.ld -o Ghost.bin -ffreestanding -O2 -nostdlib boot.o kernel.o $(OBJS) -lgcc

boot.o: boot.asm
	nasm -f elf32 boot.asm -o boot.o

kernel.o: kernel.c
	i686-elf-gcc -c $^ -o $@ -I$(INCLUDE_DIR)/headers -std=gnu99 -ffreestanding -O2 -Wall -Wextra

$(INCLUDE_DIR)/Build/%.o: $(INCLUDE_DIR)/C/%.c $(INCLUDE_DIR)/headers/%.h
	i686-elf-gcc -c $< -o $@ -I$(INCLUDE_DIR)/headers -std=gnu99 -ffreestanding -O2 -Wall -Wextra

clean:
	rm *.o
