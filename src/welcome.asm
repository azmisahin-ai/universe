; @file welcome.asm
; @description Başlantma işlemlerini yürütür
; @author Azmi SAHIN
; @version 0.0.0.1
; --------------------------------------------------;--------------------------------------------------
section .text
    global welcome

; Hoş geldiniz mesajını göster
; @function welcome
; @description Hoşgeldin
; @param {string} text bir string değer
; @returns
; --------------------------------------------------;--------------------------------------------------
welcome:
    mov     eax, msg_welcome
    call    sprintLF
    ret