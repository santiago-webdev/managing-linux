#!/usr/bin/env bash

pacman -Q netbeans
if [[ $? == 0 ]]; then
	echo "It's already installed"
else
	sudo pacman -S --noconfirm netbeans
fi

sudo chown $USER /data
sudo chmod 750 /data
sudo chown $USER /usr/share/wallpapers
sudo chmod 750 /usr/share/wallpapers
ln -s /data/wallpapers /usr/share/wallpapers
ln -s /data/workspace ~/workspace
mkdir -p ~/.local/share/kservices5

rm -r .zshrc .bash_logout Documents Downloads Music Pictures Public Templates Videos paru

firewall-cmd --zone=home --change-interface=wlp0s20f3 --permanent
firewall-cmd --zone=home --add-service kdeconnect --permanent

rm $0 # Self delete
