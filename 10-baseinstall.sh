#!/bin/bash

#10-baseinstall.sh

timedatectl set-ntp true
sleep 6

echo "Enter the drive: "
read drive
echo "Enter the root partition: "
read rootpartition
echo "Enter the boot partition: "
read bootpartition

sgdisk --zap-all $drive
printf "n\n1\n\n+666M\nef00\nn\n2\n\n\n\nw\ny\n" | gdisk $drive
cryptsetup luksFormat $rootpartition
cryptsetup luksOpen $rootpartition luks
mkfs.vfat -F32 $bootpartition
mkfs.btrfs /dev/mapper/luks
mount /dev/mapper/luks /mnt
btrfs subvolume create /mnt/@
btrfs subvolume create /mnt/@home
btrfs subvolume create /mnt/@pkg
btrfs subvolume create /mnt/@srv
btrfs subvolume create /mnt/@log
btrfs subvolume create /mnt/@tmp
btrfs subvolume create /mnt/@btrfs
umount /mnt
mount -o noatime,nodiratime,compress-force=zstd,space_cache=v2,discard=async,subvol=@ /dev/mapper/luks /mnt
mkdir -p /mnt/{home,var/cache/pacman/pkg,srv,log,tmp,btrfs,boot}
mount -o noatime,nodiratime,compress-force=zstd,space_cache=v2,discard=async,subvol=@home /dev/mapper/luks /mnt/home
mount -o noatime,nodiratime,compress-force=zstd,space_cache=v2,discard=async,subvol=@pkg /dev/mapper/luks /mnt/var/cache/pacman/pkg
mount -o noatime,nodiratime,compress-force=zstd,space_cache=v2,discard=async,subvol=@srv /dev/mapper/luks /mnt/srv
mount -o noatime,nodiratime,compress-force=zstd,space_cache=v2,discard=async,subvol=@log /dev/mapper/luks /mnt/log
mount -o noatime,nodiratime,compress-force=zstd,space_cache=v2,discard=async,subvol=@tmp /dev/mapper/luks /mnt/tmp
mount -o noatime,nodiratime,compress-force=zstd,space_cache=v2,discard=async,subvolid=5 /dev/mapper/luks /mnt/btrfs
mount $bootpartition /mnt/boot
pacstrap /mnt base \
	base-devel \
	linux \
	linux-zen \
	linux-lts \
	linux-firmware \
	intel-media-driver \
	vulkan-intel \
	libvdpau-va-gl \
	networkmanager \
	efibootmgr \
	intel-ucode \
	neovim \
	btrfs-progs \
	git \
	tlp \
	tlp-rdw \
	bluez \
	bluez-utils \

genfstab -U /mnt >> /mnt/etc/fstab

sed '1,/^#13-Chroot$/d' 10-baseinstall.sh > /mnt/13-Chroot.sh
chmod +x /mnt/13-Chroot.sh
arch-chroot /mnt ./13-Chroot.sh
exit

######################################################################################
#13-Chroot
echo "Hostname: "
read hostname
echo "User: "
read username
useradd -m -g users -G wheel,games,power,optical,storage,scanner,lp,audio,video,input,adm,users $username
echo "Password for the user: "
passwd $username
echo "Password for the root user: "
passwd
echo "Enter the root partition: "
read rootpartition

sed -i 's/-)/--threads=0 -)/g; s/gzip/pigz/g; s/bzip2/pbzip2/g; s/#MAKEFLAGS/MAKEFLAGS/g; s/-j2/-j$(nproc)/g' /etc/makepkg.conf
sed -i 's/#UseSyslog/UseSyslog/g; s/#Color/Color/g; s/#TotalDownload/TotalDownload/g; s/#CheckSpace/CheckSpace/g' /etc/pacman.conf

echo "LANG=en_US.UTF-8" > /etc/locale.conf
echo "KEYMAP=dvorak" > /etc/vconsole.conf
echo $hostname > /etc/hostname
echo "127.0.0.1       localhost" >> /etc/hosts
echo "::1             localhost" >> /etc/hosts
echo "127.0.1.1       $hostname.localdomain $hostname" >> /etc/hosts


echo "%wheel ALL=(ALL) ALL" >> /etc/sudoers
echo "Defaults !tty_tickets" >> /etc/sudoers

ln -sf /usr/share/zoneinfo/America/Argentina/Mendoza /etc/localtime
hwclock --systohc
sed -i "s/#en_US/en_US/g; s/#es_AR/es_AR/g" /etc/locale.gen
locale-gen

systemctl enable tlp.service bluetooth.service NetworkManager.service

# echo "Activate conservation of battery"
# echo 1 >/sys/bus/platform/drivers/ideapad_acpi/VPC2004\:00/conservation_mode

sed -i "s/^HOOKS.*/HOOKS=(base keyboard udev autodetect modconf block keymap encrypt btrfs filesystems fsck)/g" /etc/mkinitcpio.conf
sed -i 's/^MODULES.*/MODULES=(intel_agp i915)/' /etc/mkinitcpio.conf
mkinitcpio -P

bootctl --path=/boot/ install


echo -e "title\tArch Linux\nlinux\t/vmlinuz-linux\ninitrd\t/intel-ucode.img\ninitrd\t/initramfs-linux.img\noptions cryptdevice=UUID=$(blkid -s UUID -o value $rootpartition):luks:allow-discards root=/dev/mapper/luks rootflags=subvol=@ rd.luks.options=discard rw" > /boot/loader/entries/arch.conf

echo -e "title\tArch Linux Zen\nlinux\t/vmlinuz-linux-zen\ninitrd\t/intel-ucode.img\ninitrd\t/initramfs-linux-zen.img\noptions cryptdevice=UUID=$(blkid -s UUID -o value $rootpartition):luks:allow-discards root=/dev/mapper/luks rootflags=subvol=@ rd.luks.options=discard rw" > /boot/loader/entries/arch-zen.conf

echo -e "title\tArch Linux LTS\nlinux\t/vmlinuz-linux-lts\ninitrd\t/intel-ucode.img\ninitrd\t/initramfs-linux-lts.img\noptions cryptdevice=UUID=$(blkid -s UUID -o value $rootpartition):luks:allow-discards root=/dev/mapper/luks rootflags=subvol=@ rd.luks.options=discard rw" > /boot/loader/entries/arch-lts.conf

echo -e "default\tarch.conf\ntimeout\t3\nconsole-mode max\neditor\tno" > /boot/loader/loader.conf
