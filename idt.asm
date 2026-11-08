[bits 64]

idt:
	times 256*16 db 0
idt_end:

idt_descriptor:
	dw idt_end - idt - 1
	dq idt

zero:
	iretq

code:
    mov rdi, codestring
    call terminal_writestring
	iretq

doublefault:
    pop rdi
    mov rdi, doublestring
    call terminal_writestring

    cli
    hlt

tss:
    pop rdi
    iretq

noseg:
    pop rdi
    iretq

stackfault:
    pop rdi
    iretq

genfault:
    pop rdi
    iretq

pagefault:
    pop rdi
    iretq

alignment:
    pop rdi
    iretq

control:
    pop rdi
    iretq


stackalignfault:
    and rsp, -16
    call genfaulthang

genfaulthang:
    pop rdi
    call dumpRegisters
    .faultloop:
    cli
    hlt
    jmp .faultloop

setupIDT:
	push rcx
	mov rcx, 16

	;first 7
	.setupLoop:
	dec rcx
	dec rcx

	mov rax, zero
	mov word [idt+rcx*8+0], ax
	mov word [idt+rcx*8+2], codeseg
	mov byte [idt+rcx*8+4], 0
	mov byte [idt+rcx*8+5], 10001111b
	shr rax, 16
	mov word [idt+rcx*8+6], ax
	shr rax, 16
	mov dword [idt+rcx*8+8], eax
	mov dword [idt+rcx*8+12], 0

	cmp rcx, 0
	jnz .setupLoop

	;last 234
	mov rcx, 512

	.setupLoop234:
	dec rcx
	dec rcx

	mov rax, genfaulthang
	mov word [idt+rcx*8+0], ax
	mov word [idt+rcx*8+2], codeseg
	mov byte [idt+rcx*8+4], 0
	mov byte [idt+rcx*8+5], 10001110b
	shr rax, 16
	mov word [idt+rcx*8+6], ax
	shr rax, 16
	mov dword [idt+rcx*8+8], eax
	mov dword [idt+rcx*8+12], 0

	cmp rcx, 64
	jne .setupLoop234

	; overwrite debug fault
	mov rax, code
	mov word [idt+1*16+0], ax
	mov word [idt+1*16+2], codeseg
	mov byte [idt+1*16+4], 0
	mov byte [idt+1*16+5], 10001111b
	shr rax, 16
	mov word [idt+1*16+6], ax
	shr rax, 16
	mov dword [idt+1*16+8], eax
	mov dword [idt+1*16+12], 0


	mov rax, doublefault
	mov word [idt+8*16+0], ax
	mov word [idt+8*16+2], codeseg
	mov byte [idt+8*16+4], 0
	mov byte [idt+8*16+5], 10001111b
	shr rax, 16
	mov word [idt+8*16+6], ax
	shr rax, 16
	mov dword [idt+8*16+8], eax
	mov dword [idt+8*16+12], 0

	;floating point fault
	mov rax, genfaulthang
	mov word [idt+9*16+0], ax
	mov word [idt+9*16+2], codeseg
	mov byte [idt+9*16+4], 0
	mov byte [idt+9*16+5], 10001111b
	shr rax, 16
	mov word [idt+9*16+6], ax
	shr rax, 16
	mov dword [idt+9*16+8], eax
	mov dword [idt+9*16+12], 0


	mov rax, tss
	mov word [idt+10*16+0], ax
	mov word [idt+10*16+2], codeseg
	mov byte [idt+10*16+4], 0
	mov byte [idt+10*16+5], 10001111b
	shr rax, 16
	mov word [idt+10*16+6], ax
	shr rax, 16
	mov dword [idt+10*16+8], eax
	mov dword [idt+10*16+12], 0


	mov rax, noseg
	mov word [idt+11*16+0], ax
	mov word [idt+11*16+2], codeseg
	mov byte [idt+11*16+4], 0
	mov byte [idt+11*16+5], 10001111b
	shr rax, 16
	mov word [idt+11*16+6], ax
	shr rax, 16
	mov dword [idt+11*16+8], eax
	mov dword [idt+11*16+12], 0


	mov rax, stackfault
	mov word [idt+12*16+0], ax
	mov word [idt+12*16+2], codeseg
	mov byte [idt+12*16+4], 0
	mov byte [idt+12*16+5], 10001111b
	shr rax, 16
	mov word [idt+12*16+6], ax
	shr rax, 16
	mov dword [idt+12*16+8], eax
	mov dword [idt+12*16+12], 0


	mov rax, genfault
	mov word [idt+13*16+0], ax
	mov word [idt+13*16+2], codeseg
	mov byte [idt+13*16+4], 0
	mov byte [idt+13*16+5], 10001111b
	shr rax, 16
	mov word [idt+13*16+6], ax
	shr rax, 16
	mov dword [idt+13*16+8], eax
	mov dword [idt+13*16+12], 0

	mov rax, pagefault
	mov word [idt+14*16+0], ax
	mov word [idt+14*16+2], codeseg
	mov byte [idt+14*16+4], 0
	mov byte [idt+14*16+5], 10001111b
	shr rax, 16
	mov word [idt+14*16+6], ax
	shr rax, 16
	mov dword [idt+14*16+8], eax
	mov dword [idt+14*16+12], 0

	; 15 intel reserved

	mov rax, genfaulthang
	mov word [idt+16*16+0], ax
	mov word [idt+16*16+2], codeseg
	mov byte [idt+16*16+4], 0
	mov byte [idt+16*16+5], 10001111b
	shr rax, 16
	mov word [idt+16*16+6], ax
	shr rax, 16
	mov dword [idt+16*16+8], eax
	mov dword [idt+16*16+12], 0

	mov rax, alignment
	mov word [idt+17*16+0], ax
	mov word [idt+17*16+2], codeseg
	mov byte [idt+17*16+4], 0
	mov byte [idt+17*16+5], 10001111b
	shr rax, 16
	mov word [idt+17*16+6], ax
	shr rax, 16
	mov dword [idt+17*16+8], eax
	mov dword [idt+17*16+12], 0

	mov rax, genfaulthang
	mov word [idt+18*16+0], ax
	mov word [idt+18*16+2], codeseg
	mov byte [idt+18*16+4], 0
	mov byte [idt+18*16+5], 10001111b
	shr rax, 16
	mov word [idt+18*16+6], ax
	shr rax, 16
	mov dword [idt+18*16+8], eax
	mov dword [idt+18*16+12], 0

	mov rax, genfaulthang
	mov word [idt+19*16+0], ax
	mov word [idt+19*16+2], codeseg
	mov byte [idt+19*16+4], 0
	mov byte [idt+19*16+5], 10001111b
	shr rax, 16
	mov word [idt+19*16+6], ax
	shr rax, 16
	mov dword [idt+19*16+8], eax
	mov dword [idt+19*16+12], 0

	mov rax, genfaulthang
	mov word [idt+20*16+0], ax
	mov word [idt+20*16+2], codeseg
	mov byte [idt+20*16+4], 0
	mov byte [idt+20*16+5], 10001111b
	shr rax, 16
	mov word [idt+20*16+6], ax
	shr rax, 16
	mov dword [idt+20*16+8], eax
	mov dword [idt+20*16+12], 0

	mov rax, stackalignfault
	mov word [idt+21*16+0], ax
	mov word [idt+21*16+2], codeseg
	mov byte [idt+21*16+4], 0
	mov byte [idt+21*16+5], 10001111b
	shr rax, 16
	mov word [idt+21*16+6], ax
	shr rax, 16
	mov dword [idt+21*16+8], eax
	mov dword [idt+21*16+12], 0

	pop rcx
	ret


codestring db 'debug', 10, 0
doublestring db 'doublefault', 10, 0
