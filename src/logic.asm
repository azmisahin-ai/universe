; logic.asm - Mantıksal akışlar

section .text
    global _start

_start:                     ; Başla
    call welcome            ; Hoş geldiniz mesajını göster
    call listen             ; Gelen istekleri dinle    
    call quit               ; Programdan çık