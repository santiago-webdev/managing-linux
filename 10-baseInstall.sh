#!/bin/bash

timedatectl set-ntp true
sleep 3

sgdisk --zap-all /dev/nvme0n1
# wipefs -a /dev/nvme0n1
printf "n\n1\n\n+666M\nef00\nn\n2\n\n\n\nw\ny\n" | gdisk /dev/nvme0n1
cryptsetup luksFormat /dev/nvme0n1p2
cryptsetup luksOpen /dev/nvme0n1p2 luks

mkfs.vfat -F32 /dev/nvme0n1p1
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
mount -o noatime,nodiratime,compress-force=zstd,space_cache=v2,discard=async,ssd,subvol=@ /dev/mapper/luks /mnt
mkdir -p /mnt/{home,var/cache/pacman/pkg,srv,log,tmp,btrfs,boot}
mount -o noatime,nodiratime,compress-force=zstd,space_cache=v2,discard=async,ssd,subvol=@home /dev/mapper/luks /mnt/home
mount -o noatime,nodiratime,compress-force=zstd,space_cache=v2,discard=async,ssd,subvol=@pkg /dev/mapper/luks /mnt/var/cache/pacman/pkg
mount -o noatime,nodiratime,compress-force=zstd,space_cache=v2,discard=async,ssd,subvol=@srv /dev/mapper/luks /mnt/srv
mount -o noatime,nodiratime,compress-force=zstd,space_cache=v2,discard=async,ssd,subvol=@log /dev/mapper/luks /mnt/log
mount -o noatime,nodiratime,compress-force=zstd,space_cache=v2,discard=async,ssd,subvol=@tmp /dev/mapper/luks /mnt/tmp
mount -o noatime,nodiratime,compress-force=zstd,space_cache=v2,discard=async,ssd,subvolid=5 /dev/mapper/luks /mnt/btrfs
mount /dev/nvme0n1p1 /mnt/boot

pacstrap /mnt base \
	base-devel \
	linux \
	linux-zen \
	linux-lts \
	linux-firmware \
	neovim \
	networkmanager \
	efibootmgr \
	git \
	cmake \
	make \
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

genfstab -U /mnt >> /mnt/etc/fstab

arch-chroot /mnt /bin/bash

echo "Downloading and running base script"
wget https://raw.githubusercontent.com/santiagogonzalezbogado/installationOfArchLinux/master/15-Chroot.sh
wget https://raw.githubusercontent.com/santiagogonzalezbogado/installationOfArchLinux/master/20-AURhelper.sh
chmod +x 15-Chroot.sh
chmod +x 20-AURhelper.sh
