#ifndef STRING_H
#define STRING_H

#include <stddef.h>

size_t strlen(const char *str);
void toString(char *dest, size_t size, int source);
void reverseString(char *src, char *dest, size_t size);
void concat(char *dest, char *src1, char *src2, size_t size); 

#endif 
