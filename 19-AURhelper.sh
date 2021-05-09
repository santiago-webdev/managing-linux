#!/bin/bash

sudo pacman -S rustup

rustup default stable

git clone https://aur.archlinux.org/paru.git
cd paru
makepkg -si
cd

paru -S systemd-boot-pacman-hook \
	neovim-git \
	neovide-git \
	brave-bin \
	librewolf-bin \
