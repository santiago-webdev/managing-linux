#!/usr/bin/env bash

sudo pacman -Syu --noconfirm --needed zsh

# This changes the default shell to zsh.
[[ ! $(basename "$SHELL") == 'zsh' ]] && chsh -s /bin/zsh "$USER"
