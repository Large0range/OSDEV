[bits 32]

;extern commands
extern terminal_initialize
extern main
extern terminal_writestring

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



jmp $


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

tag1 db 'BOOTED EXTENDED PROGRAM', 10, 0
tag2 db '32 BIT PROTECTED MODE', 10, 0

detected db 'CPUID SUPPORTED', 10, 0

longModeSupported db 'LONG MODE SUPPORTED', 10, 0
longModeJumping db 'JUMPING TO LONG MODE', 10, 0


times 512-($-$$) db 0
