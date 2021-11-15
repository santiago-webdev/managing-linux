#!/usr/bin/env bash

set -e

sudo pacman -S --needed \
	adobe-source-sans-pro-fonts \
	bat \
	cmake \
	ctags \
	curl \
	exa \
	flatpak \
	fzf \
	git \
	gst-libav \
	gst-plugins-bad \
	gst-plugins-good \
	gst-plugins-ugly \
	gst-transcoder \
	gstreamer-vaapi \
	github-cli \
	hdparm \
	inter-font \
	jdk-openjdk \
	libertinus-font \
	linux-lts \
	linux-zen \
	lua \
	make \
	meson \
	mpv \
	neofetch \
	ninja \
	nodejs \
	noto-fonts-cjk \
	noto-fonts-emoji \
	npm \
	openssh \
	python \
	python-pip \
	python-wheel \
	qbittorrent \
	reflector \
	ripgrep \
	rsync \
	rustup \
	shellcheck \
	sshfs \
	terminus-font \
	ttc-iosevka \
	ttf-bitstream-vera \
	ttf-dejavu \
	ttf-droid \
	ttf-fira-code \
	ttf-fira-mono \
	ttf-fira-sans \
	ttf-freefont \
	ttf-inconsolata \
	ttf-jetbrains-mono \
	ttf-liberation \
	ttf-nerd-fonts-symbols \
	ttf-opensans \
	typescript \
	unclutter \
	unrar \
	unzip \
	wget \
	youtube-dl \
	z \
	zsh-autosuggestions \
	zsh-completions \

./Dotfiles/not-home.sh

rm "$0" # Self delete
