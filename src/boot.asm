BITS 16  ; 16-bit modda başlıyoruz

org 0x7C00  ; Kodun başlangıç adresini belirliyoruz

    xor ax, ax                  ;   ax  :   0
    mov ds, ax                  ;   ds  :   0

Main16:
    ; Ekrana çıktı basmak için gerekli fonksiyonları çağırıyoruz
    call PrintWelcomeMessage

    ; Sonsuz bir döngü oluşturarak boot loader'ı durduruyoruz
    jmp $

; Ekrana hoş geldiniz mesajını yazdıran fonksiyon
PrintWelcomeMessage:
    mov si, welcomeMessage  ; Yazdırılacak mesajın adresini SI'ye yükle
    call PrintString        ; Yazıyı ekrana yazdıran alt fonksiyonu çağır
    ret

; Yazıyı ekrana yazdıran alt fonksiyon
PrintString:
    lodsb           ; SI'den bir karakter yükle
    or al, al       ; AL'nin 0 olup olmadığını kontrol et
    jz done         ; Eğer AL 0 ise yazma işlemi bitmiştir

    mov ah, 0x0E    ; Teletype yazma işlemi için AH'yi 0x0E olarak ayarla
    int 0x10        ; BIOS'a karakter yazdırma çağrısı
    jmp PrintString ; Bir sonraki karakter için tekrarla

done:
    ret

welcomeMessage db 'Welcome Universe!', 0  ; Yazdırılacak hoş geldiniz mesajı

times 510-($-$$) db 0   ; Boot sektörü boyutunu 512 byte'a tamamla
dw 0xAA55               ; Boot sektörü imzası
