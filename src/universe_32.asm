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

socket_listen:          ; HOST_IP="0.0.0.0" PORT="8280" üzerinde dinler
                        ; Socket oluşturma
    ; syscall: socketcall(SYS_SOCKET, [AF_INET, SOCK_STREAM, IPPROTO_TCP])
    ; eax = 102 (0x66) -> socketcall için syscall numarası
    ; ebx = 1 -> SYS_SOCKET için çağrı kodu
    ; ecx = 1 -> AF_INET (IPv4)
    ; edx = 2 -> SOCK_STREAM (TCP)
    ; esi = 0 -> IPPROTO_TCP (TCP protokolü)
    mov eax, 102        ; socketcall için syscall numarası
    mov ebx, 1          ; SYS_SOCKET için çağrı kodu
    mov ecx, 1          ; AF_INET (IPv4)
    mov edx, 2          ; SOCK_STREAM (TCP)
    int 0x80            ; Linux syscall

    ; Oluşturulan soket dosya tanımlayıcısını al
    ; eax registerinde soket dosya tanımlayıcısı olacak
    mov ebx, eax        ; Soket dosya tanımlayıcısını ebx'ye kopyala

    ; Soket bağlantı bilgilerini hazırla
    ; struct sockaddr_in {
    ;     sin_family = AF_INET
    ;     sin_port = htons(8280)
    ;     sin_addr = INADDR_ANY (0.0.0.0)
    ; }
    ; Port numarasını 8280 olarak ayarla (0x206c büyük endian olarak)
    xor eax, eax        ; eax sıfırlandı (INADDR_ANY için)
    push eax            ; IP adresini INADDR_ANY (0.0.0.0) olarak ayarla
    push word 0x206c    ; Port numarasını 8280 (0x206c büyük endian) olarak ayarla
    push word 0x2       ; AF_INET
    mov ecx, esp        ; sockaddr_in struct adresini ecx'ye yükle (stack'te)

    ; Soketi bağlama (bind)
    ; syscall: bind(sockfd, &addr, sizeof(addr))
    ; eax = 102 (0x66) -> socketcall için syscall numarası
    ; ebx = 2 -> SYS_BIND için çağrı kodu
    ; ecx = &addr -> sockaddr_in struct adresi
    ; edx = sizeof(addr) -> struct boyutu
    mov eax, 102        ; socketcall için syscall numarası
    mov ebx, 2          ; SYS_BIND için çağrı kodu
    mov edx, 16         ; sizeof(struct sockaddr_in) = 16 byte
    int 0x80            ; Linux syscall

    ; Socket'i dinleme moduna geçir
    ; syscall: listen(sockfd, backlog)
    ; eax = 102 (0x66) -> socketcall için syscall numarası
    ; ebx = 4 -> SYS_LISTEN için çağrı kodu
    ; ecx = backlog (bağlantı sırası) -> bu örnekte 0 (backlog sırası yok)
    mov eax, 102        ; socketcall için syscall numarası
    mov ebx, 4          ; SYS_LISTEN için çağrı kodu
    mov ecx, 0          ; Bağlantı sırası (backlog) = 0
    int 0x80            ; Linux syscall

    ; Başarı mesajını yazdır
    mov eax, 4          ; write syscall numarası
    mov ebx, 1          ; stdout dosya tanımlayıcısı
    mov ecx, msg_listening        ; Yazdırılacak stringin adresi
    mov edx, 27         ; Yazdırılacak byte sayısı ('Listening on 0.0.0.0:8280\n' stringi)
    int 0x80            ; Linux syscall   
    
accept_loop:            ; Sonsuz döngüde
                        ; Bağlantıyı kabul et
    ; syscall: accept(sockfd, &addr, &addrlen)
    ; eax = 102 (0x66) -> socketcall için syscall numarası
    ; ebx = 5 -> SYS_ACCEPT için çağrı kodu
    ; ecx = &addr -> gelen bağlantı adresi bilgileri için boş bir struct
    ; edx = &addrlen -> bağlantı adresi struct boyutu
    mov eax, 102        ; socketcall için syscall numarası
    mov ebx, 5          ; SYS_ACCEPT için çağrı kodu
    int 0x80            ; Linux syscall

    ; Accept başarısız olursa (EINTR dönerse) tekrar dene
    cmp eax, -1
    je accept_loop

    ; Bağlantı kabul edildi, devam et

    ; Burada bağlantıyla işlem yapabilirsiniz...

    ; Bağlantıyı kapat
    ; syscall: close(sockfd)
    ; eax = 6 -> SYS_CLOSE için syscall numarası
    ; ebx = sockfd -> soket dosya tanımlayıcısı
    mov eax, 6          ; close syscall numarası
    int 0x80            ; Linux syscall

    ; Sonsuz döngüye geri dönerek yeni bağlantıları kabul etmeye devam et
    jmp accept_loop

    ; Programı sonlandır
    ; eax = 1 -> SYS_EXIT için syscall numarası
    ; ebx = 0 -> çıkış kodu (başarılı)
    mov eax, 1          ; exit syscall numarası
    xor ebx, ebx        ; çıkış kodu (0)
    int 0x80            ; Linux syscall
    ret                 ; geri dön     