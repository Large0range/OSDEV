/* This code will be placed at the beginning of the object by the linker script */    
__asm__ (".pushsection .text.start\r\n" \
		         "jmp main\r\n" \
			          ".popsection\r\n"
				           );

/* Place main as the first function defined in kernel.c so
 *  * that it will be at the entry point where our bootloader
 *   * will call. In our case it will be at 0x9000 */

int main(){
	    /* Do Stuff Here*/

	char *video_memory = (char *)0xb8000;
	*video_memory = 'c';

	    return 0; /* return back to bootloader */
}
