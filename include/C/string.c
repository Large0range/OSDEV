#include <memory.h>
#include <string.h>
#include <stddef.h>

size_t strlen(const char *str) {
	size_t len = 0;
	while (str[len]) len++;
	return len;
}

void toString(char *dest, size_t size, int source) {
	size_t integerSize = 0;
	int cSource = source;


	while (1) {
		cSource /= 10;
		integerSize++;
		if (cSource == 0) break;
	}

	for (size_t i = integerSize - 1; i >= 0; i--) {
		dest[i] = 48 + source % 10;
		source /= 10;
		if (source == 0) {
			break;
		}
	}
}

void reverseString(char *src, char *dest, size_t size) {
	char *csrc;
	memcpy(csrc, dest, strlen(src));

	for (size_t i = 0; i < strlen(src); i++) {
		dest[i] = csrc[strlen(src) - i - 1];
	}
}
