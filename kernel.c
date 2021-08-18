__asm__ (".pushsection .text.start\r\njmp main\r\n.popsection");

#include <terminal.h>

int main() {
	terminal_initialize();

	terminal_writestring("Boobies");

	return 0;
}
