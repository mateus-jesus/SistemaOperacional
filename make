#!/bin/bash

mkdir -p build

PS4='• '
set -x

# -----------------------------------------------------------------------------
# Bootloader build
# -----------------------------------------------------------------------------

nasm src/boot/loader.asm -f bin -o build/loader.bin || exit

# -----------------------------------------------------------------------------
# Kernel build
# -----------------------------------------------------------------------------

nasm src/boot/kernel.asm -f bin -o build/kernel.bin || exit

# -----------------------------------------------------------------------------
# Image build
# -----------------------------------------------------------------------------

# Criar arquivo de 1.44MB...
dd if=/dev/zero of=build/lost.img bs=512 count=2880

# Criar um sistema de arquivos FAT12 vazio...
/sbin/mkfs.fat -F 12 -n "LOST" build/lost.img

# Copiar o bootloader no primeiro setor do disco...
dd if=build/loader.bin of=build/lost.img conv=notrunc

# Copiar arquivo do kernel para o segundo setor sem montar o sistema de arquivos...
mcopy -i build/lost.img build/kernel.bin "::kernel.bin"

# Listar arquivos da imagem...
mdir -i build/lost.img
