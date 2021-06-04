#!/bin/bash

set -e

sudo pacman -Syu

wget https://raw.githubusercontent.com/santiagogonzalezbogado/csjarchlinux/master/36-configs.sh
chmod +x 36-configs.sh

read -q -p "Install packages from the repos?" packrepos

if [[ "$packrepos" = y ]]; then
	sudo pacman -S --needed \
		git \
		tlp \
		bluez \
		bluez-utils \
		rustup \
		cmake \
		make \
		qbittorrent \
		python \
		python-pip \
		python-wheel \
		ruby \
		nodejs \
		npm \
		bat \
		exa \
		sshfs \
		openssh \
		man \
		zsh \
		tar \
		unzip \
		unrar \
		ntfs-3g \
		xclip \
		inter-font \
		noto-fonts \
		noto-fonts-cjk \
		noto-fonts-emoji \
		ttf-roboto \
		ttf-roboto-mono \
		ttf-droid \
		ttf-fira-mono \
		otf-font-awesome \
		ttf-hanazono \
		ttf-cascadia-code \
		ttf-dejavu \
		ttf-liberation \
		ttf-opensans \
		adobe-source-code-pro-fonts \
		gnu-free-fonts \
		otf-overpass \
		powerline-fonts \
		z \
		zsh-history-substring-search \
		zsh-autosuggestions \
		plasma \
		plasma-wayland-session \
		plasma-wayland-protocols \
		breeze-gtk \
		libappindicator-gtk2 \
		libappindicator-gtk3 \
		kde-gtk-config \
		xdg-desktop-portal \
		xdg-desktop-portal-kde \
		gwenview \
		ark \
		dolphin \
		krusader \
		kdeconnect \
		kate \
		kcalc \
		konsole \
		ktimer \
		kalarm \
		kwalletmanager \
		partitionmanager \
		okular \
		spectacle \
		filelight \
		juk \
		
else
	echo "Not installing packages"
fi

pip install pynvim
rustup default stable

git clone https://aur.archlinux.org/paru.git
cd paru
makepkg -si
cd

read -q -p "Install packages from the AUR?" packaur

if [[ "$packaur" = y ]]; then
	paru -S \
		brave-bin \
		nerd-fonts-hack \
		nerd-fonts-iosevka \
		nerd-fonts-mononoki \
		nerd-fonts-ubuntu-mono \
		nerd-fonts-jetbrains-mono \
		nerd-fonts-source-code-pro \
		nerd-fonts-fantasque-sans-mono \
		otf-san-francisco \
		redhat-fonts \
		zsh-autopair-git \
		zsh-completions-git \
		zsh-fast-syntax-highlighting-git \
		kwin-scripts-krohnkite-git \
		auto-cpufreq-git \
		preload \
		grml-zsh-config \
		
else
	echo "Not installing AUR packages"
fi

systemctl enable sddm.service
systemctl enable bluetooth.service
#systemctl enable tlp.service
#systemctl enable auto-cpufreq.service
systemctl enable preload.service

chsh -s /bin/zsh
cd
git clone https://github.com/santiagogonzalezbogado/Dotfiles
