; src/os/boot.asm
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

    ; İşletim sistemi çekirdeğini çalıştır
    jmp 0x1000:0000   ; İşletim sistemi çekirdeğinin başlangıç adresine atla

times 510-($-$$) db 0
dw 0xAA55
