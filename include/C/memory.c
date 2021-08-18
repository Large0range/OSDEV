#include <memory.h>
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
