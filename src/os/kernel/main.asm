; @file src/os/kernel/main.asm
; @description Responsible for managing resources.
; @author Azmi SAHIN
; @version 0.0.0.1
; --------------------------------------------------;--------------------------------------------------
BITS 16
org 0x1000

%include "src/os/kernel/version.asm"
%include "src/os/kernel/drivers.asm"
%include "src/os/kernel/interrupts.asm"
%include "src/os/kernel/memory.asm"
%include "src/os/kernel/networking.asm"
%include "src/os/kernel/processes.asm"

jmp $           ; Sonsuz döngüde beklemek için

times 512-($-$$) db 0
