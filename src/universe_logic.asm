; universe_logic.asm - Mantıksal akışlar

section .text
    global _start
    
_start:                 ; global start
    call welcome        ; call welcome
    call socket_listen  ; HOST_IP="0.0.0.0" PORT="8280" üzerinde dinler    
    call exit           ; call exit
    
