#!/bin/bash

# Çıktı dizinini oluştur
mkdir -p build/os

# Boot ve kernel dosyalarını derle
nasm -f bin src/os/boot.asm -o build/os/boot.bin
nasm -f bin src/os/kernel.asm -o build/os/kernel.bin

# Dosyalar başarıyla oluşturulduysa devam et
if [ -f "build/os/boot.bin" ] && [ -f "build/os/kernel.bin" ]; then

    # Disk imajını oluştur
    dd if=/dev/zero of=build/os/universe.img bs=512 count=2880

    # Boot ve kernel dosyalarını imaj dosyasına kopyala
    dd if=build/os/boot.bin of=build/os/universe.img conv=notrunc
    dd if=build/os/kernel.bin of=build/os/universe.img seek=1 conv=notrunc

    # QEMU'yu başlat
    qemu-system-i386 -drive id=disk0,file="build/os/universe.img",format=raw

else
    echo "Dosya oluşturma işlemi başarısız oldu!"
fi
