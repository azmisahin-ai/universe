%ifndef socket.asm
%define socket.asm

; @file socket.asm
; @description Uygulamalar arası iletişim sağlar
; @author Azmi SAHIN
; @version 0.0.0.1
; --------------------------------------------------;--------------------------------------------------
%define IPPROTO_TCP         6                       ; TCP protokol numarası
%define SOCK_STREAM         1                       ; Stream soket türü
%define PF_INET             2                       ; IPv4 protokol ailesi

%define SYS_SOCKET          1                       ; Soket oluşturma sistem çağrısı
%define SYS_SOCKETCALL      102                     ; Soket işlemleri için genel sistem çağrısı

%define SENSOR_IP_ADDRESS   0x00000000              ; SENSOR IP adresi olarak 0.0.0.0
%define SIGNAL_IP_ADDRESS   0x0100007F              ; SIGNAL IP adresi olarak 127.0.0.1
%define PORT_VALUE          0x2923                  ; Port değeri olarak 9001 (ters bayt sırasıyla)
%define AF_INET             2                       ; IPv4 adreslerini kullanır
%define BIND                2
%define CONNECT             3

%define SOMAXCONN           1                       ; Dinleme kuyruğunun maksimum uzunluğu 2147483647
%define SYS_LISTEN          4                       ; Soketi dinleme sistem çağrısı

%define SYS_ACCEPT          5                       ; Bağlantı kabul sistem çağrısı
%define SYS_FORK            2                       ; Yeni süreç oluşturma sistem çağrısı
%define MAX_READ_BYTES      255                     ; Okunacak maksimum bayt sayısı
%define SYS_READ            3                       ; Veri okuma sistem çağrısı
%define SYS_WRITE           4                       ; Veri yazma sistem çağrısı
%define SYS_CLOSE           6                       ; Dosya tanımlayıcısını kapatma sistem çağrısı
%define SYS_EXIT            1                       ; Süreci sonlandırma sistem çağrısı

; ==================================================;==================================================
%endif