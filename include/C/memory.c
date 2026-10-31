#include <memory.h>
#include <stdint.h>
#include <terminal.h>
#include <stddef.h>
#include <string.h>

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

uint8_t memcmp(void *src1, void *src2, size_t size) {
	uint8_t *s1 = (uint8_t *)src1;
	uint8_t *s2 = (uint8_t *)src2;

	for (size_t i = 0; i < size; i++) {
		if (s1[i] != s2[i]) {
			return i;
		}
	}

	return 0;
}


void printMapEntry(mapEntry *map) {
	char dest[20];

	memset(dest, 0, 20);
	hexToString(dest, map->baseAddress);
	terminal_writestring("Base Address: ");
	terminal_writestring(dest);
	terminal_writestring("\n");

	memset(dest, 0, 20);
	intToString(dest, map->regionLength);
	terminal_writestring("Region Length (bytes): ");
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
	totalCount = *((unsigned char *)(0x7c00));

	size_t index = 0;

	for (size_t i = 0; i < totalCount; i++) {
		mapEntry *entry = (mapEntry *)(0x5000);
		entry += i;

		allEntries[i] = entry;

		if (entry->regionType == 1) {
			mapEntries[index] = entry;
			index++;
		}
	}

	entryCount = index;

	return mapEntries;
}

void setupHeap() {
	heapBase = (uint8_t *)(mapEntries[0]->baseAddress+HEAP_ALIGN);
	heapSize = mapEntries[0]->regionLength;
	heapTop = heapSize + heapBase;
	heapPointer = heapBase;
	*(heapEntry *)heapPointer = (heapEntry){NULL, NULL, 8, 0};
}

void *malloc(uint8_t size) {
    uint8_t index = 0;
    heapEntry *lastPointer;
    heapEntry *i = (heapEntry *)heapPointer;

    //heapwalk
    for (; i->nextEntry != NULL; i = (heapEntry *)i->nextEntry) {
        terminal_writestring("h");

    }

    index = i->index;
    lastPointer = i;

    //align to heap align at next block
    i = ALIGN_DOWN((void *)i+i->entrySize+sizeof(heapEntry)-1, HEAP_ALIGN)+HEAP_ALIGN;

    lastPointer->nextEntry = (uint64_t *)i;

    //create stamp
    *i = (heapEntry){NULL, (uint64_t *)lastPointer, size, index + 1};
    heapPointer = (uint8_t *)i;

    return (void *)i + sizeof(heapEntry);
}

void free(void *ptr) {
    heapEntry *entry = ALIGN_DOWN(ptr, HEAP_ALIGN);

    heapEntry *n = (heapEntry *)entry->nextEntry;
    heapEntry *l = (heapEntry *)entry->lastEntry;

    if (n != NULL) n->lastEntry = (uint64_t *)l;
    if (l != NULL) l->nextEntry = (uint64_t *)n;

   	char dest[20];
	hexToString(dest, (int)entry);
	terminal_writestring("\n");
	terminal_writestring(dest);
}

void writeHeapEntry(heapEntry entry, void *location) {
    heapEntry *p = (heapEntry *)location;
    *p = entry;

    char *ps = (char *)location + sizeof(heapEntry);
    ps[0] = 'h';
    ps[1] = 'e';
    ps[2] = 'a';
    ps[3] = 'd';
    ps[4] = 'e';
    ps[5] = 'r';
}
