#!/bin/bash

# TODO
# Passwords and users
# Install systemd-boot
# UUID
# How variables are stored

read -p "Enter passwd for encryption: " passwdforcrypt
read -p "Enter username: " nameforuser
read -p "Enter passwd for user: " passwdforuser
read -p "Enter hostname: " nameforhostname
read -p "Enter passwd for root: " passwdforroot

timedatectl set-ntp true
sleep 1

# sgdisk --zap-all /dev/nvme0n1
# wipefs -a /dev/nvme0n1
# printf "n\n1\n\n+666M\nef00\nn\n2\n\n\n\nw\ny\n" | gdisk /dev/nvme0n1
echo "$passwdforcrypt" | cryptsetup luksFormat /dev/sda6
echo "$passwdforcrypt" | cryptsetup luksOpen /dev/sda6 luks

mkfs.vfat -F32 /dev/sda5
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
# If it's not an nvme you should delete ssd and discard options
mount -o noatime,nodiratime,compress=lzo,space_cache=v2,subvol=@ /dev/mapper/luks /mnt
mkdir -p /mnt/{home,var/cache/pacman/pkg,srv,log,tmp,btrfs,boot}
mount -o noatime,nodiratime,compress=lzo,space_cache=v2,subvol=@home /dev/mapper/luks /mnt/home
mount -o noatime,nodiratime,compress=lzo,space_cache=v2,subvol=@pkg /dev/mapper/luks /mnt/var/cache/pacman/pkg
mount -o noatime,nodiratime,compress=lzo,space_cache=v2,subvol=@srv /dev/mapper/luks /mnt/srv
mount -o noatime,nodiratime,compress=lzo,space_cache=v2,subvol=@log /dev/mapper/luks /mnt/log
mount -o noatime,nodiratime,compress=lzo,space_cache=v2,subvol=@tmp /dev/mapper/luks /mnt/tmp
mount -o noatime,nodiratime,compress=lzo,space_cache=v2,subvolid=5 /dev/mapper/luks /mnt/btrfs
mount /dev/nvme0n1p1 /mnt/boot

yes '' | pacstrap /mnt base base-devel
genfstab -U /mnt >> /mnt/etc/fstab
echo "Configuring new system"
# arch-chroot /mnt /bin/bash << EOF
sed -i 's/-)/--threads=0 -)/g; s/gzip/pigz/g; s/bzip2/pbzip2/g; s/#MAKEFLAGS/MAKEFLAGS/g; s/-j2/-j$(nproc)/g' /etc/makepkg.conf
sed -i 's/#UseSyslog/UseSyslog/g; s/#Color/Color/g; s/#TotalDownload/TotalDownload/g; s/#CheckSpace/CheckSpace/g' /etc/pacman.conf

sudo pacman -Syu git \
linux \
linux-firmware \
cmake \
make \
linux-firmware \
networkmanager \
qbittorrent \
intel-ucode \
btrfs-progs \
python \
python-pip \
python-wheel \
ruby \
nodejs \
npm \
tlp \
tlp-rdw \
bat \
exa \
wget \
sshfs \
openssh \
man \
bluez \
bluez-utils \
dash \
z \
zsh \
zsh-autosuggestions \
tar \
unzip \
unrar \
ntfs-3g \
xclip \
intel-media-driver \
vulkan-intel \
libvdpau-va-gl \
inter-font \
noto-fonts \
noto-fonts-cjk \
noto-fonts-emoji \
ttf-roboto \
ttf-roboto-mono \
ttf-droid \
ttf-fira-mono \
ttf-font-awesome \
ttf-hanazono \
ttf-cascadia-code \
ttf-dejavu \
ttf-liberation \
ttf-opensans \
adobe-source-code-pro-fonts \
gnu-free-fonts \

echo "LANG=en_US.UTF-8" > /etc/locale.conf
echo "KEYMAP=dvorak" > /etc/vconsole.conf
echo "$nameforhostname" > /etc/hostname
echo -e "127.0.0.1\tlocalhost\n::1\t\tlocalhost\n127.0.1.1\t$nameforhosname.localdomain\t$nameforhosname" > /etc/hosts

useradd -m -g users -G wheel,games,power,optical,storage,scanner,lp,audio,video,input,adm,users -s /bin/zsh $nameforuser

echo -e "$passwdforuser\n$passwdforuser" | passwd $nameforuser
echo -e "$passwdforroot\n$passwdforroot" | passwd

echo "%wheel ALL=(ALL) ALL" >> /etc/sudoers
echo "Defaults !tty_tickets" >> /etc/sudoers

mkdir /datos
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

git clone https://aur.archlinux.org/paru.git
cd paru
makepkg -si
cd
rm -rf paru

paru -Syu systemd-boot-pacman-hook \
neovim-git \
zsh-autopair-git \
zsh-completions-git \
zsh-fast-syntax-highlighting-git \
brave-bin \
librewolf-bin \
nerd-fonts-hack \
nerd-fonts-iosevka \
nerd-fonts-mononoki \
nerd-fonts-roboto-mono \
nerd-fonts-ubuntu-mono \
nerd-fonts-jetbrains-mono \
nerd-fonts-source-code-pro \
nerd-fonts-fantasque-sans-mono \

# echo "Downloading and running base script"
# wget to my repo
# chmod +x thescript
# sh ./thescript
EOF
