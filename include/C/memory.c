#include <stddef.h>
#include <memory.h>

void memcpy(void *dest, void *origin, size_t length) {
  char *cdest = (char *)dest;
  char *corigin = (char *)origin;

  for (size_t i = 0; i < length; i++) {
    cdest[i] = corigin[i];
  }
}

void memset(void *ptr, char ascii, size_t length) {
  char *cptr = (char *)ptr;

  for (size_t i = 0; i < length; i++) {
    cptr[i] = ascii;
  }
}
