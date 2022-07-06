#include <memory.h>
#include <string.h>
#include <stddef.h>

size_t strlen(const char *str) {
	size_t len = 0;
	while (str[len]) len++;
	return len;
}

void hexToString(char *dest, int source) {
	size_t hexSize = 0;
	int cSource = source;

	dest[0] = '0';
	dest[1] = 'x';

	while (1) {
		cSource /= 16;
		hexSize++;
		if (cSource == 0) break;
	}

	for (size_t i = hexSize + 1; i >= 1; i--) {
		unsigned short rm = source % 16;
		if (rm < 10) 
			dest[i] = 48 + rm;
		else
			dest[i] = 87 + rm;
		source /= 16;
		if (source == 0) break;
	}

	dest[hexSize + 2] = 0;
}

void intToString(char *dest, int source) {
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
