[bits 32]

;save edx
push edx

;restore edx
pop edx


;start jump to 64 bit real mode
;detect cpuid
call detectCPUID

call longModeAvailable

call setupPaging
call editGDT


lgdt [gdt_descriptor]

mov eax, cr0
or eax, 1 << 31
mov cr0, eax

mov dword [0xb8000], 0x0f4b0f4f    ; "OK" in white on black

jmp codeseg:LongMode


jmp $

%include "gdt.asm"

editGDT:
	mov byte [gdt_codedesc + 6], 10101111b
	mov byte [gdt_datadesc + 6], 10101111b

	ret

detectCPUID:
	pushfd
	pop eax

	mov ecx, eax

	xor eax, 1 << 21

	push eax
	popfd

	pushfd
	pop eax

	push ecx
	popfd

	xor eax, ecx
	jz .none
	ret

	.none:
		jmp $


longModeAvailable:
	mov eax, 0x80000000
	cpuid
	cmp eax, 0x80000001
	jb .none

	mov eax, 0x80000001
	cpuid
	test edx, 1 << 29
	jz .none

	ret

	.none:
		jmp $

setupPaging:
	mov edi, 0x1000
	mov cr3, edi
	xor eax, eax
	mov ecx, 4096
	rep stosd
	mov edi, cr3

	mov dword [edi], 0x2003
	add edi, 0x1000
	mov dword [edi], 0x3003
	add edi, 0x1000
	mov dword [edi], 0x4003
	add edi, 0x1000

	mov ebx, 0x00000003
	mov ecx, 512

	.setEntry:
		mov dword [edi], ebx
		add ebx, 0x1000
		add edi, 8
		loop .setEntry


	mov eax, cr4
	or eax, 1 << 5
	mov cr4, eax

	mov ecx, 0xC0000080
	rdmsr
	or eax, 1 << 8
	wrmsr


	ret


tag1 db 'BOOTED EXTENDED PROGRAM', 10, 0
tag2 db '32 BIT PROTECTED MODE', 10, 0

detected db 'CPUID SUPPORTED', 10, 0

longModeSupported db 'LONG MODE SUPPORTED', 10, 0
longModeJumping db 'JUMPING TO LONG MODE', 10, 0
longModeSuccess db 'JUMP TO LONG MODE SUCCESS', 10, 0

idtSetup db 'IDT SETUP INTERRUPTS RENABLED', 10, 0

kernelBoot db 'LOADING GHOSTOS KERNEL', 10, 0

[bits 64]
%include "idt.asm"

;extern commands
extern main
extern terminal_initialize
extern terminal_writestring


LongMode:
	cli
	mov ax, dataseg
	mov ds, ax
	mov es, ax
	mov fs, ax
	mov gs, ax
	mov ss, ax


	call terminal_initialize

	mov rdi, longModeSuccess
	call terminal_writestring

	call setupIDT
	lidt [idt_descriptor]

	sti

	mov rdi, idtSetup
	call terminal_writestring

	mov rdi, kernelBoot
	call terminal_writestring

	call main

	jmp $

times 5120-($-$$) db 0
