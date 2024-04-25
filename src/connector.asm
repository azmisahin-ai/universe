%ifndef connector.asm
%define connector.asm

; @file connector.asm
; @description Bağlayıcı
; @author Azmi SAHIN
; @version 0.0.0.1
; --------------------------------------------------;--------------------------------------------------
%define IPPROTO_TCP         6                       ; TCP protokol numarası
%define SOCK_STREAM         1                       ; Stream soket türü
%define PF_INET             2                       ; IPv4 protokol ailesi

%define SYS_SOCKET          1                       ; Soket oluşturma sistem çağrısı
%define SYS_SOCKETCALL      102                     ; Soket işlemleri için genel sistem çağrısı

%define IP_ADDRESS          0x0100007F              ; IP adresi olarak 127.0.0.1
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

section .data
    request                 db                      'GET / HTTP/1.1', 0Dh, 0Ah, 'Host: 127.0.0.1:9001', 0Dh, 0Ah, 0Dh, 0Ah, 0h
    request_len             equ                     $ - request  ; dizinin uzunluğunu hesapla
    msg_connection          db                      '127.0.0.1:9001 adresine baglaniyor.', 0h

section .bss
    buffer                  resb                    255; İstek başlıklarını saklamak için bellek alanı

section .text
    global create_connector

; @module connect
; @description Dinleyiciler ile bağlantı kurar
; @author Azmi SAHIN
; @version 0.0.0.1
; --------------------------------------------------;--------------------------------------------------
    mov     eax, msg_connection                     ; Yazılacak mesaj
    call    sprintLF  
    
create_connector:
    xor     eax, eax                                ; eax'ı sıfırla
    xor     ebx, ebx                                ; ebx'ı sıfırla
    xor     edi, edi                                ; edi'yi sıfırla
    xor     esi, esi                                ; esi'yi sıfırla
 
.socket:
    push    byte IPPROTO_TCP                        ; Stack'e IPPROTO_TCP'yi yerleştir (TCP protokol numarası)
    push    byte SOCK_STREAM                        ; Stack'e SOCK_STREAM'ü yerleştir (stream soket türü)
    push    byte PF_INET                            ; Stack'e PF_INET'i yerleştir (IPv4 protokol ailesi)
    mov     ecx, esp                                ; Argümanların adresini ecx'e taşı
    mov     ebx, SYS_SOCKET                         ; SOCKET (1) sistem çağrısını çağır
    mov     eax, SYS_SOCKETCALL                     ; SYS_SOCKETCALL (kernel opcode 102) sistem çağrısını çağır
    int     80h                                     ; Kernel'i çağır 

.bind:
    mov     edi, eax                                ; SYS_SOCKETCALL'dan dönen değeri edi'ye taşı (yeni soketin dosya tanımlayıcısı veya hata durumunda -1)
    push    dword IP_ADDRESS                        ; Stack'e IP_ADDRESS'yi yerleştir ; IP adresi olarak 127.0.0.1
    push    word PORT_VALUE                         ; Stack'e PORT_VALUE'yi yerleştir (9001, ters bayt sırasıyla)
    push    word AF_INET                            ; Stack'e 2'yi AF_INET olarak yerleştir
    mov     ecx, esp                                ; Argümanların adresini ecx'e taşı
    push    byte 16                                 ; Stack'e 16'yı yerleştir (argümanların uzunluğu)
    push    ecx                                     ; Argümanların adresini stack'e yerleştir
    push    edi                                     ; Dosya tanımlayıcısını stack'e yerleştir
    mov     ecx, esp                                ; Argümanların adresini ecx'e taşı
    mov     ebx, CONNECT                            ; CONNECT (3) sistem çağrısını çağır
    mov     eax, SYS_SOCKETCALL                     ; SYS_SOCKETCALL (kernel opcode 102) sistem çağrısını çağır
    int     80h                                     ; Kernel'i çağır

.write:
    mov     edx, request_len                        ; mesajin uzunluğu
    mov     ecx, request                            ; request değişkeninin bellek adresini ecx'e taşı
    mov     ebx, edi                                ; 
    mov     eax, SYS_WRITE                          ; WRITE (4) sistem çağrısını çağır
    int     80h                                     ; Kernel'i çağır
 
.read:
    mov     edx, MAX_READ_BYTES                     ; Okunacak bayt sayısı (255 olarak tanımlıyoruz)
    mov     ecx, buffer                             ; Buffer değişkenimizin bellek adresini ecx'e taşı
    mov     ebx, edi                                ; 
    mov     eax, SYS_READ                           ; READ (3) sistem çağrısını çağır
    int     80h                                     ; Kernel'i çağır
 
    cmp     eax, 0                                  ; 
    jz      .close                                  ; 
 
    mov     eax, buffer                             ; Buffer değişkenimizin bellek adresini eax'e taşı, yazdırmak için
    call    sprint                                  ; String yazdırma işlevini çağır
    jmp     .read                                   ; 
 
.close:
    mov     ebx, esi                                ; esi'yi ebx'e taşı (kabul edilen soket dosya tanımlayıcısı)
    mov     eax, SYS_CLOSE                          ; CLOSE (6) sistem çağrısını çağır
    int     80h                                     ; Kernel'i çağır     
 
.exit:
    ; Çıkış yap
    mov     eax, SYS_EXIT                           ; EXIT (1) sistem çağrısını çağır
    xor     ebx, ebx                                ; Çıkış durumu
    int     80h                                     ; Linux kernel kesmesi

; ==================================================;==================================================
%endif

%include 'src/helpers.asm'