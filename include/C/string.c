#include <stddef.h>
#include <memory.h>
#include <string.h>

size_t strlen(const char* str) {
	size_t len = 0;
	while (str[len])
		len++;
	return len;
}

void reverseString(char *ptr, size_t length) {
  char ca[length];

  for (size_t i = 0; i < length; i++) {
    ca[(length - 1) - i] = ptr[i];
  }

  memcpy(ptr, ca, length);
}

void toString(char *ptr, int length, int t) {
  char ca[length];

  for (int i = 0; i < length; i++) {
    ca[i] = (char) ((t % 10) + 48);
    t /= 10;
    if (t == 0) break;
  }

  reverseString(ca, strlen(ca));

  memcpy(ptr, ca, length);
}
