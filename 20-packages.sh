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
		krusader \
		breeze-gtk \
		libappindicator-gtk2 \
		libappindicator-gtk3 \
		kde-gtk-config \
		xdg-desktop-portal \
		xdg-desktop-portal-kde \
		dolphin \
		kde-cli-tools \
		ffmpegthumbs \
		kdegraphics-thumbnailers \
		kgpg \
		purpose \
		keditbookmarks \
		gwenview \
		qt5-imageformats \
		kimageformats \
		ark \
		p7zip \
		unarchiver \
		lzop \
		lrzip \
		kdeconnect \
		qt5-tools \
		clang \
		kate \
		spectacle \
		filelight \
		juk \
		akregator \
		kdepim-addons \
		kwalletmanager \
		ktimer \
		kalarm \
		kontrast \
		konsole \
		kompare \
		okular \
		kfind \
		kdialog \
		kdenetwork-filesharing \
		partitionmanager \
		kcolorchooser \
		kcalc \
		
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
		
else
	echo "Not installing AUR packages"
fi

chsh -s /bin/zsh
cd
git clone https://github.com/santiagogonzalezbogado/Dotfiles
