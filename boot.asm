[bits 16]

mov bp, 0x8000
mov sp, bp

mov bx, boot
call print_string

mov bx, 0x9000
mov dh, 17
call load_kernel

cli ;Disable interrupts
call enable_a20 ; enable the a20 line
lgdt [gdt_descriptor] ;Load gdt table

mov eax, cr0
or eax, 1
mov cr0, eax

jmp codeseg:init_pm

hlt

;includes
%include "gdt.asm"

;Functions
enable_a20: 
	pusha

	in al, 0x92
	or al, 2
	out 0x92, al

	popa
	ret

load_kernel:
	pusha
	push dx

	mov ah, 0x02
	mov al, dh
	mov ch, 0x00
	mov dh, 0x00
	mov cl, 0x02
	int 0x13

	jc disk_read_error

	pop dx
	cmp dh, al
	jne disk_read_error

	popa
	ret

	disk_read_error:
	mov bx, read_error
	call print_string
	hlt

print_string:
	pusha

	mov ah, 0x0e
	.printLoop:
	mov al, [bx]
	int 0x10

	inc bx

	cmp al, 0
	jne .printLoop

	popa

	ret

;Variables
boot db "16 Bit Real Mode", 0
read_error db "Could Not Read Disk", 0

[bits 32]
;Runner
init_pm:
	mov ax, dataseg
	mov ds, ax
	mov ss, ax
	mov es, ax
	mov fs, ax
	mov gs, ax

	mov ebp, 0x90000
	mov esp, ebp

	call 0x9000

	jmp $

times 510-($-$$) db 0

dw 0xaa55
