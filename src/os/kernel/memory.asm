%ifndef memory.asm
%define memory.asm

; @file src/os/kernel/memory.asm
; @description memory
; @author Azmi SAHIN
; --------------------------------------------------;--------------------------------------------------
BITS 16
org 0x1000

section .text

manage_memory:
    mov ah, 0x0E                                    ; Teletype yazma fonksiyonu için AH'ya 0x0E yükle

    mov al, 'M'                                     ; memory
    int 0x10

%endif
