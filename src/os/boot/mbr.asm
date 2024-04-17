; @file src/os/boot/mbr.asm
; @description Master boot record
; @author Azmi SAHIN
; @version 0.0.0.1
; --------------------------------------------------;--------------------------------------------------
BITS 16
org 0x7C00

Start:
    mov ax, cs
    mov ds, ax
    mov es, ax

    ; İşletim sistemi çekirdeğini yükle
    mov ax, 0x1000    ; İşletim sistemi çekirdeğinin yükleneceği adres (0x1000)
    mov es, ax
    xor bx, bx        ; BX'i sıfırla
    mov ah, 0x02      ; Disk okuma fonksiyon kodu
    mov al, 1         ; Okunacak sektör sayısı
    mov ch, 0         ; Silindir numarası
    mov cl, 2         ; İkinci sektör (sektör numarası 1)
    mov dh, 0         ; Kafa numarası
    mov dl, 0         ; Disk sürücüsü numarası (0: ilk floppy disk)
    int 0x13          ; BIOS disk okuma çağrısı

    ; Hata kontrolü
    jc disk_error      ; Taşıma (carry) bayrağı kontrolü

    ; boot mesajı
boot_message:
    mov si, bootMessage
    call PrintString

    ; İşletim sistemi çekirdeğini çalıştır
    jmp 0x1000:0000   ; İşletim sistemi çekirdeğinin başlangıç adresine atla

disk_error:
    ; Hata durumunda ekrana bir mesaj yaz ve işlemi durdur
    mov si, diskErrorMessage
    call PrintString
    jmp $           ; Sonsuz döngüde beklemek için

bootMessage db 'Booting...', 13,10,0
diskErrorMessage db 'Disk read error!', 13,10,0

; Ekrana karakter yazdıran fonksiyon
PrintString:
    mov ah, 0x0E     ; Teletype yazma fonksiyonu
    .repeat:
        lodsb         ; SI'den bir karakter yükle ve AL'ye yerleştir
        or al, al     ; AL'nin 0 olup olmadığını kontrol et
        jz .done       ; Eğer AL 0 ise yazma işlemi bitmiştir
        int 0x10       ; BIOS'a karakter yazdırma çağrısı
        jmp .repeat    ; Bir sonraki karakter için tekrarla
    .done:
        ret            ; PrintString fonksiyonundan çıkış

times 510-($-$$) db 0
dw 0xAA55         ; Boot sektörü imzası
