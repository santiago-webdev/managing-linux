#!/usr/bin/env bash

# This script just installs cockpit on Arch Linux

sudo pacman -S --needed \
  cockpit \
  cockpit-machines \
  cockpit-pcp \
  cockpit-podman \
  iptables-nft \
  dnsmasq \
  openbsd-netcat \
  libvirt \

if ! systemctl is-active --quiet cockpit.socket; then
    systemctl enable --now cockpit.socket
fi

if ! systemctl is-active --quiet libvirtd.service; then
    systemctl enable --now libvirtd.service
fi

# Check if user is part of the libvirt group
if ! groups "$USER" | grep -q '\blibvirt\b'; then
    sudo usermod -aG libvirt "$USER"
    echo -e "User $USER has been added to the libvirt group"
fi

echo "Opening your browser at https://localhost:9090/"
xdg-open "https://localhost:9090/"
