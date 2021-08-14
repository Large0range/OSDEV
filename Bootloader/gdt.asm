gdt_nulldesc:
  dq 0x0

gdt_codedesc:
  dw 0xFFFF
  dw 0x0
  db 0x0
  db 10011010b
  db 11001111b
  db 0x0

gdt_datadesc:
  dw 0xFFFF
  dw 0x0
  db 0x0
  db 10010010b
  db 11001111b
  db 0x0

gdt_end:

gdt_descriptor:
  dw gdt_end - gdt_nulldesc - 1
  dd gdt_nulldesc

codeseg equ gdt_codedesc - gdt_nulldesc
dataseg equ gdt_datadesc - gdt_nulldesc
