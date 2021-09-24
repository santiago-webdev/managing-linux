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
    zsh-vi-mode \

rm $0 # Self delete
