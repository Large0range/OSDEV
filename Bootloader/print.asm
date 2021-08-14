printString:
  pusha
  mov ah, 0x0e
  pLoop:
  mov al, [bx]
  int 0x10

  inc bx
  cmp byte [bx], 0
  jne pLoop

  popa
  ret
