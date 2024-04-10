; universe_common.asm - Ortak tanımlamalar

section .data
    msg db 'Universe', 0
    msg_listening db 'Listening on 0.0.0.0:8280', 0x0a ; 'Listening on 0.0.0.0:8280\n'
    response db 'HTTP/1.1 200 OK', 0Dh, 0Ah, 'Content-Type: text/html', 0Dh, 0Ah, 'Content-Length: 14', 0Dh, 0Ah, 0Dh, 0Ah, 'Hello World!', 0Dh, 0Ah, 0h
 
SECTION .bss
    buffer resb 255,                ; variable to store request headers    