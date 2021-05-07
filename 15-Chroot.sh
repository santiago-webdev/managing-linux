#!/bin/bash

sed -i 's/-)/--threads=0 -)/g; s/gzip/pigz/g; s/bzip2/pbzip2/g; s/#MAKEFLAGS/MAKEFLAGS/g; s/-j2/-j$(nproc)/g' /etc/makepkg.conf
sed -i 's/#UseSyslog/UseSyslog/g; s/#Color/Color/g; s/#TotalDownload/TotalDownload/g; s/#CheckSpace/CheckSpace/g' /etc/pacman.conf

echo "LANG=en_US.UTF-8" > /etc/locale.conf
echo "KEYMAP=dvorak" > /etc/vconsole.conf
echo "" > /etc/hostname
echo -e "127.0.0.1\tlocalhost\n::1\t\tlocalhost\n127.0.1.1\t<name_hostname>.localdomain\t<name_hostname>" > /etc/hosts

useradd -m -g users -G wheel,games,power,optical,storage,scanner,lp,audio,video,input,adm,users -s /bin/zsh

passwd kim
passwd

echo "%wheel ALL=(ALL) ALL" >> /etc/sudoers
echo "Defaults !tty_tickets" >> /etc/sudoers

# mkdir /datos
# echo -e "# /datos\nUUID=084c5be3-ad98-4203-ad97-44b68b483901\t/datos\t\text4\t\tdefaults\t0\t2" > /etc/fstab

ln -sf /usr/share/zoneinfo/Region/city /etc/localtime
sleep 1
hwclock --systohc
sleep 1
sed -i "s/#en_US/en_US/g; s/#es_AR/es_AR/g" /etc/locale.gen
sleep 1
locale-gen
sleep 1

pip install pynvim
sleep 1

systemctl enable NetworkManager.service tlp.service sddm.service bluetooth.service
sleep 1

# echo "Activate conservation of battery"
# echo 1 >/sys/bus/platform/drivers/ideapad_acpi/VPC2004\:00/conservation_mode

sed -i "s/^HOOKS.*/HOOKS=(base keyboard udev autodetect modconf block keymap encrypt btrfs filesystems fsck)/g" /etc/mkinitcpio.conf
sed -i 's/^MODULES.*/MODULES=(intel_agp i915)/' /etc/mkinitcpio.conf

mkinitcpio -P
