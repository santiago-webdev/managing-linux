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


mount -o noatime,nodiratime,compress-force=zstd,space_cache=v2,discard=async,subvol=@ /dev/mapper/luks /mnt
mkdir -p /mnt/{home,var/cache/pacman/pkg,srv,log,tmp,btrfs,boot}
mount -o noatime,nodiratime,compress-force=zstd,space_cache=v2,discard=async,subvol=@home /dev/mapper/luks /mnt/home
mount -o noatime,nodiratime,compress-force=zstd,space_cache=v2,discard=async,subvol=@pkg /dev/mapper/luks /mnt/var/cache/pacman/pkg
mount -o noatime,nodiratime,compress-force=zstd,space_cache=v2,discard=async,subvol=@srv /dev/mapper/luks /mnt/srv
mount -o noatime,nodiratime,compress-force=zstd,space_cache=v2,discard=async,subvol=@log /dev/mapper/luks /mnt/log
mount -o noatime,nodiratime,compress-force=zstd,space_cache=v2,discard=async,subvol=@tmp /dev/mapper/luks /mnt/tmp
mount -o noatime,nodiratime,compress-force=zstd,space_cache=v2,discard=async,subvolid=5 /dev/mapper/luks /mnt/btrfs
mount /dev/nvme0n1p1 /mnt/boot

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
	cmake \
	make \
	qbittorrent \
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
	zsh \
	tar \
	unzip \
	unrar \
	ntfs-3g \
	xclip \


genfstab -U /mnt >> /mnt/etc/fstab
arch-chroot /mnt /bin/bash
wget https://raw.githubusercontent.com/santiagogonzalezbogado/installationOfArchLinux/master/13-Chroot.sh
chmod +x 13-Chroot.sh
