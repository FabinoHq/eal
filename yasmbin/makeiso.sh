#Build
yasm boot.asm

#ISO

# Create ISO dir
mkdir ISO

# Create floppy image
dd if=/dev/zero of=ISO/floppy bs=512 count=2880

# Copy boot sector
dd if=boot of=ISO/floppy conv=notrunc bs=512 count=2880

# Copy partial boot sector
# dd if=boot of=ISO/floppy conv=notrunc bs=1 count=3
# dd if=boot of=ISO/floppy conv=notrunc bs=1 count=320 skip=120 seek=120
# dd if=boot of=ISO/floppy conv=notrunc bs=1 count=2 skip=510 seek=510


#Generate ISO image
#genisoimage -R -J -o boot.iso -V BOOT -b floppy -no-emul-boot ISO
genisoimage -R -J -o boot.iso -V BOOT -b floppy ISO

#Delete ISO dir
rm -rf ISO
