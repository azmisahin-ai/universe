; @file src/os/kernel/processes.asm
; @description processes
; @author Azmi SAHIN
; --------------------------------------------------;--------------------------------------------------
BITS 16
org 0x1000

section .text

initialize_processes:
    mov ah, 0x0E                                    ; Teletype yazma fonksiyonu için AH'ya 0x0E yükle

    mov al, 'P'                                     ; processes
    int 0x10