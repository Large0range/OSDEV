//__asm__ (".pushsection .text.start\r\njmp main\r\n.popsection");

#include <terminal.h>
#include <string.h>
#include <memory.h>

int main() {
	terminal_writestring("LOADED INTO 64 BIT KERNEL");
	terminal_clear();
		
	terminal_writestring("GhostOS Loaded\n");

//	terminal_putchar(memoryCount + 48);
//	terminal_writestring(" Available Memory Sections\n");

	char dest[100];

	getMapEntries();

	for (char i = 0; i < entryCount-1; i++) {
		mapEntry *map = (mapEntry *)0x5000;
		map += i;

		printMapEntry(map);

		terminal_writestring("\n");
		
	}
	
	return 0;
}
