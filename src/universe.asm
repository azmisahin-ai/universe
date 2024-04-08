section .data
    msg db 'Universe', 0   ; Yazdırılacak metin (null-terminated string)

section .text
    global _start

_start:
    ; sys_write için gerekli olan sistem çağrısı numarası
    mov rax, 1            ; rax'e 1 atanır (sys_write için sistem çağrısı numarası)

    ; stdout (standart çıkış) için dosya tanıtıcısı (file descriptor)
    mov rdi, 1            ; rdi'ye 1 atanır (standart çıkış)

    ; Yazdırılacak mesajın adresi (msg etiketinin adresi)
    mov rsi, msg          ; rsi'ye msg etiketinin adresi atanır

    ; Mesajın uzunluğu (null-terminated string olduğu için uzunluğu belirtmeye gerek yok)
    ; msg db 'Universe', 0   -> 'Universe' için 8 karakter, sonrasında null byte (0)

    ; sys_write sistem çağrısını çağır
    mov rdx, 7            ; rdx'e yazdırılacak karakter sayısı (null byte hariç)
    syscall               ; sistem çağrısını yap

    ; Programı sonlandır
    mov rax, 60           ; rax'e 60 atanır (exit sistem çağrısı numarası)
    xor rdi, rdi          ; return code olarak 0 (başarılı sonlanma) atanır
    syscall               ; sistem çağrısını yap
