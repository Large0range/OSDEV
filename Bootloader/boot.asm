[org 0x7C00]

;Store Boot Disk
mov [BOOT_DISK], dl

;Setup the stack
mov bp, 0x7c00
mov sp, bp

mov bx, bootString
call printString

call ReadDisk

jmp PROGRAM_SPACE

jmp $

%include "print.asm"
%include "DiskRead.asm"

bootString db "BOOTING", 0

times 510 - ($-$$) db 0

dw 0xaa55
