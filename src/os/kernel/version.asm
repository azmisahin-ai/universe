; @file src/os/kernel/version.asm
; @description Version information for the kernel.
; @author Azmi SAHIN
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
    mov ah, 0x0E                                    ; Teletype yazma fonksiyonu için AH'ya 0x0E yükle

    mov al, '0' + MAJOR_VERSION                     ; Major version
    int 0x10
    mov al, '.'
    int 0x10

    mov al, '0' + MINOR_VERSION                     ; Minor version
    int 0x10
    mov al, '.'
    int 0x10

    mov al, '0' + PATCH_VERSION                     ; Patch version
    int 0x10
    mov al, '.'
    int 0x10

    mov al, '0' + BUILD_VERSION                     ; Build version
    int 0x10

    ; Programı sonlandır
    mov ah, 0x4C                                    ; Programı sonlandırma için AH'ya 0x4C yükle
    int 0x21                                        ; İnterrupt 0x21 (DOS işlevleri) çağrısı

infinite_loop:                                      ; Eğer 0x4C işlem kodu desteklenmiyorsa, sonsuz döngüye gir
    jmp infinite_loop                               ; Sonsuz döngü oluştur
    