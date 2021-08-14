;[org 0x7e00]

jmp EnterProtectedMode

jmp $

EnterProtectedMode:
  cli

  call EnableA20

  lgdt [gdt_descriptor]

  mov eax, cr0
  or eax, 1
  mov cr0, eax

  jmp codeseg:StartProtectedMode

EnableA20:

  mov ax, 0x2401
  int 0x15

  ret

%include "print.asm"
%include "gdt.asm"


[bits 32]
[extern _start]
StartProtectedMode:

  mov ax, dataseg
  mov ds, ax
  mov es, ax
  mov fs, ax
  mov gs, ax
  mov ss, ax

  mov ebp, 0x90000
  mov esp, ebp

  mov [0xb8000], byte 'h'

  ;call _start

  jmp $


times 2048-($-$$) db 0
