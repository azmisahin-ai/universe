%ifndef main.asm
%define main.asm

; @file src/os/kernel/main.asm
; @description Responsible for managing resources.
; @author Azmi SAHIN
; --------------------------------------------------;--------------------------------------------------
BITS 16
org 0x1000

; Kontrol bayrağı tanımları
%define VERSION_EXECUTED   0
%define DRIVERS_EXECUTED   1
%define INTERRUPTS_EXECUTED 2
%define MEMORY_EXECUTED    3
%define NETWORK_EXECUTED   4
%define PROCESSES_EXECUTED 5

; Çekirdek modüllerini dahil et
%include "src/os/kernel/version.asm"
%include "src/os/kernel/drivers.asm"
%include "src/os/kernel/interrupts.asm"
%include "src/os/kernel/memory.asm"
%include "src/os/kernel/networking.asm"
%include "src/os/kernel/processes.asm"

; Çekirdeği otomatik olarak başlat
kernel_start:                                       ; Çekirdek başlangıç noktası

    ; Kontrol bayrakları
    %assign version_flag   VERSION_EXECUTED
    %assign drivers_flag   DRIVERS_EXECUTED
    %assign interrupts_flag INTERRUPTS_EXECUTED
    %assign memory_flag    MEMORY_EXECUTED
    %assign network_flag   NETWORK_EXECUTED
    %assign processes_flag PROCESSES_EXECUTED

    ; Sadece bir kere çalışacaksa işlemleri yürüt
    %if version_flag = 0
        ;call version_entry                          ; Versiyon bilgilerini ekrana yazdır
        %assign version_flag 1                      ; Versiyon işlemi tamamlandı
    %endif

    %if drivers_flag = 0
        call load_drivers                           ; Sürücüleri yükle
        %assign drivers_flag 1                      ; Sürücüler işlemi tamamlandı
    %endif

    %if interrupts_flag = 0
        call setup_interrupts                       ; Kesmeleri ayarla
        %assign interrupts_flag 1                   ; Kesmeler işlemi tamamlandı
    %endif

    %if memory_flag = 0
        call manage_memory                          ; Belleği yönet
        %assign memory_flag 1                       ; Bellek yönetimi işlemi tamamlandı
    %endif

    %if network_flag = 0
        call configure_networking                   ; Ağ bağlantısını yapılandır
        %assign network_flag 1                      ; Ağ yapılandırma işlemi tamamlandı
    %endif

    %if processes_flag = 0
        call initialize_processes                   ; İşlem yönetimini başlat
        %assign processes_flag 1                    ; İşlem yönetimi başlatma işlemi tamamlandı
    %endif

    ; Sonsuz döngüde beklemek için
infinite_loop:
    jmp infinite_loop                               ; Sonsuz döngü oluştur

%endif
