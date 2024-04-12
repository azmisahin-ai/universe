%ifndef helpers.asm
%define helpers.asm

; @file helpers.asm
; @description Yardımcılar dosyası
; @author Azmi SAHIN
; @version 0.0.0.1
; --------------------------------------------------;--------------------------------------------------

section .text
    global strlen, sprint, sprintLF, quit

; @module helpers
; @description Yardımcılar
; @author Azmi SAHIN
; @version 0.0.0.1
; --------------------------------------------------;--------------------------------------------------

; @function strlen
; @description String uzunluğu hesaplama
; @param {string} text bir string değer
; @returns {number} Sring uzunluğu
; --------------------------------------------------;--------------------------------------------------
strlen:                                             ; this is our first function declaration
    push    ebx                                     ; push the value in EBX onto the stack to preserve it while we use EBX in this function
    mov     ebx, eax                                ; move the address in EAX into EBX (Both point to the same segment in memory)    
 
nextchar:
    cmp     byte [eax], 0                           ; compare the byte pointed to by EAX at this address against zero (Zero is an end of string delimiter)
    jz      finished                                ; jump (if the zero flagged has been set) to the point in the code labeled 'finished'
    inc     eax                                     ; increment the address in EAX by one byte (if the zero flagged has NOT been set)
    jmp     nextchar                                ; jump to the point in the code labeled 'nextchar'
 
finished:
    sub     eax, ebx
    pop     ebx                                     ; pop the value on the stack back into EBX
    ret                                             ; return to where the function was called
 
; @function sprint
; @description String yazdırma
; @param {string} text bir string değer
; @returns
; --------------------------------------------------;--------------------------------------------------
sprint:
    push    edx
    push    ecx
    push    ebx
    push    eax
    call    strlen
 
    mov     edx, eax
    pop     eax
 
    mov     ecx, eax
    mov     ebx, 1
    mov     eax, 4
    int     80h
 
    pop     ebx
    pop     ecx
    pop     edx
    ret

; @function sprintLF
; @description Satır başı ile string yazdırma
; @param {string} text bir string değer
; @returns
; --------------------------------------------------;--------------------------------------------------
sprintLF:
    call    sprint
 
    push    eax                                     ; push eax onto the stack to preserve it while we use the eax register in this function
    mov     eax, 0Ah                                ; move 0Ah into eax - 0Ah is the ascii character for a linefeed
    push    eax                                     ; push the linefeed onto the stack so we can get the address
    mov     eax, esp                                ; move the address of the current stack pointer into eax for sprint
    call    sprint                                  ; call our sprint function
    pop     eax                                     ; remove our linefeed character from the stack
    pop     eax                                     ; restore the original value of eax before our function was called
    ret                                             ; return to our program 
 
; @function quit
; @description Programdan çık
; @param
; @returns
; --------------------------------------------------;--------------------------------------------------
quit:
    mov     ebx, 0
    mov     eax, 1
    int     80h
    ret

%endif
