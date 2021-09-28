#!/usr/bin/env bash

pacman -Q netbeans
if [[ $? == 0 ]]; then
	echo "It's already installed"
else
	sudo pacman -S --noconfirm netbeans
fi

# TODO add all the entries like this and not just delete them
# xdg-user-dirs-update --set DOWNLOAD $HOME/.local/Downloads
rm -rf .zshrc .bash_logout Documents Downloads Music Pictures Public Templates Videos paru

sudo firewall-cmd --zone=home --change-interface=wlp0s20f3 --permanent
sudo firewall-cmd --zone=home --add-service kdeconnect --permanent

rm $0 # Self delete
