./makeiso
qemu-system-x86_64 -boot d -cdrom boot.iso

# Create hdd image
#qemu-img create hdd.img 10G
#qemu -boot d -cdrom boot.iso -hda hdd.img
