#!/bin/bash

set -e
encryption_passphrase=""
hostname=""
username=""
read -p "Enter encryption passphrase: " encryption_passphrase
read -p "Enter hostname: " hostname
read -p "Enter username: " username
read -p "Enter userpass: " user_password
read -p "Enter rootpass: " root_password
continent_city="America/Argentina/Mendoza"

timedatectl set-ntp true
pacman -Sy --noconfirm
sed -i 's/#UseSyslog/UseSyslog/g; s/#Color/Color/g; s/#TotalDownload/TotalDownload/g; s/#CheckSpace/CheckSpace/g' /etc/pacman.conf

sgdisk --zap-all /dev/nvme0n1
printf "n\n1\n\n+333M\nef00\nn\n2\n\n\n\nw\ny\n" | gdisk /dev/nvme0n1 # ADD SWAP
mkdir -p -m0700 /run/cryptsetup
echo "$encryption_passphrase" | cryptsetup -q --align-payload=8192 -h sha512 -s 512 --use-random --type luks2 -c aes-xts-plain64 luksFormat /dev/nvme0n1p2 # SEE CRYPT OPTIONS
echo "$encryption_passphrase" | cryptsetup luksOpen /dev/nvme0n1p2 crypt_root # OR LUKS
yes | mkfs.vfat -F32 /dev/nvme0n1p1
yes | mkfs.btrfs /dev/mapper/crypt_root
mount /dev/mapper/crypt_root /mnt

btrfs subvolume create /mnt/@
btrfs subvolume create /mnt/@home
btrfs subvolume create /mnt/@pkg
btrfs subvolume create /mnt/@srv
btrfs subvolume create /mnt/@log
btrfs subvolume create /mnt/@tmp
btrfs subvolume create /mnt/@btrfs
umount /mnt
mount -o noatime,nodiratime,compress-force=zstd:1,space_cache=v2,subvol=@ /dev/mapper/crypt_root /mnt
mkdir -p /mnt/{home,var/cache/pacman/pkg,srv,log,tmp,btrfs,boot}
mount -o noatime,nodiratime,compress-force=zstd:1,space_cache=v2,subvol=@home /dev/mapper/crypt_root /mnt/home
mount -o noatime,nodiratime,compress-force=zstd:1,space_cache=v2,subvol=@pkg /dev/mapper/crypt_root /mnt/var/cache/pacman/pkg
mount -o noatime,nodiratime,compress-force=zstd:1,space_cache=v2,subvol=@srv /dev/mapper/crypt_root /mnt/srv
mount -o noatime,nodiratime,compress-force=zstd:1,space_cache=v2,subvol=@log /dev/mapper/crypt_root /mnt/log
mount -o noatime,nodiratime,compress-force=zstd:1,space_cache=v2,subvol=@tmp /dev/mapper/crypt_root /mnt/tmp
mount -o noatime,nodiratime,compress-force=zstd:1,space_cache=v2,subvolid=5 /dev/mapper/crypt_root /mnt/btrfs
mount /dev/nvme0n1p1 /mnt/boot

yes '' | pacstrap /mnt base base-devel linux linux-firmware \
	intel-media-driver vulkan-intel libvdpau-va-gl \
	bluez bluez-utils tlp cryptsetup \
	plasma konsole okular gwenview dolphin \
	networkmanager efibootmgr intel-ucode neovim btrfs-progs wget

genfstab -U /mnt >> /mnt/etc/fstab
#arch-chroot /mnt /bin/bash << EOF
timedatectl set-ntp true
timedatectl set-timezone $continent_city
hwclock --systohc --localtime
sed -i "s/#en_US/en_US/g; s/#es_AR/es_AR/g" /etc/locale.gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf
locale-gen
echo "KEYMAP=dvorak" > /etc/vconsole.conf
echo -e "127.0.0.1\tlocalhost" >> /etc/hosts
echo -e "::1\t\tlocalhost" >> /etc/hosts
echo -e "127.0.1.1\t$hostname.localdomain\t$hostname" >> /etc/hosts
echo "%wheel ALL=(ALL) ALL" >> /etc/sudoers
echo "Defaults !tty_tickets" >> /etc/sudoers
sed -i 's/-)/--threads=0 -)/g; s/gzip/pigz/g; s/bzip2/pbzip2/g; s/#MAKEFLAGS/MAKEFLAGS/g; s/-j2/-j$(nproc)/g' /etc/makepkg.conf
sed -i 's/#UseSyslog/UseSyslog/g; s/#Color/Color/g; s/#TotalDownload/TotalDownload/g; s/#CheckSpace/CheckSpace/g' /etc/pacman.conf
echo $hostname > /etc/hostname
echo -en "$root_password\n$root_password" | passwd
useradd -m -g users -G wheel,games,power,optical,storage,scanner,lp,audio,video,input,adm,users $username
echo -en "$user_password\n$user_password" | passwd $username

systemctl enable NetworkManager.service
systemctl enable fstrim.timer
systemctl enable bluetooth.service
systemctl enable tlp.service
systemctl enable sddm.service

touch /etc/sysctl.d/99-swappiness.conf
echo 'vm.swappiness=20' > /etc/sysctl.d/99-swappiness.conf

mkdir -p /etc/pacman.d/hooks/
touch /etc/pacman.d/hooks/100-systemd-boot.hook
tee -a /etc/pacman.d/hooks/100-systemd-boot.hook << END
[Trigger]
Type = Package
Operation = Upgrade
Target = systemd

[Action]
Description = Updating systemd-boot
When = PostTransaction
Exec = /usr/bin/bootctl update
END

sed -i "s/^HOOKS.*/HOOKS=(base systemd keyboard autodetect sd-vconsole modconf block sd-encrypt filesystems fsck)/g" /etc/mkinitcpio.conf
sed -i 's/^MODULES.*/MODULES=(btrfs intel_agp i915)/' /etc/mkinitcpio.conf
mkinitcpio -P
bootctl --path=/boot/ install

mkdir -p /boot/loader/
tee -a /boot/loader/loader.conf << END
default arch.conf
timeout 3
console-mode max
editor no
END

mkdir -p /boot/loader/entries/
touch /boot/loader/entries/arch.conf
tee -a /boot/loader/entries/arch.conf << END
title Arch Linux
linux /vmlinuz-linux
initrd /intel-ucode.img
initrd /initramfs-linux.img
options rd.luks.name=$(blkid -s UUID -o value /dev/nvme0n1p2)=crypt_root root=/dev/TODO/root rootflags=subvol=@ rd.luks.options=discard i915.fastboot=1 i915.enable_fbc=1 i915.enable_guc=2 nmi_watchdog=0 quiet rw
END
EOF
umount -R /mnt
swapoff -a
