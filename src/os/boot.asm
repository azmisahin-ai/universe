; boot.asm - Boot sector yükleme işlemleri

BITS 16         ; 16-bit modda başlıyoruz

org 0x7C00      ; Kodun başlangıç adresini belirliyoruz

xor ax, ax      ; AX'yi sıfırla
mov ds, ax      ; DS'yi sıfıra ayarla

Main16:
    call PrintMessage   ; Ekrana çıktı basmak için gerekli fonksiyonları çağır

disk_load:
    ; BIOS disk okuma fonksiyonu (INT 13h AH=42h)
        mov ah, 0x42        ; Disk okuma fonksiyon kodu
        mov bl, 0x00        ; Sürücü numarası (0: ilk sabit disk)
        mov cx, 0x0200      ; Hedef bellek adresi (0x07E0:0000)
        mov dx, 0x0000      ; LBA (Logical Block Addressing) başlangıç bloğu
        mov ax, 0x0001      ; Okunacak blok sayısı (1 sektör yeterlidir)
        int 0x13            ; BIOS disk okuma çağrısı

    jc disk_error       ; Hata durumunda disk_error işaretçisine git

; Okunan veriyi ekrana yazdırmak için
    mov si, 0x0       ; Okunan verinin başlangıç adresi
    mov cx, 1024         ; Okunacak byte sayısı (512 byte)
    call PrintMemory    ; Bellekteki veriyi yazdırmak için alt rutini çağır

    jmp 0x201     ; Kernel'in başlangıç adresine atla

disk_error:
    ; Hata durumunda ekrana bir mesaj yaz ve işlemi durdur
    mov si, diskErrorMessage
    call PrintString
    jmp $

PrintString:
    ; SI'den bir karakteri al ve ekrana yazdır
    lodsb               ; SI'den bir karakter yükle
    or al, al           ; AL'nin 0 olup olmadığını kontrol et
    jz done             ; Eğer AL 0 ise yazma işlemi bitmiştir

    mov ah, 0x0E        ; Teletype yazma işlemi için AH'yi 0x0E olarak ayarla
    int 0x10            ; BIOS'a karakter yazdırma çağrısı
    jmp PrintString     ; Bir sonraki karakter için tekrarla

PrintMessage:
    ; Ekrana boot mesajını yazdır
    mov si, bootMessage ; Yazdırılacak mesajın adresini SI'ye yükle
    call PrintString    ; Yazıyı ekrana yazdıran alt fonksiyonu çağır
    ret

PrintMemory:
    ; SI'den başlayarak CX kadar bellekten veri oku ve yazdır
    .print_loop:
        lodsb           ; SI'den bir byte yükle ve AL'ye yerleştir
        call PrintHexByte  ; AL'deki byte'ı hexadecimal olarak yazdır
        loop .print_loop    ; CX'de belirtilen sayı kadar tekrarla
    ret

PrintHexByte:
    ; AL'deki byte'ı hexadecimal olarak ekrana yazdır
    push ax
    push bx
    mov bx, ax          ; BX'e AL'i yedekle
    and al, 0x0F        ; AL'yi 0x0F ile AND'leyerek düşük dört biti al
    mov ah, 0x0E        ; AH'yi 0x0E olarak ayarla (teletype yazma işlemi için)
    add al, '0'         ; ASCII karakterine dönüştür
    cmp al, '9'         ; AL '9'dan küçük veya eşit mi?
    jbe .print_digit    ; Küçük veya eşitse, doğrudan yazdır
    add al, 7           ; 10'dan büyükse, 'A'-'9'=7 ekleyerek büyük harf yap
.print_digit:
    int 0x10            ; AH=0x0E ile teletype yazma işlemi (karakteri yazdır)
    pop bx
    pop ax
    ret

done:
    ret                 ; PrintString fonksiyonundan çıkış için geri dönüş

bootMessage db 'Booting...', 13, 10, 0    ; Yazdırılacak boot mesajı
diskErrorMessage db 'Disk read error!', 13, 10, 0   ; Disk okuma hatası mesajı

times 510-($-$$) db 0      ; Boot sektörü boyutunu 512 byte'a tamamla
dw 0xAA55                   ; Boot sektörü imzası
