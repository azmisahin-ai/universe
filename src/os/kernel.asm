; kernel.asm - İşletim sistemi kernel'i

BITS 16  ; 16-bit modda başlıyoruz

org 0x7E00  ; Kernel'in bellek adresi

Start:
    mov ax, 0x07C0   ; DS'yi başlangıç adresiyle ayarla
    mov ds, ax


    mov si, helloMessage  ; Yazdırılacak mesajın adresini SI'ye yükle
    call PrintString       ; Yazıyı ekrana yazdıran fonksiyonu çağır

    
    jmp $ ; Sonsuz döngü

PrintString:
    lodsb           ; SI'den bir karakter yükle
    or al, al       ; AL'nin 0 olup olmadığını kontrol et
    jz done         ; Eğer AL 0 ise yazma işlemi bitmiştir

    mov ah, 0x0E    ; Teletype yazma işlemi için AH'yi 0x0E olarak ayarla
    int 0x10        ; BIOS'a karakter yazdırma çağrısı
    jmp PrintString ; Bir sonraki karakter için tekrarla

done:
    ret

helloMessage db 'Hello, Universe!', 0  ; Yazdırılacak mesajı
