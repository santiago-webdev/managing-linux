#!/bin/bash

git clone https://aur.archlinux.org/paru.git
cd paru
makepkg -si
cd

paru -S systemd-boot-pacman-hook \
	neovide-git \
	neovim-git \
	brave-bin \
	librewolf-bin \
