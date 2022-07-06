#ifndef MEMORY_H
#define MEMORY_H

#include <stddef.h>
#include <stdint.h>

typedef struct {
	uint64_t baseAddress;
	uint64_t regionLength;
	uint32_t regionType;
	uint32_t extendedAttributes;
} mapEntry;

mapEntry *mapEntries[10];

unsigned char entryCount;

void memset(void *src, char set, size_t size);
void memcpy(void *dest, void *src, size_t size);

void printMapEntry(mapEntry *map);
mapEntry **getMapEntries();

#endif
