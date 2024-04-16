#!/bin/bash

# Çıktı dizinini oluştur
mkdir -p build/os

# Boot ve kernel dosyalarını derle ve imaj dosyasını oluştur
nasm -f bin src/os/boot.asm -o build/os/boot.bin
nasm -f bin src/os/kernel.asm -o build/os/kernel.bin

# Dosyalar başarıyla oluşturulduysa devam et
if [ -f "build/os/boot.bin" ] && [ -f "build/os/kernel.bin" ]; then
    # Boot ve kernel dosyalarını birleştirerek imaj dosyasını oluştur
    cat build/os/boot.bin build/os/kernel.bin > build/os/universe.bin

    # İmaj dosyasını hedef disk cihazına yaz
    dd if=build/os/universe.bin of=build/os/universe.img bs=512

    # dd komutu ile hedef diske yazdıktan sonra QEMU'yu başlat
    qemu-system-i386 -fda build/os/universe.img
else
    echo "Dosya oluşturma işlemi başarısız oldu!"
fi
