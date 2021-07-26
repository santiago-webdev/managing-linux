#!/usr/bin/env bash

set -e

sudo pacman -Syu

sudo pacman -S --needed \
    git \
    networkmanager \
    efibootmgr \
    btrfs-progs \
    wget \
    base \
    base-devel \
    linux \
    linux-firmware \
    intel-ucode \
    neovim \
    zsh \
    rsync \
    wget \
    rustup \
    intel-media-driver \
    intel-ucode \
    vulkan-intel \
    jdk-openjdk \
    lua \
    nodejs \
    npm \
    bat \
    make \
    cmake \
    man \
    python \
    python-pip \
    python-wheel \
    ntfs-3g \
    tlp \
    dash \
    z \
    zsh \
    zsh-autosuggestions \
    zsh-completions \
    zsh-history-substring-search \
    qbittorrent \
    firewalld \
    noto-fonts-cjk \
    noto-fonts-emoji \
    inter-font \
    otf-overpass \
    exa \
    unrar \
    ripgrep \
    apparmor \
    youtube-dl \
    filelight \
    spectacle \
    gwenview \
    kactivitymanagerd \
    kalarm \
    kate \
    kcalc \
    kcron \
    kde-cli-tools \
    kde-gtk-config \
    kde-gtk-config \
    kdeconnect \
    kdegraphics-thumbnailers \
    kdeplasma-addons \
    kdialog \
    khotkeys \
    kinfocenter \
    kmenuedit \
    konsole \
    yakuake \
    kscreen \
    kscreenlocker \
    ksshaskpass \
    openssh \
    sshfs \
    ksystemstats \
    kwallet-pam \
    kwalletmanager \
    kwayland-integration \
    kwayland-server \
    kwin \
    layer-shell-qt \
    libkscreen \
    libksysguard \
    linux-lts \
    linux-zen \
    milou \
    okular \
    partitionmanager \
    pipewire \
    pipewire-alsa \
    pipewire-pulse \
    libappindicator-gtk2 \
    libappindicator-gtk3 \
    xdg-desktop-portal \
    xdg-desktop-portal-kde \
    dolphin \
    ark \
    breeze \
    breeze-gtk \
    bluedevil \
    bluez \
    bluez-utils \
    plasma-browser-integration \
    plasma-desktop \
    plasma-disks \
    plasma-firewall \
    plasma-integration \
    plasma-nm \
    plasma-pa \
    plasma-systemmonitor \
    plasma-wayland-protocols \
    plasma-wayland-session \
    plasma-workspace \
    polkit-kde-agent \
    powerdevil \
    sddm \
    sddm-kcm \
    systemsettings \
    wl-clipboard

git clone https://github.com/santigo-zero/Dotfiles.git
rsync --recursive --verbose --exclude '.git' --exclude 'README.md' Dotfiles/ $HOME
rm -rf Dotfiles

wget https://raw.githubusercontent.com/santigo-zero/csjarchlinux/master/30-extras.sh
chmod +x 30-extras.sh

systemctl enable bluetooth.service sddm.service apparmor.service
#systemctl enable --now firewalld.service
#firewall-cmd --zone=public --add-service kdeconnect --permanent

rm $0 # Self delete
