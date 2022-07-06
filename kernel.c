//__asm__ (".pushsection .text.start\r\njmp main\r\n.popsection");

#include <terminal.h>
#include <string.h>
#include <memory.h>
#include <stdint.h>

int main() {
	terminal_writestring("LOADED INTO 64 BIT KERNEL");
	terminal_clear();
		
	terminal_writestring("GhostOS Loaded\n");

	getMapEntries();
	setupHeap();

	for (char i = 0; i < entryCount; i++) {
		mapEntry *map = mapEntries[i]; 
		printMapEntry(map);

		terminal_writestring("\n");
		
	}
	
	void *ptr = malloc(10);	

	free(ptr);

	return 0;
}
