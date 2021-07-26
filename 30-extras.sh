#!/usr/bin/env bash

set -e

rustup default stable
pip install pynvim

git clone https://aur.archlinux.org/paru.git
cd paru
makepkg -si
cd && rm -rf paru

paru -S \
    brave-bin \
    nerd-fonts-mononoki \
    nerd-fonts-iosevka \
    nerd-fonts-jetbrains-mono \
    kwin-script-grid-tiling-git \
    zsh-autopair-git \
    zsh-fast-syntax-highlighting-git \
    auto-cpufreq-git

sudo pacman -S netbeans

kwriteconfig5 --file kwinrc --group ModifierOnlyShortcuts --key Meta "org.kde.krunner,/App,,display"
kwriteconfig5 --file krunnerrc --group General --key font 'Inter, 13, -1,5,50,0,0,0,0,0'

rm $0 # Self delete
