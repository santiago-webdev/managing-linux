#!/usr/bin/env bash

set -e

# Installing DE, fonts, drivers and basic packages

sudo pacman -S --needed \
	apparmor \
	ark \
	base \
	base-devel \
	bluedevil \
	bluez \
	bluez-utils \
	breeze \
	breeze-gtk \
	btrfs-progs \
	dolphin \
	efibootmgr \
	filelight \
	firejail \
	firewalld \
	gnome-keyring \
	gwenview \
	hunspell-en_us  \
	hunspell-es_ar \
	imagemagick \
	intel-media-driver \
	intel-ucode \
	inter-font \
	kactivitymanagerd \
	kalarm \
	kate \
	kcalc \
	kcron \
	kde-cli-tools \
	kde-gtk-config \
	kdeconnect \
	kdegraphics-thumbnailers \
	kdeplasma-addons \
	kdialog \
	khotkeys \
	kinfocenter \
	kitty \
	kmenuedit \
	kscreen \
	kscreenlocker \
	ksshaskpass \
	ksystemstats \
	kwallet-pam \
	kwalletmanager \
	kwayland-integration \
	kwayland-server \
	kwin \
	layer-shell-qt \
	libappindicator-gtk2 \
	libappindicator-gtk3 \
	libkscreen \
	libksysguard \
	libvdpau-va-gl \
	linux \
	linux-firmware \
	man \
	milou \
	networkmanager \
	noto-fonts-cjk \
	noto-fonts-emoji \
	ntfs-3g \
	okular \
	otf-overpass \
	partitionmanager \
	pipewire \
	pipewire-alsa \
	pipewire-pulse \
	plasma-browser-integration \
	plasma-desktop \
	plasma-disks \
	plasma-firewall \
	plasma-integration \
	plasma-nm \
	plasma-pa \
	plasma-systemmonitor \
	plasma-wayland-protocols \
	plasma-wayland-session \
	plasma-workspace \
	polkit-kde-agent \
	power-profiles-daemon \
	powerdevil \
	sddm \
	sddm-kcm \
	spectacle \
	systemsettings \
	ttc-iosevka \
	ttf-dejavu \
	ttf-fira-code \
	ttf-jetbrains-mono \
	ttf-nerd-fonts-symbols \
	vulkan-intel \
	wl-clipboard \
	xdg-desktop-portal \
	xdg-desktop-portal-kde \

sudo sysctl dev.i915.perf_stream_paranoid=0 # For the browser

systemctl enable bluetooth.service sddm.service apparmor.service
systemctl enable --now firewalld.service

sudo firewall-cmd --zone=home --change-interface=wlp0s20f3 --permanent
sudo firewall-cmd --zone=home --add-service kdeconnect --permanent

curl -O https://raw.githubusercontent.com/santigo-zero/csjarchlinux/master/21-morepackages.sh
chmod +x 21-morepackages.sh

curl -O https://raw.githubusercontent.com/santigo-zero/csjarchlinux/master/25-aur.sh
chmod +x 25-aur.sh

git clone --depth=1 https://github.com/santigo-zero/Dotfiles.git
rsync --recursive --verbose --exclude '.git' --exclude 'backup.sh' --exclude 'README.md' --exclude 'not-home.sh' Dotfiles/ $HOME
cd Dotfiles && ./not-home.sh
cd
rm -rf Dotfiles

rm $0 # Self delete
