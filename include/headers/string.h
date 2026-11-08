#ifndef STRING_H
#define STRING_H

#include <stddef.h>
#include <stdint.h>

size_t strlen(const char *str);
void intToString(char *dest, uint64_t source);
void hexToString(char *dest, uint64_t source);
void reverseString(char *src, char *dest, size_t size);
void concat(char *dest, char *src1, char *src2, size_t size);

#endif
