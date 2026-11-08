dumpRegisters:
    push rbx
    push rdi
    push rsi

    mov [regs+0*8], rax
    mov [regs+1*8], rbx
    mov [regs+2*8], rcx
    mov [regs+3*8], rdx
    mov [regs+4*8], rsi
    mov [regs+5*8], rdi
    mov [regs+6*8], rbp
    lea rax, [rsp+32]
    mov [regs+7*8], rax
    mov [regs+8*8], r8
    mov [regs+9*8], r9
    mov [regs+10*8], r10
    mov [regs+11*8], r11
    mov [regs+12*8], r12
    mov [regs+13*8], r13
    mov [regs+14*8], r14
    mov [regs+15*8], r15

    mov rbx, 0
    .loop:
    lea rdi, [regs_labels+rbx*4]
    call terminal_writestring

    mov rdi, reg_space
    mov rsi, [regs+rbx*8]
    call hexDump
    call terminal_writestring

    mov rdi, newline
    call terminal_writestring

    inc rbx
    cmp rbx, 16
    jb .loop

    pop rsi
    pop rdi
    pop rbx

    ret


hexDump:
    push rax
    push rdx
    push rdi
    push rcx

    mov rcx, 16
    mov rax, rsi


    add rdi, 18
    .dumploop:
    mov rdx, rax
    and rdx, 0xF
    shr rax, 4

    cmp dl, 10
    jae .ascii
    add dl, 48
    jmp .done
    .ascii:
    add dl, 87
    .done:

    mov [rdi], dl

    dec rdi
    dec rcx
    jnz .dumploop

    pop rcx
    pop rdi
    pop rdx
    pop rax

    ret


newline: db 10, 0
reg_space: db '=0x'
        times 17 db 0
regs: times 16 dq 0
regs_labels:
    db "rax", 0
    db "rbx", 0
    db "rcx", 0
    db "rdx", 0
    db "rsi", 0
    db "rdi", 0
    db "rbp", 0
    db "rsp", 0
    db "r08", 0
    db "r09", 0
    db "r10", 0
    db "r11", 0
    db "r12", 0
    db "r13", 0
    db "r14", 0
    db "r15", 0
