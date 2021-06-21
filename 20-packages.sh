#!/bin/bash

set -e

sudo pacman -Syu

wget https://raw.githubusercontent.com/santiagogonzalezbogado/csjarchlinux/master/36-configs.sh
chmod +x 36-configs.sh

read -p "Install packages from the repos?" packrepos

if [[ "$packrepos" = y ]]; then
	sudo pacman -S --needed \
		git \
		tlp \
		bluez \
		bluez-utils \
		intel-media-driver \
		vulkan-intel \
		linux-zen \
		linux-lts \
		rustup \
		cmake \
		make \
		qbittorrent \
		python \
		python-pip \
		python-wheel \
		nodejs \
		npm \
		bat \
		exa \
		sshfs \
		openssh \
		ntfs-3g \
		wl-clipboard \
		inter-font \
		noto-fonts-cjk \
		noto-fonts-emoji \
		otf-overpass \
		firefox \
		zsh \
		z \
		zsh-history-substring-search \
		zsh-autosuggestions \
		pipewire \
		pipewire-alsa \
		pipewire-pulse \
		firewalld \
		bluedevil \
		breeze \
		breeze-gtk \
		xcursor-bluecurve \
		kactivitymanagerd \
		kde-cli-tools \
		kde-gtk-config \
		kdeplasma-addons \
		khotkeys \
		kinfocenter \
		kmenuedit \
		kscreen \
		kscreenlocker \
		ksshaskpass \
		ksystemstats \
		kwallet-pam \
		kwalletmanager \
		kwayland-integration \
		kwayland-server \
		plasma-wayland-session \
		plasma-wayland-protocols \
		kwin \
		filelight \
		partitionmanager \
		kcron \
		kcalc \
		kalarm \
		kdegraphics-thumbnailers \
		layer-shell-qt \
		libkscreen \
		libksysguard \
		milou \
		plasma-browser-integration \
		plasma-desktop \
		plasma-disks \
		plasma-firewall \
		plasma-integration \
		plasma-nm \
		plasma-pa \
		plasma-systemmonitor \
		plasma-workspace \
		polkit-kde-agent \
		powerdevil \
		sddm \
		sddm-kcm \
		systemsettings \
		xdg-desktop-portal \
		xdg-desktop-portal-kde \
		ark \
		libappindicator-gtk2 \
		libappindicator-gtk3 \
		kde-gtk-config \
		konsole \
		kdeconnect \
		dolphin \
		kate \
		okular \
		gwenview \
		
else
	echo "Not installing packages"
fi

pip install pynvim
rustup default stable

git clone https://aur.archlinux.org/paru.git
cd paru
makepkg -si
cd

read -p "Install packages from the AUR?" packaur

if [[ "$packaur" = y ]]; then
	paru -S \
		brave-bin \
		redhat-fonts \
		nerd-fonts-mononoki \
		nerd-fonts-iosevka \
		nerd-fonts-jetbrains-mono \
		zsh-autopair-git \
		zsh-completions-git \
		zsh-fast-syntax-highlighting-git \
		auto-cpufreq-git \
		grml-zsh-config \
		
else
	echo "Not installing AUR packages"
fi

systemctl enable bluetooth.service sddm.service firewalld.service
systemctl enable tlp.service auto-cpufreq.service

chsh -s /bin/zsh
cd
git clone https://github.com/santiagogonzalezbogado/Dotfiles
