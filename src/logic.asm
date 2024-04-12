; logic.asm - Mantıksal akışlar

_start:                 ; global start
    call welcome        ; Welcome message
    call socket         ; HOST_IP="0.0.0.0" PORT="8280" üzerinde dinler    
    call quit           ; call exit