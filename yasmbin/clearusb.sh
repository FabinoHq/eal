#Clear USB
dd if=/dev/zero of=/dev/sdb bs=4096 count=65536 status=progress && sync
