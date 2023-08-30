#Clear USB
#dd if=/dev/zero of=/dev/sdb bs=4096 count=65536 status=progress && sync

#Copy ISO
#dd if=tinycore.iso of=/dev/sdb bs=4096 status=progress && sync

#Emu USB
#qemu -drive format=raw,file=/dev/sdb


#Disk image
dd if=/dev/zero of=diskimage.dd bs=4096 count=65536 && sync

fdisk diskimage.dd
g
n p
1
2048
+16M
t 1
1
w

losetup -o $[2048*512] --sizelimit $[16*1024*1024] -f diskimage.dd

mkfs.vfat -F 16 -n "EFISYSTEM" /dev/loop0

mkdir mnt
mount /dev/loop0 mnt

cp boot mnt/boot

umount mnt
rmdir mnt

dd if=boot of=diskimage.dd conv=notrunc bs=442 count=1
dd if=boot of=diskimage.dd conv=notrunc bs=1 count=4 skip=508 seek=508

losetup -D
