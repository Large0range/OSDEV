#ifndef MEMORY_H
#define MEMORY_H

#include <stddef.h>

void memcpy(void *dest, void *origin, size_t length);
void memset(void *ptr, char ascii, size_t length);

#endif
