#include <memory.h>
#include <terminal.h>
#include <stddef.h>

void memset(void *src, char set, size_t size) {
	char *csrc = src;

	for (size_t i = 0; i < size; i++) {
		csrc[i] = set;
	}
}

void memcpy(void *dest, void *src, size_t size) {
	char *cdest = dest;
	char *csrc = src;

	for (size_t i = 0; i < size; i++) {
		cdest[i] = csrc[i];
	}
}

void printMapEntry(mapEntry *map) {
	char dest[20];

	memset(dest, 0, 20);
	intToString(dest, map->baseAddress);
	terminal_writestring("Base Address: ");
	terminal_writestring(dest);
	terminal_writestring("\n");

	memset(dest, 0, 20);
	intToString(dest, map->regionLength);
	terminal_writestring("Region Length: ");
	terminal_writestring(dest);
	terminal_writestring("\n");

	memset(dest, 0, 20);
	intToString(dest, map->regionType);
	terminal_writestring("Region Type: ");
	terminal_writestring(dest);
	terminal_writestring("\n");

	memset(dest, 0, 20);
	intToString(dest, map->extendedAttributes);
	terminal_writestring("Extended Attributes: ");
	terminal_writestring(dest);
	terminal_writestring("\n");
}

mapEntry **getMapEntries() {
	entryCount = *((volatile unsigned char *)(0x7c00));	

	unsigned char index = 0;

	for (char i = 0; i < entryCount; i++) {
		mapEntry *entry = (mapEntry *)(0x5000);
		entry += i;

		if (entry->regionType == 1) {
			mapEntries[index] = entry;
			index++;
		}
	}

	return mapEntries;
}
