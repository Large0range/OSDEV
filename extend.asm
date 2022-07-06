[bits 32]

;extern commands
extern terminal_initialize
extern terminal_writestring
extern main

;clear screen
call terminal_initialize

;save edx
push edx

;info tag 1
push dword tag1
call terminal_writestring
pop dx

;info tag 2
push dword tag2
call terminal_writestring
pop dx

;restore edx
pop edx


;start jump to 64 bit real mode
;detect cpuid
call detectCPUID

push dword detected
call terminal_writestring
pop dx

call longModeAvailable

push dword longModeSupported
call terminal_writestring
pop dx

call setupPaging
call editGDT

push dword longModeJumping
call terminal_writestring
pop dx


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
	mov dword [edi], 0x30003
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
	wrsmr


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

LongMode:
	cli
	mov ax, dataseg
	mov ds, ax
	mov es, ax
	mov fs, ax
	mov gs, ax
	mov ss, ax

	push dword longModeSuccess
	call terminal_writestring
	pop dx
	
	call setupIDT
	lidt [idt_descriptor]

	sti

	push dword idtSetup
	call terminal_writestring
	pop dx

	push dword kernelBoot
	call terminal_writestring
	pop dx

	call main

	jmp $

times 5120-($-$$) db 0
