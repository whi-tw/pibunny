MOUNT=$(mktemp -d)
mount /dev/mmcblk0p2 ${MOUNT}
mount /dev/mmcblk0p1 ${MOUNT}/boot
mount /dev/mmcblk0p3 ${MOUNT}/root/udisk
