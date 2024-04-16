# build.sh

mkdir -p build/os

nasm -f bin src/os/boot.asm -o build/os/boot.bin
nasm -f bin src/os/kernel.asm -o build/os/kernel.bin
cat build/os/boot.bin build/os/kernel.bin > build/os/universe.img

qemu-system-i386 -fda build/os/universe.img
