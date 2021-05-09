#!/bin/bash

sudo pacman -S --needed plasma \
	plasma-wayland-protocols \
	plasma-wayland-session \
	kde-applications \
	krusader \
	breeze-gtk \
	libappindicator-gtk2 \
	libappindicator-gtk3 \
	kde-gtk-config \
	xdg-desktop-portal \
	xdg-desktop-portal-kde \

paru -S plasma-theme-moe-git \
	kwin-scripts-krohnkite-git \
	lightly-git \
	cherry-kde-theme \

#kwriteconfig5 --file kwinrc --group ModifierOnlyShortcuts --key Meta "org.kde.krunner,/App,,display"

#systemctl enable tlp.service bluetooth.service sddm.service --now

#sed -i '/General/a \font=Inter, 14, -1,5,50,0,0,0,0,0' .config/krunnerrc
# ~/.config/kwinrc under Windows
# BorderlessMaximizedWindows=true
