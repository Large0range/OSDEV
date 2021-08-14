void _start(void) {
  char *ptr = (char *)0xb8000;
  *ptr = 'h';

  return;
}
