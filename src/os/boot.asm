; boot.asm - Boot sector yükleme işlemleri

BITS 16  ; 16-bit modda başlıyoruz

org 0x7C00  ; Kodun başlangıç adresini belirliyoruz

    xor ax, ax         ; AX'yi sıfırla
    mov ds, ax         ; DS'yi sıfıra ayarla

Main16:
    call PrintMessage  ; Ekrana çıktı basmak için gerekli fonksiyonları çağırıyoruz

disk:    
    ; Diskten kernel dosyasını yükleme işlemleri
    mov ah, 0x02       ; Disk okuma fonksiyonu
    mov al, 1          ; Okunacak sektör sayısı (kernel için 1 sektör yeterlidir)
    mov ch, 0          ; Silindir (başlangıç)
    mov cl, 2          ; Sector numarası (1. sektör)
    mov dh, 0          ; Başlangıç başlığı
    mov dl, 0x80       ; 0x80 - İlk sabit disk
    mov bx, 0x07E0     ; Yükleyeceğimiz bellek adresi: 0x07E0:0000
    int 0x13           ; Disk okuma çağrısı

    jc disk_error      ; Hata durumunda disk_error işaretçisine git

    jmp 0x07E0    ; Kernel'in başlangıç adresine atla

done:
    ret

PrintString: 
    lodsb           ; SI'den bir karakter yükle
    or al, al       ; AL'nin 0 olup olmadığını kontrol et
    jz done         ; Eğer AL 0 ise yazma işlemi bitmiştir

    mov ah, 0x0E    ; Teletype yazma işlemi için AH'yi 0x0E olarak ayarla
    int 0x10        ; BIOS'a karakter yazdırma çağrısı
    jmp PrintString ; Bir sonraki karakter için tekrarla

PrintMessage: 
    mov si, bootMessage  ; Yazdırılacak mesajın adresini SI'ye yükle
    call PrintString     ; Yazıyı ekrana yazdıran alt fonksiyonu çağır
    ret

disk_error:     
    ; Hata durumunda ekrana bir mesaj yaz ve işlemi durdur
    mov si, diskErrorMessage
    call PrintString
    jmp $ ;  durdur

bootMessage db 'Booting!', 0  ; Yazdırılacak mesajı
diskErrorMessage db 'Disk reading error!', 0

times 510-($-$$) db 0          ; Boot sektörü boyutunu 512 byte'a tamamla
dw 0xAA55                      ; Boot sektörü imzası
