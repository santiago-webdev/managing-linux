#!/usr/bin/env bash

rustup default stable

git clone https://aur.archlinux.org/paru.git
cd paru || exit
makepkg -si
cd "$HOME" || exit

rm "$0" # Self delete
