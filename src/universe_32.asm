; universe_32

%include 'src/universe_common.asm'

section .text
    global _start

_start:
    ; Welcome
    mov eax, 4          ; Syscall numarası (4 = write)
    mov ebx, 1          ; Dosya tanımlayıcısı (1 = stdout)
    mov ecx, msg        ; Yazdırılacak stringin adresi
    mov edx, 13         ; Yazdırılacak byte sayısı
    int 0x80            ; Linux syscall
    
    ; Exit
    mov eax, 1          ; Syscall numarası (1 = exit)
    xor ebx, ebx        ; Çıkış kodu (0)
    int 0x80            ; Linux syscall
