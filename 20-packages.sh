#!/usr/bin/env bash

set -e

sudo pacman -S --needed \
    apparmor \
    bat \
    bluedevil \
    bluez \
    breeze breeze-gtk kde-gtk-config \
    dolphin ark \
    exa \
    firewalld \
    fzf \
    git \
    gnome-keyring \
    gwenview \
    hdparm \
    hunspell-en_us  \
    hunspell-es_ar \
    intel-media-driver \
    inter-font \
    kdegraphics-thumbnailers \
    kdeplasma-addons \
    kdialog \
    khotkeys \
    konsole \
    kscreen \
    kwallet kwalletmanager \
    libappindicator-gtk2 libappindicator-gtk3 \
    linux-zen \
    man \
    noto-fonts-emoji \
    okular \
    pipewire-alsa pipewire-pulse \
    plasma-browser-integration \
    plasma-desktop \
    plasma-disks \
    plasma-nm \
    plasma-pa \
    plasma-systemmonitor \
    plasma-wayland-session \
    plasma-workspace \
    power-profiles-daemon \
    powerdevil \
    python python-pip \
    ripgrep \
    rsync \
    sddm-kcm sddm \
    spectacle \
    ttc-iosevka \
    ttf-jetbrains-mono \
    unclutter \
    unzip zip \
    vulkan-intel \
    wget \
    wl-clipboard \
    xdg-desktop-portal xdg-desktop-portal-kde \
    zsh \

chsh -s /bin/zsh "$USER"

systemctl enable sddm.service apparmor.service bluetooth.service

systemctl enable --now firewalld.service
sudo firewall-cmd --zone=home --change-interface=wlp0s20f3 --permanent
