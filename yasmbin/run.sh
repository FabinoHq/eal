rm -f boot
yasm src/boot.asm
qemu-system-x86_64 -m 2G -drive format=raw,file=boot
