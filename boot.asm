[bits 16]

; available memory regions accessed later
MemoryRegionCount:
	db 0

; stack pointer setup
mov bp, 0x8000
mov sp, bp

; print "16 Bit Real Mode"
mov bx, boot
call print_string

; load kernel store it in es:0x9000
; dh is sectors to read - 20
mov bx, 0x9000
mov dh, 20
call load_kernel

; setup cursor
; 0x3f 0011 1111
;      slow blink, top scanline containing cursor
mov ah, 0x01
mov ch, 0x3F
int 0x10

; get system memory map
; set extra segment to 0
; store result in 0x5000
; set edx to smap
; clear ebx to start at map
mov ax, 0
mov es, ax
mov di, 0x5000
mov edx, 0x0534D4150
xor ebx, ebx

; here we repeat to get the map
repeat:
; reset eax to 0xe280 for memory map
; set buffer size to 24 bytes
mov eax, 0xe820
mov ecx, 24
int 0x15

; check if all done
; jump if so
cmp ebx, 0
je finish

; increment buffer by 24
; increment how many regions we found
; repeat if not done
add di, 24
inc byte [MemoryRegionCount]
jmp repeat

finish:

; this is for 32 bit protected mode

cli ;Disable interrupts
call enable_a20 ; enable the a20 line
lgdt [gdt_descriptor] ;Load gdt table

; set cr0 lower bit to 1
mov eax, cr0
or eax, 1
mov cr0, eax

jmp codeseg:init_pm

; halt if we could not jump to initialize protected mode
hlt

;includes
%include "gdt.asm"

;Functions
enable_a20:
	pusha

	; fast a20 gate
	in al, 0x92
	or al, 2
	out 0x92, al

	popa
	ret

load_kernel:
	pusha
	push dx

	; setup for reading from disk
	; ah - read from disk to memory
	; al - sectors to read
	; ch - low 8 of cylinder number
	; dh - head number 0
	; cl - sector number 2
	mov ah, 0x02
	mov al, dh
	mov ch, 0x00
	mov dh, 0x00
	mov cl, 0x02
	int 0x13
	; cf set on error

	jc disk_read_error

	; check if dh which passed sectors read is equal to amount of sectors read (al)
	pop dx
	cmp dh, al
	jne disk_read_error

	; if both of these checks are ok then our kernel was read properly
	popa
	ret

	; jump over and hang if there was an error reading the kernel
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
boot db "16 Bit Real Mode", 10, 0
read_error db "Could Not Read Disk", 10, 0

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
