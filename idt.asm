[bits 64]

idt:
	times 256*16 db 0
idt_end:

idt_descriptor
	dw idt_end - idt - 1
	dq idt

zero:
	iretq

code: 
	iretq

label:
	dq 0

setupIDT:
	push rcx
	mov eax, 256
	mov ecx, 2
	mul ecx
	
	mov ecx, eax

	.setupLoop:
	dec rcx
	dec rcx

	mov rax, zero
	mov word [idt+rcx*8+0], ax
	mov word [idt+rcx*8+2], codeseg
	mov byte [idt+rcx*8+4], 0
	mov byte [idt+rcx*8+5], 10101110b
	shr rax, 16
	mov word [idt+rcx*8+6], ax
	shr rax, 16
	mov dword [idt+rcx*8+8], eax
	mov dword [idt+rcx*8+12], 0

	cmp rcx, 0
	jnz .setupLoop

	mov rax, code
	mov word [idt+1*8+0], ax
	mov word [idt+1*8+2], codeseg
	mov byte [idt+1*8+4], 0
	mov byte [idt+1*8+5], 10101110b
	shr rax, 16
	mov word [idt+rcx*8+6], ax
	shr rax, 16
	mov dword [idt+1*8+8], eax
	mov dword [idt+1*8+12], 0

	pop rcx
	ret



	
