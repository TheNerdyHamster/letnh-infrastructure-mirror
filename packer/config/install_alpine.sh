#!/bin/sh

### Install base packages for installation
apk add -u lvm2 xfsprogs e2fsprogs syslinux parted sed qemu-guest-agent

### Load kernel module
modprobe dm-mod

### Partition drive
echo "mklabel gpt
unit MiB
mkpart 1 1 256
name 1 boot
set 1 legacy_boot on
mkpart 2 256 100%
name 2 lvm
set 2 lvm on
quit
" | parted -a optimal /dev/sda

mkfs.ext3 /dev/sda1


### LVM
pvcreate /dev/sda2

vgcreate vg0 /dev/sda2

lvcreate -n root -L 4G vg0
lvcreate -n home -L 2G vg0
lvcreate -n usr -L 2G vg0
lvcreate -n var -L 2G vg0

rc-update add lvm

vgchange -ay

### Format partitions
mkfs.xfs /dev/mapper/vg0-root
mkfs.xfs /dev/mapper/vg0-home
mkfs.xfs /dev/mapper/vg0-var
mkfs.xfs /dev/mapper/vg0-usr

### Mount partitions
mount -t xfs /dev/mapper/vg0-root /mnt

mkdir -p /mnt/boot /mnt/home /mnt/usr /mnt/var

mount -t ext3 /dev/sda1 /mnt/boot
mount -t xfs /dev/mapper/vg0-home /mnt/home
mount -t xfs /dev/mapper/vg0-var /mnt/var
mount -t xfs /dev/mapper/vg0-usr /mnt/usr

### Qemu guest agent
rc-update add qemu-guest-agent

### Allow root with password
sed -i -e 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

### Remove old packages
apk del parted

### Setup disks
setup-disk -m sys /mnt
dd bs=440 conv=notrunc count=1 if=/usr/share/syslinux/gptmbr.bin of=/dev/sda
