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
	jdk-openjdk \
	linux-lts \
	linux-zen \
	lua \
	make \
	meson \
	mpv \
	neovim \
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
	zsh \
	zsh-autosuggestions \
	zsh-completions \

chsh -s /bin/zsh $USER

rm $0 # Self delete
