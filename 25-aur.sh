#!/usr/bin/env bash

rustup default stable

git clone https://aur.archlinux.org/paru.git
cd paru || exit
makepkg -si
cd "$HOME" || exit

paru -S \
	brave-bin \
	neovim-git \
	nvm \

rm "$0" # Self delete
