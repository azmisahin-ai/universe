# Boot ve kernel dosyalarını derle
nasm -f bin src/os/boot.asm -o build/os/boot.bin
nasm -f bin src/os/kernel.asm -o build/os/kernel.bin

# Dosyalar başarıyla oluşturulduysa devam et
if [ -f "build/os/boot.bin" ] && [ -f "build/os/kernel.bin" ]; then

    # Disk imajını oluştur
    dd bs=512 count=2880 if=/dev/zero of=build/os/fda.img   # 2880 adet 512 byte'lık sektör

    # Boot ve kernel dosyalarını imaj dosyasına kopyala
    dd seek=0 conv=notrunc of=build/os/fda.img if=build/os/boot.bin 
    dd seek=1 conv=notrunc of=build/os/fda.img if=build/os/kernel.bin

    # QEMU'yu başlat
    qemu-system-x86_64 -fda build/os/fda.img 

else
    echo "Dosya oluşturma işlemi başarısız oldu!"
fi
