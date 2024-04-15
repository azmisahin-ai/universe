nasm -f bin src/boot.asm -o build/boot.bin
dd if=/dev/zero of=build/fda.img bs=512 count=2880
dd if=build/boot.bin of=build/fda.img bs=512 count=1 conv=notrunc

qemu-system-i386 build/fda.img
