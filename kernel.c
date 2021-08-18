__asm__ (".pushsection .text.start\r\njmp main\r\n.popsection");

#include <terminal.h>
#include <string.h>

int main() {
	terminal_initialize();

	terminal_writestring("BOOTED INTO 32 BIT PROTECTED MODE\n");
	terminal_writestring("GhostOS Loaded\n\n");
	
	int test = 123;
	char string[100];
	toString(string, 100, test);

	terminal_writestring(string);
	terminal_writestring("\n");

	char tester[100];
	reverseString(string, string, 100);
	terminal_writestring(string);
	terminal_writestring(" - Reversed");

	return 0;
}
