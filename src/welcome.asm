; welcome.asm

welcome:
    mov     eax, msg_welcome
    call    sprintLF
    ret