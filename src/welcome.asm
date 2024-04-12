; welcome.asm

section .text
    global welcome

; Hoş geldiniz mesajını göster
welcome:
    mov     eax, msg_welcome
    call    sprintLF
    ret