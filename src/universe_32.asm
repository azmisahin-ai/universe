; universe_32

welcome:                ; Welcome
    mov eax, 4          ; Syscall numarası (4 = write)
    mov ebx, 1          ; Dosya tanımlayıcısı (1 = stdout)
    mov ecx, msg        ; Yazdırılacak stringin adresi
    mov edx, 13         ; Yazdırılacak byte sayısı
    int 0x80            ; Linux syscall
    ret                 ; geri dön

exit:                   ; Exit
    mov eax, 1          ; Syscall numarası (1 = exit)
    xor ebx, ebx        ; Çıkış kodu (0)
    int 0x80            ; Linux syscall      

socket:                 ; HOST_IP="0.0.0.0" PORT="8280" üzerinde dinler
%include 'src/function.asm'
%include 'src/socket.asm' 
; %include 'src/connect.asm'  