; @file src/os/kernel/main.asm
; @description Responsible for managing resources.
; @author Azmi SAHIN
; --------------------------------------------------;--------------------------------------------------
BITS 16
org 0x1000

; Çekirdek modüllerini dahil et
%include "src/os/kernel/version.asm"
%include "src/os/kernel/drivers.asm"
%include "src/os/kernel/interrupts.asm"
%include "src/os/kernel/memory.asm"
%include "src/os/kernel/networking.asm"
%include "src/os/kernel/processes.asm"

; Çekirdek başlangıç noktası
global kernel_start
kernel_start:
    ; Versiyon bilgilerini ekrana yazdır
    call version_entry

    ; ; Sürücüleri yükle
    ; call load_drivers

    ; ; Kesmeleri ayarla
    ; call setup_interrupts

    ; ; Belleği yönet
    ; call manage_memory

    ; ; Ağ bağlantısını yapılandır
    ; call configure_networking

    ; ; İşlem yönetimini başlat
    ; call initialize_processes

    ; Sonsuz döngüde beklemek için
infinite_loop:
    jmp infinite_loop    ; Sonsuz döngü oluştur
