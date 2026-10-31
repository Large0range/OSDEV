#ifndef MEMORY_H
#define MEMORY_H

#define HEAP_ALIGN 32
#define ALIGN_UP(ptr, size) \
    ((void*)(((uintptr_t)(ptr) + ((size) - 1)) & ~((size) - 1)))
#define ALIGN_DOWN(ptr, size) \
    ((void*)(((uintptr_t)(ptr) & ~((size) - 1))))

#include <stddef.h>
#include <stdint.h>

typedef struct {
	uint64_t baseAddress;
	uint64_t regionLength;
	uint32_t regionType;
	uint32_t extendedAttributes;
} mapEntry;

typedef struct {
    uint64_t *nextEntry;
    uint64_t *lastEntry;
    uint8_t entrySize;
    uint8_t index;
} heapEntry;


mapEntry *allEntries[10];
mapEntry *mapEntries[10];

unsigned char totalCount;
unsigned char entryCount;

uint8_t *heapBase;
uint8_t *heapTop;
uint8_t *heapPointer;
uint64_t heapSize;

void *malloc(uint8_t size);
void free(void *ptr);

void memset(void *src, char set, size_t size);
void memcpy(void *dest, void *src, size_t size);
uint8_t memcmp(void *src1, void *src2, size_t size);

void setupHeap();
void printMapEntry(mapEntry *map);
mapEntry **getMapEntries();

#endif
