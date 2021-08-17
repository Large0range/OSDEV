ENTRY(main)

SECTIONS {
	. = 0x9000;
	.text : { *(.text.start) *(.text) }
	.data : { *(.data) }
	.bss : { *(.bss) *(COMMON) }
}
