#!/bin/bash

git clone https://aur.archlinux.org/paru.git
cd paru
makepkg -si
cd
rm -rf paru

paru -Syu systemd-boot-pacman-hook \
kwin-scripts-krohnkite-git \
neovide-git \
neovim-git \
lightly-git \
cherry-kde-theme \
plasma-theme-moe-git \
zsh-autopair-git \
zsh-completions-git \
zsh-fast-syntax-highlighting-git \
brave-bin \
librewolf-bin \
nerd-fonts-hack \
nerd-fonts-iosevka \
nerd-fonts-mononoki \
nerd-fonts-roboto-mono \
nerd-fonts-ubuntu-mono \
nerd-fonts-jetbrains-mono \
nerd-fonts-source-code-pro \
nerd-fonts-fantasque-sans-mono \
