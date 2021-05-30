#!/bin/bash

wget https://raw.githubusercontent.com/santiagogonzalezbogado/csjarchlinux/master/36-configs.sh
chmod +x 36-configs.sh

read -p "Add secondary drive? [y/n]" secondarydrive
if [[ $secondarydrive = y ]] ; then
	sudo mkdir /datos
	sudo -s <<EOF
	echo -e "\n# /datos\nUUID=$(blkid -s UUID -o value /dev/sda1)\t/datos\t\text4\t\tdefaults\t0\t2" >> /etc/fstab
EOF
fi

sudo pacman -Syu

# Packages from Pacman
echo "Install packages from the repos?"
read packrepos

if [[ "$packrepos" = y ]]; then
	sudo pacman -S --needed - < packagesPacman.txt
else
	echo = "Not installing packages"
fi

[ "$?" -eq 0 ] && echo "test"

pip install pynvim
rustup default stable

git clone https://aur.archlinux.org/paru.git
cd paru
makepkg -si
cd

# Packages from the AUR
echo "Install packages from the AUR?"
read packaur

if [[ "$packaur" = y ]]; then
	paru -S - < packagesAUR.txt
else
	echo = "Not installing AUR packages"
fi

chsh -s /bin/zsh
cd
git clone https://github.com/santiagogonzalezbogado/Dotfiles

systemctl enable tlp.service bluetooth.service sddm.service
