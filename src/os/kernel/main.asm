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

                                                    ; Çekirdeği otomatik başlar

kernel_start:                                       ; Çekirdek başlangıç noktası
    
    call version_entry                              ; Versiyon bilgilerini ekrana yazdır

    call load_drivers                               ; Sürücüleri yükle

    call setup_interrupts                           ; Kesmeleri ayarla

    call manage_memory                              ; Belleği yönet

    call configure_networking                       ; Ağ bağlantısını yapılandır

    call initialize_processes                       ; İşlem yönetimini başlat