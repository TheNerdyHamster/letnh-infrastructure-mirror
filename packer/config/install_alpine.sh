#!/bin/sh

### Install base packages for installation
apk add -u sed qemu-guest-agent

### Qemu guest agent
rc-update add qemu-guest-agent

### Allow root with password
sed -i -e 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

### Setup disks
export ROOTFS=btrfs
setup-disk -m sys -s 0 /dev/sda
