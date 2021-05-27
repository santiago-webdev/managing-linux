#!/bin/bash

wget https://raw.githubusercontent.com/santiagogonzalezbogado/csjarchlinux/master/36-kconfigs.sh
chmod +x 36-kconfigs.sh

read -p "Add secondary drive? [y/n]" secondarydrive
if [[ $secondarydrive = y ]] ; then
	sudo mkdir /datos
	sudo -s <<EOF
	echo -e "\n# /datos\nUUID=$(blkid -s UUID -o value /dev/sda1)\t/datos\t\text4\t\tdefaults\t0\t2" >> /etc/fstab
EOF
fi

sudo pacman -Syu

# Packages from Pacman
sudo pacman -S --needed - < packagesPacman.txt

rustup default stable

pip install pynvim

git clone https://aur.archlinux.org/paru.git
cd paru
makepkg -si
cd

# Packages from the AUR
paru -S - < packagesAUR.txt

chsh -s /bin/zsh
cd
git clone https://github.com/santiagogonzalezbogado/Dotfiles
cd Dotfiles
cp .zshrc .zshenv ..

journalctl --vacuum-size=100M
journalctl --vacuum-time=2weeks
systemctl enable tlp.service bluetooth.service sddm.service

# kwin-scripts-krohnkite-git
# lightly-git
# cherry-kde-theme
# Sometime I will add this if I go to Wayland
# ~/.config/kwinrc under Windows
# BorderlessMaximizedWindows=true
# plasma-wayland-protocols
# plasma-wayland-session
