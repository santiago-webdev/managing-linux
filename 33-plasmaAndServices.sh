#!/bin/bash

# TODO
# Change kde-applications to only needed
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

systemctl enable tlp.service bluetooth.service sddm.service

# ~/.config/kwinrc under Windows
# BorderlessMaximizedWindows=true
