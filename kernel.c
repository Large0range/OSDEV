#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>
#include <terminal.h>

/* Check if the compiler thinks you are targeting the wrong operating system. */
#if defined(__linux__)
#error "You are not using a cross-compiler, you will most certainly run into trouble"
#endif

/* This tutorial will only work for the 32-bit ix86 targets. */
#if !defined(__i386__)
#error "This tutorial needs to be compiled with a ix86-elf compiler"
#endif

typedef struct SMAP_entry {

	uint32_t BaseL; // base address uint64_t
	uint32_t BaseH;
	uint32_t LengthL; // length uint64_t
	uint32_t LengthH;
	uint32_t Type; // entry Type
	uint32_t ACPI; // extended

}__attribute__((packed)) SMAP_entry_t;

// load memory map to buffer - note: regparm(3) avoids stack issues with gcc in real mode
int __attribute__((noinline)) __attribute__((regparm(3))) detectMemory(SMAP_entry_t* buffer, int maxentries)
{
	uint32_t contID = 0;
	int entries = 0, signature, bytes;
	do
	{
		__asm__ __volatile__ ("int  $0x15"
				: "=a"(signature), "=c"(bytes), "=b"(contID)
				: "a"(0xE820), "b"(contID), "c"(24), "d"(0x534D4150), "D"(buffer));
		if (signature != 0x534D4150)
			return -1; // error
		if (bytes > 20 && (buffer->ACPI & 0x0001) == 0)
		{
			// ignore this entry
		}
		else {
			buffer++;
			entries++;
		}
	}
	while (contID != 0 && entries < maxentries);
	return entries;
}


void kernel_main(void) {
	terminal_initialize();

	terminal_writestring("Initialized Kernel...\n");

	terminal_writestring("Detecting Memory...");
	/*SMAP_entry_t* smap = (SMAP_entry_t*) 0x1000;
	const int smap_size = 0x2000;

	int entry_count = detectMemory(smap, smap_size / sizeof(SMAP_entry_t));

	if (entry_count == -1) {
		terminal_writestring("Error Finding Memory");
	} else {

	}*/
}
