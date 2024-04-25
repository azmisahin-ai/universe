%ifndef interrupts.asm
%define interrupts.asm
; @file src/os/kernel/interrupts.asm
; @description interrupts
; @author Azmi SAHIN
; --------------------------------------------------;--------------------------------------------------
BITS 16
org 0x1000

section .text

setup_interrupts:
    mov ah, 0x0E                                    ; Teletype yazma fonksiyonu için AH'ya 0x0E yükle

    mov al, 'I'                                     ; interrupts
    int 0x10

%endif
