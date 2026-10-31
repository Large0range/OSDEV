; first entry is always null
gdt_nulldesc:
	dd 0
	dd 0

; second entry for code segment
gdt_codedesc:
    ; limit
	dw 0xFFFF
	; base
	dw 0x0000
	; base 2
	db 0x00
	; access byte
	; bits in order define this is:
	; present, 2-kernel privledge, code/data seg, code seg, executable form kernel, read access allowed, accessed bit(should be 1 but its cool)
	db 10011010b
	; flags and limit
	; first 4 flags:
	; limit is 4 KiB blocks, 32 bit segment, not long mode segment, reserved
	db 11001111b
	; base 3
	db 0x00

gdt_datadesc:
    ; limit
	dw 0xFFFF
	; base
	dw 0x0000
	; base 2
	db 0x00
	; access byte
	; bytes in order define this is:
	; present, 2-kernel privledge, code/data seg, data seg, grows up, writable, accessed bit
	db 10010010b
	; flags and limit
	; first 4 flags
	; limit is 4 kib blocks, 32 bit segment, not long mode supported, reserved
	db 11001111b
	; base 3
	db 0x00

gdt_end:

gdt_descriptor:
	gdt_size:
		dw gdt_end - gdt_nulldesc - 1
		dd gdt_nulldesc

codeseg equ gdt_codedesc - gdt_nulldesc
dataseg equ gdt_datadesc - gdt_nulldesc
