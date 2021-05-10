#!/bin/bash

sudo pacman -S rustup \
	cmake \
	make \
	qbittorrent \
	python \
	python-pip \
	python-wheel \
	ruby \
	nodejs \
	npm \
	bat \
	exa \
	wget \
	sshfs \
	openssh \
	man \
	dash \
	zsh \
	tar \
	unzip \
	unrar \
	ntfs-3g \
	xclip \

rustup default stable

pip install pynvim

git clone https://aur.archlinux.org/paru.git
cd paru
makepkg -si
cd

paru -S systemd-boot-pacman-hook \
	neovim-git \
	neovide-git \
	brave-bin \
	librewolf-bin \
