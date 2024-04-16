#!/bin/bash

# Çıktı dizinini oluştur
mkdir -p build/os

# Boot ve kernel dosyalarını derle
nasm -f bin src/os/boot.asm -o build/os/boot.bin
nasm -f bin src/os/kernel.asm -o build/os/kernel.bin

# Dosyalar başarıyla oluşturulduysa devam et
if [ -f "build/os/boot.bin" ] && [ -f "build/os/kernel.bin" ]; then
    # Boot ve kernel dosyalarını birleştirerek imaj dosyasını oluştur
    cat build/os/boot.bin build/os/kernel.bin > build/os/universe.bin

    # İmaj dosyasını hedef disk cihazına yaz
    qemu-img create -f raw build/os/universe.img 1M  # 1MB boyutunda disk imajı oluştur
    dd if=build/os/universe.bin of=build/os/universe.img bs=512 conv=notrunc

    # QEMU'yu başlat
    qemu-system-i386 -fda build/os/universe.img
else
    echo "Dosya oluşturma işlemi başarısız oldu!"
fi
