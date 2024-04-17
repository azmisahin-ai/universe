; @file src/os/kernel/version.asm
; @description Version information for the kernel.
; @author Azmi SAHIN
; @version 0.0.0.0
; --------------------------------------------------;--------------------------------------------------
BITS 16
org 0x1000

; Versiyon numarasını tanımlamak için değişkenler
%define MAJOR_VERSION 0
%define MINOR_VERSION 0
%define PATCH_VERSION 0
%define BUILD_VERSION 0

section .text
    ; Giriş noktası
    global version_entry
version_entry:
    mov ah, 0x0E    ; Teletype yazma fonksiyonu için AH'ya 0x0E yükle

    ; Major version
    mov al, '0' + MAJOR_VERSION
    int 0x10
    mov al, '.'
    int 0x10

    ; Minor version
    mov al, '0' + MINOR_VERSION
    int 0x10
    mov al, '.'
    int 0x10

    ; Patch version
    mov al, '0' + PATCH_VERSION
    int 0x10
    mov al, '.'
    int 0x10

    ; Build version
    mov al, '0' + BUILD_VERSION
    int 0x10

    ; Sonsuz döngüde beklemek için
    jmp $
