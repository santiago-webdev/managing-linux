#!/bin/bash

# TODO
# This part works for now but it needs manual work when adding a disk

wget https://raw.githubusercontent.com/santiagogonzalezbogado/csjarchlinux/master/36-kconfigs.sh
chmod +x 36-kconfigs.sh

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
	brave-bin \
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
	otf-san-franscisco \

echo "Installing zshell and plugins"

sudo pacman -S z \
	zsh-history-substring-search \
	zsh-autosuggestions \

paru -S zsh-autopair-git \
	zsh-completions-git \
	zsh-fast-syntax-highlighting-git \

# TODO
# Add Neovim install script
chsh -s /bin/zsh
cd
git clone https://github.com/santiagogonzalezbogado/Dotfiles
cd Dotfiles
cp .zshrc .zshenv ..

# TODO
# Change kde-applications to only needed
sudo pacman -S --needed plasma \
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
	packagekit-qt5 \
	keditbookmarks \
	ebook-tools \
	kdegraphics-mobipocket \
	libzip \
	khtml \
	chmlib \
	calligra \
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
	textlab \
	spectacle \
	filelight \
	juk \
	akregator \
	kdepim-addons \
	kdewallet \
	kwalletmanager \
	ktimer \
	kalarm \
	kontrast \
	kompare \
	kfind \
	kdenetwork-filesharing \
	partitionmanager \
	kcolorchooser \
	kcalc \
	markdownpart \

#kde-applications

paru -S kwin-scripts-krohnkite-git

# plasma-theme-moe-git
# kwin-scripts-krohnkite-git
# lightly-git
# cherry-kde-theme

journalctl --vacuum-size=100M
journalctl --vacuum-time=2weeks
systemctl enable tlp.service bluetooth.service sddm.service

# Sometime I will add this if I go to Wayland
# ~/.config/kwinrc under Windows
# BorderlessMaximizedWindows=true
# plasma-wayland-protocols
# plasma-wayland-session
