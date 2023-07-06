#!/usr/bin/env bash

# This script just installs cockpit on Arch Linux

sudo pacman -S --needed \
  cockpit \
  cockpit-machines \
  cockpit-pcp \
  cockpit-podman \
  cockpit-storaged \
  udisks2 \
  dnsmasq \
  iptables-nft \
  libvirt \
  dmidecode \
  openbsd-netcat \
  virt-install \
  virt-viewer \
  qemu-full \
  qemu-emulators-full \

if ! systemctl is-active --quiet cockpit.socket; then
    systemctl enable --now cockpit.socket
fi

if ! systemctl is-active --quiet libvirtd.service; then
    systemctl enable --now libvirtd.service
fi

# Check if user is part of the libvirt group
if ! groups "$USER" | grep -q '\blibvirt\b'; then
    sudo usermod -aG libvirt "$USER"
fi

if ! groups "$USER" | grep -q '\bkvm\b'; then
    sudo usermod -aG kvm "$USER"
fi

sudo virsh net-define /etc/libvirt/qemu/networks/default.xml
sudo virsh net-start default
sudo virsh net-autostart default

xdg-open "https://localhost:9090/"

echo "Don't forget to chmod o+rx the directory containing your images"
