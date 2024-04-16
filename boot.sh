# boot.sh
#!/bin/bash

mkdir -p build/os

nasm -f bin src/os/boot.asm -o build/os/boot.bin
nasm -f bin src/os/kernel.asm -o build/os/kernel.bin

# Dosyalar oluşturulduğunda mevcut olup olmadığını kontrol edin
if [ -f "build/os/boot.bin" ] && [ -f "build/os/kernel.bin" ]; then
    cat build/os/boot.bin build/os/kernel.bin > build/os/universe.img
    qemu-system-i386 -fda build/os/universe.img
else
    echo "Dosya oluşturma işlemi başarısız oldu!"
fi
