#!/bin/bash

# TODO
# Passwords and users
# Install systemd-boot
# UUID
# How variables are stored

# Parts:
# Part 0: Base Installation
# Part 1: Wiping drive
# Part 2: Creating partitions
# Part 3: Encrypt root partition
# Part 4: Give fs to partition
# Part 5: Create subvolumes
# Part 6: Mount subvolumes
# Part 7: Installing Arch Linux
# Part 8: Edit the makepkg.conf file
# Part 9: Edit the pacman.conf file
# Part 10: Installing packages
# Part 20: Update systemclock
# Part 21: Language, Keymapping, Hostname, Network manager, Users and their passwords
# Part 22: Adding secondary hard drive
# Part 23: Configuring locales
# Part 24: Installing pynvim
# Part 25: Enabling services
# Part 26: Generating initramfs
# Part 27: Setting up systemd-boot
# Part 28: Install AUR helper
# Part 29: Compiling
# Part 30: Installing AUR packages

echo "Part 0: Base Installation"
read -p "Enter passwd for encryption: " passwdforcrypt
read -p "Enter username: " nameforuser
read -p "Enter passwd for user: " passwdforuser
read -p "Enter hostname: " nameforhostname
read -p "Enter passwd for root: " passwdforroot

echo "Part 1: Wiping drive"
sgdisk --zap-all /dev/nvme0n1
# wipefs -a /dev/nvme0n1
echo "Part 2: Creating partitions"
printf "n\n1\n\n+666M\nef00\nn\n2\n\n\n\nw\ny\n" | gdisk /dev/nvme0n1
echo "Part 3: Encrypt root partition"
echo "$passwdforcrypt" | cryptsetup luksFormat /dev/nvme0n1p2
echo "$passwdforcrypt" | cryptsetup luksOpen /dev/nvme0n1p2 luks

echo "Part 4: Give fs to partition"
mkfs.vfat -F32 /dev/nvme0n1p1
mkfs.btrfs /dev/mapper/luks
echo "Part 5: Create subvolumes"
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
echo "Part 6: Mount subvolumes"
mount -o noatime,nodiratime,compress-force=zstd,space_cache=v2,discard=async,ssd,subvol=@ /dev/mapper/luks /mnt
mkdir -p /mnt/{home,var/cache/pacman/pkg,srv,log,tmp,btrfs,boot}
mount -o noatime,nodiratime,compress-force=zstd,space_cache=v2,discard=async,ssd,subvol=@home /dev/mapper/luks /mnt/home
mount -o noatime,nodiratime,compress-force=zstd,space_cache=v2,discard=async,ssd,subvol=@pkg /dev/mapper/luks /mnt/var/cache/pacman/pkg
mount -o noatime,nodiratime,compress-force=zstd,space_cache=v2,discard=async,ssd,subvol=@srv /dev/mapper/luks /mnt/srv
mount -o noatime,nodiratime,compress-force=zstd,space_cache=v2,discard=async,ssd,subvol=@log /dev/mapper/luks /mnt/log
mount -o noatime,nodiratime,compress-force=zstd,space_cache=v2,discard=async,ssd,subvol=@tmp /dev/mapper/luks /mnt/tmp
mount -o noatime,nodiratime,compress-force=zstd,space_cache=v2,discard=async,ssd,subvolid=5 /dev/mapper/luks /mnt/btrfs
mount /dev/nvme0n1p1 /mnt/boot

echo "Part 7: Installing Arch Linux"
yes '' | pacstrap /mnt base base-devel
genfstab -U /mnt >> /mnt/etc/fstab
echo "Configuring new system"
arch-chroot /mnt /bin/bash << EOF
echo "Part 8: Edit the makepkg.conf file"
sed -i 's/-)/--threads=0 -)/g; s/gzip/pigz/g; s/bzip2/pbzip2/g; s/#MAKEFLAGS/MAKEFLAGS/g; s/-j2/-j$(nproc)/g' /etc/makepkg.conf
echo "Part 9: Edit the pacman.conf file"
sed -i 's/#UseSyslog/UseSyslog/g; s/#Color/Color/g; s/#TotalDownload/TotalDownload/g; s/#CheckSpace/CheckSpace/g' /etc/pacman.conf

echo "Part 10: Installing packages"
sudo pacman -Syu git \
linux-zen \
linux-lts \
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
plasma \
plasma-wayland-protocols \
plasma-wayland-session \
kde-applications \
krusader \
breeze-gtk \
libappindicator-gtk2 \
libappindicator-gtk3 \
kde-gtk-config \
xdg-desktop-portal \
xdg-desktop-portal-kde \
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

echo "Part 11: Update systemclock"
timedatectl set-ntp true
sleep 1

echo "Part 12: Language, Keymapping, Hostname, Network manager, Users and their passwords"
echo "LANG=en_US.UTF-8" > /etc/locale.conf
echo "KEYMAP=dvorak" > /etc/vconsole.conf
echo "$nameforhostname" > /etc/hostname
echo -e "127.0.0.1\tlocalhost\n::1\t\tlocalhost\n127.0.1.1\t$nameforhosname.localdomain\t$nameforhosname" > /etc/hosts

useradd -m -g users -G wheel,games,power,optical,storage,scanner,lp,audio,video,input,adm,users -s /bin/zsh $nameforuser

echo -en "$passwdforuser\n$passwdforuser" | passwd $nameforuser
echo -en "$passwdforroot\n$passwdforroot" | passwd

echo "%wheel ALL=(ALL) ALL" >> /etc/sudoers
echo "Defaults !tty_tickets" >> /etc/sudoers

echo "Part 13: Adding secondary hard drive"
mkdir /datos
# echo -e "# /datos\nUUID=084c5be3-ad98-4203-ad97-44b68b483901\t/datos\t\text4\t\tdefaults\t0\t2" > /etc/fstab

echo "Part 14: Configuring locales"
ln -sf /usr/share/zoneinfo/America/Argentina/Mendoza /etc/localtime
sleep 1
hwclock --systohc
sleep 1
sed -i "s/#en_US/en_US/g; s/#es_AR/es_AR/g" /etc/locale.gen
sleep 1
locale-gen
sleep 1

echo "Part 15: Installing pynvim"
pip install pynvim
sleep 1

echo "Part 16: Enabling services"
systemctl enable NetworkManager.service tlp.service sddm.service bluetooth.service

# echo "Activate conservation of battery"
# echo 1 >/sys/bus/platform/drivers/ideapad_acpi/VPC2004\:00/conservation_mode

echo "Part 17: Generating initramfs"
sed -i "s/^HOOKS.*/HOOKS=(base keyboard udev autodetect modconf block keymap encrypt btrfs filesystems fsck)/g" /etc/mkinitcpio.conf
sed -i 's/^MODULES.*/MODULES=(intel_agp i915)/' /etc/mkinitcpio.conf

mkinitcpio -P

echo "Part 18: Setting up systemd-boot"
bootctl --path=/boot install
/boot/loader/entries/arch.conf
echo -e "title\tArch Linux\nlinux\t/vmlinuz-linux\ninitrd\t/intel-ucode.img\ninitrd\t/initramfs-linux.img\noptions cryptdevice=UUID=:luks:allow-discards root=/dev/mapper/luks rootflags=subvol=@ rd.luks.options=discard rw" > /boot/loader/entries/arch.conf

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

# echo "Setting up autologin"
# sudo mkdir -p /etc/sddm.conf.d/
# sudo touch /etc/sddm.conf.d/autologin.conf
# sudo tee -a /etc/sddm.conf.d/autologin.conf << EOF
# [Autologin]
# User=$USER
# Session=plasmawayland.desktop
# EOF

echo "Part 19: Install AUR helper"
git clone https://aur.archlinux.org/paru.git
cd paru
echo "Part 20: Compiling"
makepkg -si
cd
rm -rf paru

echo "Part 21: Installing AUR packages"
paru -Syu nerd-fonts-fantasque-sans-mono \
nerd-fonts-hack \
nerd-fonts-iosevka \
nerd-fonts-jetbrains-mono \
nerd-fonts-mononoki \
nerd-fonts-roboto-mono \
nerd-fonts-source-code-pro \
nerd-fonts-ubuntu-mono \
kwin-scripts-krohnkite-git \
neovide-git \
neovim-git \
lightly-git \
cherry-kde-theme \
plasma-theme-moe-git \
zsh-autopair-git \
zsh-completions-git \
zsh-fast-syntax-highlighting-git \
systemd-boot-pacman-hook \

# echo "Downloading and running base script"
# wget to my repo
# chmod +x thescript
# sh ./thescript
EOF
