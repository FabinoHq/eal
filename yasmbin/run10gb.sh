rm -f boot
yasm src/boot.asm
qemu-system-x86_64 -m 10G -drive format=raw,file=boot
