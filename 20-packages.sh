#!/bin/bash

sudo mkdir /datos
sudo -s <<EOF
echo -e "\n# /datos\nUUID=084c5be3-ad98-4203-ad97-44b68b483901\t/datos\t\text4\t\tdefaults\t0\t2" >> /etc/fstab
EOF

sudo pacman -S rustup \
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

rustup default stable

pip install pynvim

cd
git clone https://aur.archlinux.org/paru.git
cd paru
makepkg -si
cd

paru -S systemd-boot-pacman-hook \
	neovim-git \
	neovide-git \
	brave--bin \
	librewolf-bin \

echo "Fonts"

sudo pacman -S --needed inter-font \
	noto-fonts \
	noto-fonts-cjk \
	noto-fonts-emoji \
	ttf-roboto \
	ttf-roboto-mono \
	ttf-droid \
	ttf-fira-mono \
	ttf-font-awesome \
	otf-font-awesome \
	ttf-hanazono \
	ttf-cascadia-code \
	ttf-dejavu \
	ttf-liberation \
	ttf-opensans \
	adobe-source-code-pro-fonts \
	gnu-free-fonts \

paru -S nerd-fonts-hack \
	nerd-fonts-iosevka \
	nerd-fonts-mononoki \
	nerd-fonts-ubuntu-mono \
	nerd-fonts-jetbrains-mono \
	nerd-fonts-source-code-pro \
	nerd-fonts-fantasque-sans-mono \

echo "Installing zshell and plugins"

sudo pacman -S z \
	zsh-history-substring-search \
	zsh-autosuggestions \

paru -S zsh-autopair-git \
	zsh-completions-git \
	zsh-fast-syntax-highlighting-git \

chsh -s /bin/zsh
cd
git clone https://github.com/santiagogonzalezbogado/Dotfiles
cd Dotfiles
cp .zshrc .zshenv ..