#!/usr/bin/env bash

set -e

pacman -Q netbeans
if [[ $? == 0 ]]; then
	echo "It's already installed"
else
	sudo pacman -S --noconfirm netbeans
fi

rustup default stable
pip install pynvim

git clone https://aur.archlinux.org/paru.git
cd paru
makepkg -si
cd 
rm -rf paru

paru -S \
    brave-bin \
    redhat-fonts \
    zsh-autopair-git \
    zsh-fast-syntax-highlighting \
    nerd-fonts-jetbrains-mono \
    nerd-fonts-iosevka \
    nerd-fonts-mononoki

# TODO, just add krunnerc to the Dotfiles repo
kwriteconfig5 --file krunnerrc --group General --key font 'Inter, 13, -1,5,50,0,0,0,0,0'

sudo chown $USER /data
sudo chmod 750 /data
sudo chown $USER /usr/share/wallpapers
sudo chmod 750 /usr/share/wallpapers
ln -s /data/wallpapers /usr/share/wallpapers
ln -s /data/workspace ~/workspace

firewall-cmd --zone=home --change-interface=wlp0s20f3 --permanent
firewall-cmd --zone=home --add-service kdeconnect --permanent

rm $0 # Self delete
