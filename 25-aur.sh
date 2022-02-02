#!/usr/bin/env bash

sudo pacman -S rustup

rustup default stable
rustup self upgrade-data

git clone --depth=1 https://aur.archlinux.org/paru.git
cd paru || exit
makepkg -si
