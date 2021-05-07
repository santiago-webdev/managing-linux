#!/bin/bash

read -p "User: " name_user
read -p "Pass: " passwd_user
read -p "Pass: " passwd_root

sed -i 's/-)/--threads=0 -)/g; s/gzip/pigz/g; s/bzip2/pbzip2/g; s/#MAKEFLAGS/MAKEFLAGS/g; s/-j2/-j$(nproc)/g' /etc/makepkg.conf
sed -i 's/#UseSyslog/UseSyslog/g; s/#Color/Color/g; s/#TotalDownload/TotalDownload/g; s/#CheckSpace/CheckSpace/g' /etc/pacman.conf

echo "LANG=en_US.UTF-8" > /etc/locale.conf
echo "KEYMAP=dvorak" > /etc/vconsole.conf
echo "$name_hostname" > /etc/hostname
echo -e "127.0.0.1\tlocalhost\n::1\t\tlocalhost\n127.0.1.1\t$name_hostname.localdomain\t$name_hostname" > /etc/hosts

useradd -m -g users -G wheel,games,power,optical,storage,scanner,lp,audio,video,input,adm,users -s /bin/zsh $name_user

echo -e "$passwd_user\n$passwd_user" | passwd $name_user
echo -e "$passwd_root\n$passwd_root" | passwd

echo "%wheel ALL=(ALL) ALL" >> /etc/sudoers
echo "Defaults !tty_tickets" >> /etc/sudoers

# mkdir /datos
# echo -e "# /datos\nUUID=084c5be3-ad98-4203-ad97-44b68b483901\t/datos\t\text4\t\tdefaults\t0\t2" > /etc/fstab

ln -sf /usr/share/zoneinfo/America/Argentina/Mendoza /etc/localtime
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

# echo "Activate conservation of battery"
# echo 1 >/sys/bus/platform/drivers/ideapad_acpi/VPC2004\:00/conservation_mode

sed -i "s/^HOOKS.*/HOOKS=(base keyboard udev autodetect modconf block keymap encrypt btrfs filesystems fsck)/g" /etc/mkinitcpio.conf
sed -i 's/^MODULES.*/MODULES=(intel_agp i915)/' /etc/mkinitcpio.conf

mkinitcpio -P

bootctl --path=/boot install

touch /boot/loader/entries/arch.conf
touch /boot/loader/entries/arch-zen.conf
touch /boot/loader/entries/arch-lts.conf

tee -a /boot/loader/entries/arch.conf << END
title   Arch Linux
linux   /vmlinuz-linux
initrd  /intel-ucode.img
initrd  /initramfs-linux.img
options options=UUID=$(blkid -s UUID -o value /dev/nvme0n1p2):luks:allow-discards root=/dev/mapper/luks rootflags=subvol=@ rd.luks.options=discard rw
END

tee -a /boot/loader/entries/arch-zen.conf << END
title   Arch Linux Zen
linux   /vmlinuz-linux-zen
initrd  /intel-ucode.img
initrd  /initramfs-linux-zen.img
options options=UUID=$(blkid -s UUID -o value /dev/nvme0n1p2):luks:allow-discards root=/dev/mapper/luks rootflags=subvol=@ rd.luks.options=discard rw
END

tee -a /boot/loader/entries/arch-lts.conf << END
title   Arch Linux LTS
linux   /vmlinuz-linux-lts
initrd  /intel-ucode.img
initrd  /initramfs-linux-lts.img
options options=UUID=$(blkid -s UUID -o value /dev/nvme0n1p2):luks:allow-discards root=/dev/mapper/luks rootflags=subvol=@ rd.luks.options=discard rw
END

tee -a /boot/loader/loader.conf << END
default arch.conf
timeout 3
console-mode max
editor  no
END

# TODO
# Se hace el archivo kde_settings.conf???
# Se hace el archivo autologin.conf???
# Se hacen los archivos con solo instalarlo? O tengo que estar logeado?
# Si es así tengo que crear un script para despues de logearme
# echo "Enable autologin on sddm"
# sed -i "s/Session=/Session=plasma/g; s/User=/User=$nameforuser/g" /etc/sddm.conf.d/kde_settings.conf
# echo "Make krunnerc bigger in size, and change font"
# sed -i "/\General/a font=Inter, 14, -1,5,50,0,0,0,0,0" ~/.config/krunnerrc
# echo "Make super key open krunner"
# kwriteconfig5 --file kwinrc --group ModifierOnlyShortcuts --key Meta "org.kde.krunner,/App,,display"

# git clone https://aur.archlinux.org/paru.git
# cd paru
# makepkg -si
# cd
# rm -rf paru
#
# paru -Syu systemd-boot-pacman-hook \
# kwin-scripts-krohnkite-git \
# neovide-git \
# neovim-git \
# lightly-git \
# cherry-kde-theme \
# plasma-theme-moe-git \
# zsh-autopair-git \
# zsh-completions-git \
# zsh-fast-syntax-highlighting-git \
# brave-bin \
# librewolf-bin \
# nerd-fonts-hack \
# nerd-fonts-iosevka \
# nerd-fonts-mononoki \
# nerd-fonts-roboto-mono \
# nerd-fonts-ubuntu-mono \
# nerd-fonts-jetbrains-mono \
# nerd-fonts-source-code-pro \
# nerd-fonts-fantasque-sans-mono \

# echo "Downloading and running base script"
# wget to my repo
# chmod +x thescript
# sh ./thescript
# EOF
