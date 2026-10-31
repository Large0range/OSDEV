//__asm__ (".pushsection .text.start\r\njmp main\r\n.popsection");

#include "include/headers/string.h"
#include <terminal.h>
#include <string.h>
#include <memory.h>
#include <stdint.h>

int main() {
	terminal_writestring("LOADED INTO 64 BIT KERNEL\n");
	//terminal_clear();

	terminal_writestring("GhostOS Loaded\n");

	getMapEntries();
	setupHeap();

	for (size_t i = 0; i < entryCount; i++) {
		mapEntry *map = mapEntries[i];
		printMapEntry(map);

		terminal_writestring("\n");

	}

	int *ptr = (int *)malloc(8);
	*ptr = 0x12345;

	int *ptr2 = (int *)malloc(8);
	*ptr2 = 0x2345;


	free(ptr);

	return 0;
}
