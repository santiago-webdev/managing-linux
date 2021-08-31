#!/usr/bin/env bash

rustup default stable

git clone https://aur.archlinux.org/paru.git
cd paru
makepkg -si
cd

paru -S \
    brave-bin \
    zsh-fast-syntax-highlighting \
    zsh-autopair-git \
    nerd-fonts-fira-code \
    nerd-fonts-iosevka \
    nerd-fonts-jetbrains-mono \
    nerd-fonts-mononoki \
    nerd-fonts-victor-mono \

rm $0 # Self delete
