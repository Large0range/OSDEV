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
	totalCount = *((unsigned char *)(0x7c00));	

	size_t index = 0;

	for (char i = 0; i < totalCount; i++) {
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
	heapMemory = (uint8_t *)(mapEntries[0]->baseAddress);
	heapSize = mapEntries[0]->regionLength;
	heapBlockSize = 128; 
	heapIndex = 0;
}

void *malloc(size_t size) {
	*((char *)(heapMemory + heapIndex * heapBlockSize + 0)) = 'H'; //write HEADER dictates it's being used
	*((char *)(heapMemory + heapIndex * heapBlockSize + 1)) = 'E';
	*((char *)(heapMemory + heapIndex * heapBlockSize + 2)) = 'A';
	*((char *)(heapMemory + heapIndex * heapBlockSize + 3)) = 'D';
	*((char *)(heapMemory + heapIndex * heapBlockSize + 4)) = 'E';
	*((char *)(heapMemory + heapIndex * heapBlockSize + 5)) = 'R';
	*((uint16_t *)(heapMemory + heapIndex * heapBlockSize + 6)) = heapIndex;

	uint8_t *ptr = (uint8_t *)(heapMemory + heapIndex * heapBlockSize+8);
	for (size_t i = 8; i < heapBlockSize; i++) {
		ptr[i] = 0;
	}

	heapIndex++;
	for (size_t i = heapIndex; i < 50; i++) {
		if (memcmp((void *)(heapMemory + i * heapBlockSize), "HEADER", 6) == 0) {
			heapIndex = i;
			break;
		}
	}

	return (void *)(ptr);
}

void free(void *ptr) {	
	char *locator = (char *)ptr;

	for (size_t i = 0; i < heapBlockSize; i++) {
		if (*locator == 'H') {
			if (memcmp(locator, "HEADER", 6) == 0) {
				break;
			}
		}
		locator--;
	}

	for (size_t i = 0; i < 6; i++) {
		*locator = 0;
		locator++;
	}

	heapIndex = *((uint16_t *)(locator));
}
