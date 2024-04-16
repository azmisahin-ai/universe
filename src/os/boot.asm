; boot.asm - Boot sector yükleme işlemleri

BITS 16         ; 16-bit modda başlıyoruz

org 0x7C00      ; Kodun başlangıç adresini belirliyoruz

xor ax, ax      ; AX'yi sıfırla
mov ds, ax      ; DS'yi sıfıra ayarla

Main16:
    call PrintMessage   ; Ekrana çıktı basmak için gerekli fonksiyonları çağır

disk:                   ; Diskten kernel dosyasını yükleme işlemleri
disk: ; Diskten kernel dosyasını yükleme işlemleri
    mov ah, 0x42 ; BIOS disk okuma fonksiyonu (INT 16)
    mov bl, 0x00 ; Sürücü numarası (0: ilk sabit disk)
    mov cx, 0x07E0 ; Hedef bellek adresi (0x07E0:0000)
    mov dx, 0x0000 ; LBA başlangıç bloğu
    mov ax, 0x0001 ; Okunacak blok sayısı (kernel için 1 sektör yeterlidir)
    int 0x13            ; BIOS disk okuma çağrısı
    jc disk_error       ; Hata durumunda disk_error işaretçisine git

    jmp 0x07E0          ; Kernel'in başlangıç adresine atla


disk_error:
    ; Hata durumunda ekrana bir mesaj yaz ve işlemi durdur
    mov si, diskErrorMessage
    call PrintString
    jmp $

done:
    ret
    
PrintString:
    lodsb               ; SI'den bir karakter yükle
    or al, al           ; AL'nin 0 olup olmadığını kontrol et
    jz done             ; Eğer AL 0 ise yazma işlemi bitmiştir

    mov ah, 0x0E        ; Teletype yazma işlemi için AH'yi 0x0E olarak ayarla
    int 0x10            ; BIOS'a karakter yazdırma çağrısı
    jmp PrintString     ; Bir sonraki karakter için tekrarla

PrintMessage:
    mov si, bootMessage ; Yazdırılacak mesajın adresini SI'ye yükle
    call PrintString    ; Yazıyı ekrana yazdıran alt fonksiyonu çağır
    ret

bootMessage db 'Booting...', 13, 10, 0    ; Yazdırılacak mesaj
diskErrorMessage db 'Disk read error!', 13, 10, 0

times 510-($-$$) db 0                     ; Boot sektörü boyutunu 512 byte'a tamamla
dw 0xAA55                                  ; Boot sektörü imzası
