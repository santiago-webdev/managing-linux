#!/usr/bin/env bash

set -e

# Install flatpak
sudo pacman -S --noconfirm --needed flatpak flatpak-kcm

# Add flathub repo
flatpak --user remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak --user remote-add --if-not-exists kdeapps --from https://distribute.kde.org/kdeapps.flatpakrepo

flatpak --user update --appstream
flatpak --user -y upgrade

flatpak install --user --assumeyes flathub \
  com.google.Chrome \
  com.brave.Browser \
  org.mozilla.firefox \
  org.mozilla.Thunderbird \
  com.discordapp.Discord \

  # us.zoom.Zoom \
