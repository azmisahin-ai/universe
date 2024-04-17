%ifndef drivers.asm
%define drivers.asm

; @file src/os/kernel/drivers.asm
; @description drivers
; @author Azmi SAHIN
; --------------------------------------------------;--------------------------------------------------
BITS 16
org 0x1000

section .text

load_drivers:
    mov ah, 0x0E                                    ; Teletype yazma fonksiyonu için AH'ya 0x0E yükle

    mov al, 'D'                                     ; Drivers
    int 0x10

%endif
