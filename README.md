# SISTEMA OPERACIONAL

Um sistema operacional x86 desenvolvido em assembly com qemu, bochs.  

## Objetivo

 Criar um bootloader e um nano kernel de um sistema operacional.

## Requisitos

- Bootloader ✅
- Sistema de arquivos com alocação continua ✅ (fat12)
- Monousuario ✅
- Monotarefa ✅
- Sem interface grafica (Só linha de comando) ✅
- Capaz de reiniciar o computador ✅ (via bochs)
- Capaz de carregar uma aplicação de teste ✅ (fat - ler arquivos como test.txt)

## Sistema de Arquivo (FAT 12)

FAT12 (File Allocation Table 12-bit) uses a form of continuous or linked allocation. FAT12 allocates files in clusters, and each cluster can be stored non-contiguously on the disk. When a file is stored, the system keeps track of the clusters that make up the file using the File Allocation Table (FAT).

source: <https://www.eit.lth.se/fileadmin/eit/courses/eitn50/Literature/fat12_description.pdf>

## Autores

- [@mateus-jesus (535979)](https://www.github.com/mateus-jeusus)
