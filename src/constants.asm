; constants.asm - Sabit değerler dosyası

section .data
    msg_welcome db 'Universe', 0h
    msg_listening db 'Listening on 0.0.0.0:8280', 0h
    response db 'HTTP/1.1 200 OK', 0Dh, 0Ah, 'Content-Type: text/html', 0Dh, 0Ah, 'Content-Length: 14', 0Dh, 0Ah, 0Dh, 0Ah, 'Hello Universe!', 0Dh, 0Ah, 0h
    request db 'GET / HTTP/1.1', 0Dh, 0Ah, 'Host: 1.1.1.1:8080', 0Dh, 0Ah, 0Dh, 0Ah, 0h