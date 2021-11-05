#!/usr/bin/env bash

set -e

sudo pacman -S --needed \
	bat \
	cmake \
	ctags \
	curl \
	exa \
	fzf \
	git \
	hdparm \
	jdk-openjdk \
	linux-lts \
	linux-zen \
	lua \
	make \
	meson \
	mpv \
	ninja \
	nodejs \
	npm \
	openssh \
	python \
	python-pip \
	python-wheel \
	qbittorrent \
	ripgrep \
	rsync \
	rustup \
	shellcheck \
	sshfs \
	typescript \
	unclutter \
	unrar \
	unzip \
	wget \
	youtube-dl \
	zsh-autosuggestions \
	zsh-completions \

./Dotfiles/not-home.sh

rm $0 # Self delete
