#!/usr/bin/env bash

set -e

# Install flatpak
sudo pacman -S --noconfirm --needed flatpak

# Add flathub repo
flatpak --user remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak --user remote-add --if-not-exists kdeapps --from https://distribute.kde.org/kdeapps.flatpakrepo

flatpak --user update --appstream
flatpak --user -y upgrade

flatpak install --assumeyes flathub \
  com.discordapp.Discord \
  im.riot.Riot \
  com.obsproject.Studio \
  com.brave.Browser \
  com.google.Chrome \
