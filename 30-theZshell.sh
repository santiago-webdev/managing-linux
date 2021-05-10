#!/bin/bash

sudo pacman -S z \
	zsh-autosuggestions \

paru -S zsh-autopair-git \
	zsh-completions-git \
	zsh-fast-syntax-highlighting-git \

chsh -s /bin/zsh
cd
git clone https://github.com/santiagogonzalezbogado/Dotfiles
cd Dotfiles
cp .zshrc .zshenv ..
