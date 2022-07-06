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

typedef struct {
	uint16_t index;
	uint8_t data[510];
} heapEntry;


mapEntry *allEntries[10];
mapEntry *mapEntries[10];

unsigned char totalCount;
unsigned char entryCount;

uint8_t *heapMemory;
uint8_t *heapPointer;
uint64_t heapSize;
uint32_t heapBlockSize;
uint16_t heapIndex;

void *malloc(size_t size);
void free(void *ptr);

void memset(void *src, char set, size_t size);
void memcpy(void *dest, void *src, size_t size);
uint8_t memcmp(void *src1, void *src2, size_t size);

void printMapEntry(mapEntry *map);
mapEntry **getMapEntries();

#endif
