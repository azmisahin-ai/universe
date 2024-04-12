; @file logic.asm
; @description YMantıksal akışlar
; @author Azmi SAHIN
; @version 0.0.0.1
; --------------------------------------------------;--------------------------------------------------
section .text
    global _start

_start:                     ; Başla
    call welcome            ; Hoş geldiniz mesajını göster
    call listen             ; Gelen istekleri dinle    
    call quit               ; Programdan çık
