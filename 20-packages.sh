#!/usr/bin/env bash

set -e

sudo pacman -Syu git rsync curl

git clone https://github.com/santigo-zero/Dotfiles.git
rsync --recursive --verbose --exclude '.git' --exclude 'README.md' Dotfiles/ $HOME
rm -rf Dotfiles

sudo pacman -S --needed \
    apparmor \
    ark \
    base \
    base-devel \
    bat \
    bluedevil \
    bluez \
    bluez-utils \
    breeze \
    breeze-gtk \
    btrfs-progs \
    cmake \
    ctags \
    curl \
    dash \
    dolphin \
    efibootmgr \
    exa \
    filelight \
    firewalld \
    fzf \
    git \
    gwenview \
    intel-media-driver \
    intel-ucode \
    inter-font \
    jdk-openjdk \
    kactivitymanagerd \
    kalarm \
    kate \
    kcalc \
    kcron \
    kde-cli-tools \
    kde-gtk-config \
    kdeconnect \
    kdegraphics-thumbnailers \
    kdeplasma-addons \
    kdialog \
    khotkeys \
    kinfocenter \
    kitty \
    kmenuedit \
    konsole \
    kscreen \
    kscreenlocker \
    ksshaskpass \
    ksystemstats \
    kwallet-pam \
    kwalletmanager \
    kwayland-integration \
    kwayland-server \
    kwin \
    layer-shell-qt \
    libappindicator-gtk2 \
    libappindicator-gtk3 \
    libkscreen \
    libksysguard \
    libvdpau-va-gl \
    linux \
    linux-firmware \
    linux-lts \
    linux-zen \
    lua \
    make \
    man \
    meson \
    milou \
    mpv \
    neovim \
    networkmanager \
    ninja \
    nodejs \
    noto-fonts-cjk \
    noto-fonts-emoji \
    npm \
    ntfs-3g \
    okular \
    openssh \
    otf-overpass \
    partitionmanager \
    pipewire \
    pipewire-alsa \
    pipewire-pulse \
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
    python \
    python-pip \
    python-wheel \
    qbittorrent \
    ripgrep \
    rsync \
    rustup \
    sddm \
    sddm-kcm \
    spectacle \
    sshfs \
    systemsettings \
    tlp \
    ttf-dejavu \
    unclutter \
    unrar \
    vulkan-intel \
    wget \
    wl-clipboard \
    xdg-desktop-portal \
    xdg-desktop-portal-kde \
    yakuake \
    youtube-dl \
    zsh \
    zsh-autosuggestions \
    zsh-completions \

systemctl enable bluetooth.service sddm.service apparmor.service firewalld.service

curl -O https://raw.githubusercontent.com/santigo-zero/csjarchlinux/master/30-drive.sh
chmod +x 30-drive.sh
curl -O https://raw.githubusercontent.com/santigo-zero/csjarchlinux/master/40-extra.sh
chmod +x 40-extra.sh

echo -e "For the 30-drive.sh script, do you want to: \n"
read -p "skip, wipe or add?" use_script
case "$use_script" in
    add)
        ./30-drive.sh add
        ;;
    wipe)
        ./30-drive.sh wipe
        ;;
    * | skip)
        echo "Skipping"
        ;;
esac

export RUSTUP_HOME=$HOME/.local/share/rustup

rustup default stable

git clone https://aur.archlinux.org/paru.git
cd paru
makepkg -si
cd

paru -S \
    brave-bin \
    zsh-fast-syntax-highlighting \
    nerd-fonts-fira-code \
    nerd-fonts-iosevka \
    nerd-fonts-jetbrains-mono \
    nerd-fonts-mononoki \
    nerd-fonts-victor-mono \

echo "Restart the machine and then execute the number 40 script"

rm $0 # Self delete
