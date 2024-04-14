#!/bin/sh

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 ARCH"
    exit 1
fi

ARCH="$1"

case "$ARCH" in
    linux_64)
        mkdir -p "$PROJECT_FOLDER/build/release/$ARCH"
        nasm -F dwarf -g -f elf64 -o "$PROJECT_FOLDER/build/release/$ARCH/universe.o" -D"$ARCH" "$PROJECT_FOLDER/src/universe.asm"
        ld -m elf_x86_64 -o "$PROJECT_FOLDER/build/release/$ARCH/universe" "$PROJECT_FOLDER/build/release/$ARCH/universe.o"
        echo "Linux 64-bit build completed successfully."
        ;;
    linux_32)
        mkdir -p "$PROJECT_FOLDER/build/release/$ARCH"
        nasm -F dwarf -g -f elf32 -o "$PROJECT_FOLDER/build/release/$ARCH/universe.o" -D"$ARCH" "$PROJECT_FOLDER/src/universe.asm"
        ld -m elf_i386 -o "$PROJECT_FOLDER/build/release/$ARCH/universe" "$PROJECT_FOLDER/build/release/$ARCH/universe.o"
        echo "Linux 32-bit build completed successfully."
        ;;
    win_64)
        mkdir -p "$PROJECT_FOLDER/build/release/$ARCH"
        nasm -f win64 -o "$PROJECT_FOLDER/build/release/$ARCH/universe.obj" -D"$ARCH" "$PROJECT_FOLDER/src/universe.asm"
        i686-w64-mingw32-ld -o "$PROJECT_FOLDER/build/release/$ARCH/universe.exe" "$PROJECT_FOLDER/build/release/$ARCH/universe.obj"
        echo "Windows 64-bit build completed successfully."
        ;;
    win_32)
        mkdir -p "$PROJECT_FOLDER/build/release/$ARCH"
        nasm -f win32 -o "$PROJECT_FOLDER/build/release/$ARCH/universe.obj" -D"$ARCH" "$PROJECT_FOLDER/src/universe.asm"
        i686-w64-mingw32-ld -o "$PROJECT_FOLDER/build/release/$ARCH/universe.exe" "$PROJECT_FOLDER/build/release/$ARCH/universe.obj"
        echo "Windows 32-bit build completed successfully."
        ;;
    *)
        echo "Unsupported architecture: $ARCH"
        exit 1
        ;;
esac
