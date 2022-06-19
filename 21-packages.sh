#!/usr/bin/env bash

set -e

sudo pacman -S --noconfirm --needed \
    bat \
    cmake \
    exa \
    firefox-developer-edition \
    fuse \
    fzf \
    git \
    gnome-keyring \
    gwenview \
    hdparm \
    linux-zen \
    man \
    noto-fonts-emoji \
    python python-pip \
    ripgrep \
    rsync \
    unzip zip \
    vi \
    wget \
    wl-clipboard \
    zsh \

chsh -s /bin/zsh "$USER"
