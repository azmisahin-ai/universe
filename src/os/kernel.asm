; src/os/kernel.asm
BITS 16
org 0x1000

; Ekrana mesaj yazdırma
mov ah, 0x0E    ; Teletype yazma fonksiyonu
mov al, 'H'
int 0x10

mov al, 'e'
int 0x10

mov al, 'l'
int 0x10

mov al, 'l'
int 0x10

mov al, 'o'
int 0x10

jmp $           ; Sonsuz döngüde beklemek için

times 512-($-$$) db 0
