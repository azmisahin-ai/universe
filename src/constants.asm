; @file constants.asm
; @description Sabit değerler dosyası
; @author Azmi SAHIN
; @version 0.0.0.1
; --------------------------------------------------;--------------------------------------------------

section .data
    msg_welcome db 'Universe', 0h
    msg_listening db 'Listening on 0.0.0.0:8280', 0h    
    request db 'GET / HTTP/1.1', 0Dh, 0Ah, 'Host: 1.1.1.1:8080', 0Dh, 0Ah, 0Dh, 0Ah, 0h
