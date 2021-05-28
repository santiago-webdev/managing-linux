#!/bin/bash

wget https://raw.githubusercontent.com/santiagogonzalezbogado/csjarchlinux/master/36-kconfigs.sh
wget https://raw.githubusercontent.com/santiagogonzalezbogado/csjarchlinux/master/packagesAUR.txt
wget https://raw.githubusercontent.com/santiagogonzalezbogado/csjarchlinux/master/packagesPacman.txt
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

echo "Install packages from the AUR?"
read packaur

# Packages from the AUR
if [[ "$packaur" = y ]]; then
	paru -S - < packagesAUR.txt
else
	echo = "Not installing AUR packages"
fi

chsh -s /bin/zsh
cd
git clone https://github.com/santiagogonzalezbogado/Dotfiles

systemctl enable tlp.service bluetooth.service sddm.service
