%ifndef data.asm
%define data.asm

; @file data.asm
; @description Veri tanımları dosyası
; @author Azmi SAHIN
; @version 0.0.0.1
; --------------------------------------------------;--------------------------------------------------

section .data
    msg_welcome db 'Microorganism', 0h  
    request db 'GET / HTTP/1.1', 0Dh, 0Ah, 'Host: 1.1.1.1:8080', 0Dh, 0Ah, 0Dh, 0Ah, 0h
    
; ==================================================;==================================================
%endif