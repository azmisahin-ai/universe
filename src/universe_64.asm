; universe_64

welcome:                ; Welcome    
    mov rax, 1          ; sys_write için syscall numarası
    mov rdi, 1          ; stdout (1) için dosya tanıtıcısı
    mov rsi, msg        ; Yazdırılacak stringin adresi
    mov rdx, 20         ; Yazdırılacak karakter sayısı
    syscall             ; syscall çağrısı

exit:                   ; Exit    
    mov rax, 60         ; sys_exit için syscall numarası
    xor rdi, rdi        ; Hata kodu olarak sıfır
    syscall             ; syscall çağrısı