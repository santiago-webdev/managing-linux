#!/usr/bin/env bash

set -e

# # Install flatpak
# sudo pacman -S --noconfirm --needed flatpak flatpak-kcm

# Add flathub repo
flatpak --user remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak --user remote-add --if-not-exists kdeapps --from https://distribute.kde.org/kdeapps.flatpakrepo

flatpak --user update --appstream
flatpak --user -y upgrade

flatpak install --user --assumeyes flathub \
  com.brave.Browser \
  com.discordapp.Discord \
  com.google.Chrome \
  im.riot.Riot \
  md.obsidian.Obsidian \
  org.mozilla.Thunderbird \
  org.mozilla.firefox \
  org.qbittorrent.qBittorrent \

  # us.zoom.Zoom \
