#!/bin/bash

bootctl --path=/boot/ install

echo -e "title\tArch Linux\nlinux\t/vmlinuz-linux\ninitrd\t/intel-ucode.img\ninitrd\t/initramfs-linux.img\noptions cryptdevice=UUID=$(blkid -s UUID -o value /dev/nvme0n1p2):luks:allow-discards root=/dev/mapper/luks rootflags=subvol=@ rd.luks.options=discard rw" > /boot/loader/entries/arch.conf

echo -e "title\tArch Linux Zen\nlinux\t/vmlinuz-linux-zen\ninitrd\t/intel-ucode.img\ninitrd\t/initramfs-linux-zen.img\noptions cryptdevice=UUID=$(blkid -s UUID -o value /dev/nvme0n1p2):luks:allow-discards root=/dev/mapper/luks rootflags=subvol=@ rd.luks.options=discard rw" > /boot/loader/entries/arch-zen.conf

echo -e "title\tArch Linux LTS\nlinux\t/vmlinuz-linux-lts\ninitrd\t/intel-ucode.img\ninitrd\t/initramfs-linux-lts.img\noptions cryptdevice=UUID=$(blkid -s UUID -o value /dev/nvme0n1p2):luks:allow-discards root=/dev/mapper/luks rootflags=subvol=@ rd.luks.options=discard rw" > /boot/loader/entries/arch-lts.conf

echo -e "default\tarch.conf\ntimeout\t3\nconsole-mode max\neditor\tno" >> /boot/loader/loader.conf
