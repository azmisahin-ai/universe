%ifndef helpers.asm
%define helpers.asm

; @file helpers.asm
; @description Yardımcılar dosyası
; @author Azmi SAHIN
; @version 0.0.0.1
; --------------------------------------------------;--------------------------------------------------

;section .text
;    global strlen, sprint, sprintLF, quit


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
strlen:                                             ; string uzunlugu hesaplama
    push    ebx                                     ; EBX'i bu fonksiyonda kullanırken korumak için EBX'teki değeri yığının üzerine itin
    mov     ebx, eax                                ; EAX'teki adresi EBX'e taşıyın (Her ikisi de bellekte aynı segmenti gösterir)   
 
nextchar:
    cmp     byte [eax], 0                           ; bu adreste EAX tarafından işaret edilen baytı sıfırla karşılaştırın (Sıfır, dize sınırlayıcısının sonudur)
    jz      finished                                ; koddaki 'finished' etiketli noktaya atlayın (eğer sıfır işaretliyse)
    inc     eax                                     ; EAX'taki adresi bir bayt artırın (sıfır işaretli AYARLANMAMIŞSA)
    jmp     nextchar                                ; 'nextchar' etiketli koddaki noktaya atlayın
 
finished:
    sub     eax, ebx
    pop     ebx                                     ; yığındaki değeri tekrar EBX'e aktarın
    ret                                             ; fonksiyonun çağrıldığı yere geri dön
 
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
 
    push    eax                                     ; Bu fonksiyonda eax kaydını kullanırken onu korumak için eax'i yığının üzerine itin
    mov     eax, 0Ah                                ; 0Ah'ı eax'e taşıyın - 0Ah, satır beslemesinin ascii karakteridir
    push    eax                                     ; adresi alabilmemiz için satır beslemesini yığının üzerine itin
    mov     eax, esp                                ; geçerli yığın işaretçisinin adresini sprint için eax'e taşıyın
    call    sprint                                  ; sprint fonksiyonumuzu çağırın
    pop     eax                                     ; satır besleme karakterimizi yığından kaldırın
    pop     eax                                     ; işlevimiz çağrılmadan önce eax'in orijinal değerini geri yükleyin
    ret                                             ; programımıza geri dön

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

; ==================================================;==================================================
%endif
