; @file src/os/kernel/version.asm
; @description version
; @author Azmi SAHIN
; @version 0.0.0.1
; --------------------------------------------------;--------------------------------------------------
BITS 16
org 0x1000

mov ah, 0x0E    ; Teletype yazma fonksiyonu
mov al, '0'
int 0x10

mov al, '.'
int 0x10

mov al, '0'
int 0x10

mov al, '.'
int 0x10

mov al, '0'
int 0x10

mov al, '.'
int 0x10

mov al, '1'
int 0x10