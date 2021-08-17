__asm__ (".pushsection .text.start\r\njmp main\r\n.popsection");

int main() {
	
	char *video_memory = (char *)0xb8000;
	video_memory[0] = 'C';

	return 0;
}
