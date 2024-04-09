; universe.asm

%ifdef BITS_32
    %include 'src/universe_32.asm'
%elifdef BITS_64    
    %include 'src/universe_64.asm'
%else
    %error "Belirtilen işlemci mimarisi desteklenmiyor."
%endif
