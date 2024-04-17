; @file src/os/kernel/networking.asm
; @description networking
; @author Azmi SAHIN
; --------------------------------------------------;--------------------------------------------------
BITS 16
org 0x1000

section .text

configure_networking:
    mov ah, 0x0E                                    ; Teletype yazma fonksiyonu için AH'ya 0x0E yükle

    mov al, 'N'                                     ; networking
    int 0x10