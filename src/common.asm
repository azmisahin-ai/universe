%ifndef common.asm
%define common.asm

; @file common.asm
; @description ortak moduller
; @author Azmi SAHIN
; @version 0.0.0.1
; --------------------------------------------------;--------------------------------------------------

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

; ==================================================;==================================================
%endif
