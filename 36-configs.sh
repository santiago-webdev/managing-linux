#!/bin/bash

set -e

kwriteconfig5 --file kwinrc --group ModifierOnlyShortcuts --key Meta "org.kde.krunner,/App,,display"

sed -i '/General/a \font=Inter, 13, -1,5,50,0,0,0,0,0' .config/krunnerrc

sudo pacman -Rscn discover oxygen plasma-vault

kwriteconfig5 --file startkderc --group General --key systemdBoot true

pacman -Q neovide
if [ $? -eq 0 ]; then
    sudo sysctl dev.i915.perf_stream_paranoid=0
fi

journalctl --vacuum-size=100M
journalctl --vacuum-time=2weeks

# kwin-scripts-krohnkite-git
# lightly-git
# cherry-kde-theme
# Sometime I will add this if I go to Wayland
# ~/.config/kwinrc under Windows
# BorderlessMaximizedWindows=true
# plasma-wayland-protocols
# plasma-wayland-session
