%ifndef socket.asm
%define socket.asm

; @file socket.asm
; @description Programlar arası iletişim sağlar
; @author Azmi SAHIN
; @version 0.0.0.1
; --------------------------------------------------;--------------------------------------------------
%define IPPROTO_TCP         6                       ; TCP protokol numarası
%define SOCK_STREAM         1                       ; Stream soket türü
%define PF_INET             2                       ; IPv4 protokol ailesi

%define SYS_SOCKET          1                       ; Soket oluşturma sistem çağrısı
%define SYS_SOCKETCALL      102                     ; Soket işlemleri için genel sistem çağrısı

%define IP_ADDRESS          0x00000000              ; IP adresi olarak 0.0.0.0
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
    response                db                      'HTTP/1.1 200 OK', 0Dh, 0Ah, 'Content-Type: text/html', 0Dh, 0Ah, 'Content-Length: 18', 0Dh, 0Ah, 0Dh, 0Ah, 'Hello Universe!', 0Dh, 0Ah, 0h
    response_len            equ                     $ - response  ; dizinin uzunluğunu hesapla
    msg_listening           db                      '0.0.0.0:9001 üzerinde dinleniyor.', 0h
    
section .bss
    buffer                  resb                    255; İstek başlıklarını saklamak için bellek alanı

section .text
    global create_listener

; @module listen
; @description Bağlantı sağlayacak istekleri dinler
; @author Azmi SAHIN
; @version 0.0.0.1
; --------------------------------------------------;--------------------------------------------------
    mov     eax, msg_listening                      ; Yazılacak mesaj
    call    sprintLF 

create_listener:
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
    push    dword IP_ADDRESS                        ; Stack'e IP_ADDRESS'yi yerleştir (0.0.0.0)
    push    word PORT_VALUE                         ; Stack'e PORT_VALUE'yi yerleştir (9001, ters bayt sırasıyla)
    push    word AF_INET                            ; Stack'e 2'yi AF_INET olarak yerleştir
    mov     ecx, esp                                ; Argümanların adresini ecx'e taşı
    push    byte 16                                 ; Stack'e 16'yı yerleştir (argümanların uzunluğu)
    push    ecx                                     ; Argümanların adresini stack'e yerleştir
    push    edi                                     ; Dosya tanımlayıcısını stack'e yerleştir
    mov     ecx, esp                                ; Argümanların adresini ecx'e taşı
    mov     ebx, BIND                               ; BIND (2) sistem çağrısını çağır
    mov     eax, SYS_SOCKETCALL                     ; SYS_SOCKETCALL (kernel opcode 102) sistem çağrısını çağır
    int     80h                                     ; Kernel'i çağır                              ; Dinleme mesajını yazdır

.listen:
    push    byte SOMAXCONN                          ; Stack'e SOMAXCONN'u yerleştir (maksimum kuyruk uzunluğu argümanı)
    push    edi                                     ; Dosya tanımlayıcısını stack'e yerleştir
    mov     ecx, esp                                ; Argümanların adresini ecx'e taşı
    mov     ebx, SYS_LISTEN                         ; LISTEN (4) sistem çağrısını çağır
    mov     eax, SYS_SOCKETCALL                     ; SYS_SOCKETCALL (kernel opcode 102) sistem çağrısını çağır
    int     80h                                     ; Kernel'i çağır
    

.accept:
    push    byte 0                                  ; Stack'e 0'ı adres uzunluğu argümanı olarak yerleştir
    push    byte 0                                  ; Stack'e 0'ı adres argümanı olarak yerleştir
    push    edi                                     ; Dosya tanımlayıcısını stack'e yerleştir
    mov     ecx, esp                                ; Argümanların adresini ecx'e taşı
    mov     ebx, SYS_ACCEPT                         ; ACCEPT (5) sistem çağrısını çağır
    mov     eax, SYS_SOCKETCALL                     ; SYS_SOCKETCALL (kernel opcode 102) sistem çağrısını çağır
    int     80h                                     ; Kernel'i çağır

.fork:
    mov     esi, eax                                ; SYS_SOCKETCALL'dan dönen değeri esi'ye taşı (kabul edilen soketin dosya tanımlayıcısı veya hata durumunda -1)
    mov     eax, SYS_FORK                           ; FORK (2) sistem çağrısını çağır
    int     80h                                     ; Kernel'i çağır
    cmp     eax, 0                                  ; eax'teki SYS_FORK'un dönüş değeri 0 ise çocuk süreçteyiz
    jz      .read                                   ; Çocuk süreçte _read'e atlama
    jmp     .accept                                 ; Ebeveyn süreçte _accept'e atlama

.read:
    mov     edx, MAX_READ_BYTES                     ; Okunacak bayt sayısı (255 olarak tanımlıyoruz)
    mov     ecx, buffer                             ; Buffer değişkenimizin bellek adresini ecx'e taşı
    mov     ebx, esi                                ; esi'yi ebx'e taşı (kabul edilen soket dosya tanımlayıcısı)
    mov     eax, SYS_READ                           ; READ (3) sistem çağrısını çağır
    int     80h                                     ; Kernel'i çağır
    mov     eax, buffer                             ; Buffer değişkenimizin bellek adresini eax'e taşı, yazdırmak için
    call    sprintLF                                ; String yazdırma işlevini çağır

.write:
    mov     edx, response_len                       ; Yanıtın uzunluğu
    mov     ecx, response                           ; response değişkeninin bellek adresini ecx'e taşı
    mov     ebx, esi                                ; Dosya tanımlayıcısını ebx'e taşı (kabul edilen soket kimliği)
    mov     eax, SYS_WRITE                          ; WRITE (4) sistem çağrısını çağır
    int     80h                                     ; Kernel'i çağır

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