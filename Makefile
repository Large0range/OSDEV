.PHONY: all clean run debug variables

SOURCEDIR  := include
SOURCE     := $(wildcard $(SOURCEDIR)/C/*.c)
OBJECTS    := $(patsubst $(SOURCEDIR)/C/%.c,$(SOURCEDIR)/Build/%.o,$(SOURCE))
KERNEL_OBJ := kernel.o

# boot.asm reads 20 sectors (`mov dh, 20`); keep these in sync
MAX_EXTEND_BYTES := 10240

# One set of flags for every C file.
# -MMD -MP writes .d files so changing a header rebuilds what includes it.
CFLAGS := -m64 -ffreestanding -fno-pic -fno-pie -fno-stack-protector \
          -mno-red-zone -mgeneral-regs-only -Wall -Wextra \
          -MMD -MP -I $(SOURCEDIR)/headers \
          -fcommon

all: disk.img

disk.img: boot.bin extend.bin
	dd if=/dev/zero of=$@ bs=512 count=2880
	dd if=boot.bin of=$@ bs=512 conv=notrunc
	dd if=extend.bin of=$@ bs=512 seek=1 conv=notrunc

# Stage 1: 16-bit boot sector (with a 32-bit tail), so this stays 32-bit.
boot.bin: boot.asm gdt.asm
	nasm -f elf32 boot.asm -o boot.o
	ld -m elf_i386 -Ttext 0x7c00 boot.o -o boot.elf
	objcopy -O binary boot.elf $@
	rm -f boot.o boot.elf

# Stage 2: extend.asm + all the 64-bit C objects, linked at 0x9000.
extend.bin: extend.asm idt.asm gdt.asm linker.ld $(KERNEL_OBJ) $(OBJECTS)
	nasm -f elf64 extend.asm -o extend.o
	ld -m elf_x86_64 -T linker.ld extend.o $(KERNEL_OBJ) $(OBJECTS) -o extend.elf
	objcopy -O binary extend.elf $@
	rm -f extend.o extend.elf
	@test $$(stat -c %s $@) -le $(MAX_EXTEND_BYTES) || \
		{ echo "error: $@ is larger than 20 sectors, boot.asm won't load all of it"; exit 1; }

$(KERNEL_OBJ): kernel.c
	gcc $(CFLAGS) -c $< -o $@

$(SOURCEDIR)/Build/%.o: $(SOURCEDIR)/C/%.c
	@mkdir -p $(dir $@)
	gcc $(CFLAGS) -c $< -o $@

-include kernel.d $(OBJECTS:.o=.d)

run: disk.img
	qemu-system-x86_64 -drive file=disk.img,format=raw

# Exit on triple fault instead of rebooting, and log interrupts/exceptions to stderr.
debug: disk.img
	qemu-system-x86_64 -drive file=disk.img,format=raw -no-reboot -no-shutdown -d int,cpu_reset -monitor stdio

variables:
	@echo SOURCEDIR=$(SOURCEDIR)
	@echo SOURCE=$(SOURCE)
	@echo OBJECTS=$(OBJECTS)

clean:
	rm -f *.bin *.o *.elf *.d disk.img $(SOURCEDIR)/Build/*.o $(SOURCEDIR)/Build/*.d
