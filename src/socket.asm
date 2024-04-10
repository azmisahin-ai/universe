; socket.asm 
 
socket_start:
 
    xor     eax, eax            ; initialize some registers
    xor     ebx, ebx
    xor     edi, edi
    xor     esi, esi
 
_socket:
 
    push    byte 6              ; create socket from lesson 29
    push    byte 1
    push    byte 2
    mov     ecx, esp
    mov     ebx, 1
    mov     eax, 102
    int     80h
 
_bind:
 
    mov     edi, eax            ; move return value of SYS_SOCKETCALL into edi (file descriptor for new socket, or -1 on error)
    push    dword 0x00000000    ; push 0 dec onto the stack IP ADDRESS (0.0.0.0)
    push    word 0x901F         ; push 8080 dec onto stack PORT (reverse byte order)
    push    word 2              ; push 2 dec onto stack AF_INET
    mov     ecx, esp            ; move address of stack pointer into ecx
    push    byte 16             ; push 16 dec onto stack (arguments length)
    push    ecx                 ; push the address of arguments onto stack
    push    edi                 ; push the file descriptor onto stack
    mov     ecx, esp            ; move address of arguments into ecx
    mov     ebx, 2              ; invoke subroutine BIND (2)
    mov     eax, 102            ; invoke SYS_SOCKETCALL (kernel opcode 102)
    int     80h                 ; call the kernel
 
_listen:
 
    push    byte 1              ; listen socket from lesson 31
    push    edi
    mov     ecx, esp
    mov     ebx, 4
    mov     eax, 102
    int     80h
 
_accept:
 
    push    byte 0              ; accept socket from lesson 32
    push    byte 0
    push    edi
    mov     ecx, esp
    mov     ebx, 5
    mov     eax, 102
    int     80h
 
_fork:
 
    mov     esi, eax            ; fork socket from lesson 33
    mov     eax, 2
    int     80h
 
    cmp     eax, 0
    jz      _read
 
    jmp     _accept
 
_read:
 
    mov     edx, 255            ; read socket from lesson 33
    mov     ecx, buffer
    mov     ebx, esi
    mov     eax, 3
    int     80h
 
    mov     eax, buffer
    call    sprintLF
 
_write:
 
    mov     edx, 78             ; move 78 dec into edx (length in bytes to write)
    mov     ecx, response       ; move address of our response variable into ecx
    mov     ebx, esi            ; move file descriptor into ebx (accepted socket id)
    mov     eax, 4              ; invoke SYS_WRITE (kernel opcode 4)
    int     80h                 ; call the kernel
 
_exit:
 
    call    quit                ; call our quit function