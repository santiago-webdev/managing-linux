#!/usr/bin/env bash

set -e

sudo pacman -Syu git rsync curl

git clone https://github.com/santigo-zero/Dotfiles.git
rsync --recursive --verbose --exclude '.git' --exclude 'backup.sh' --exclude 'README.md' --exclude 'not-home' Dotfiles/ $HOME
cd Dotfiles/not-home && ./global-files.sh

cd
rm -rf Dotfiles

curl -O https://raw.githubusercontent.com/santigo-zero/csjarchlinux/master/25-aur.sh
chmod +x 25-aur.sh

curl -O https://raw.githubusercontent.com/santigo-zero/csjarchlinux/master/30-drive.sh
chmod +x 30-drive.sh

curl -O https://raw.githubusercontent.com/santigo-zero/csjarchlinux/master/40-extra.sh
chmod +x 40-extra.sh

curl -O https://raw.githubusercontent.com/santigo-zero/csjarchlinux/master/50-nvim.sh
chmod +x 50-nvim.sh

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
    firejail \
    firewalld \
    fzf \
    git \
    gwenview \
    hunspell-en_us  \
    hunspell-es_ar \
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
    power-profiles-daemon \
    python \
    python-pip \
    python-wheel \
    qbittorrent \
    ripgrep \
    rsync \
    rustup \
    sddm \
    sddm-kcm \
    shellcheck \
    spectacle \
    sshfs \
    systemsettings \
    tlp \
    ttf-dejavu \
    ttf-nerd-fonts-symbols \
    ttf-jetbrains-mono \
    ttc-iosevka \
    unclutter \
    unrar \
    unzip \
    vulkan-intel \
    wget \
    wl-clipboard \
    xdg-desktop-portal \
    xdg-desktop-portal-kde \
    youtube-dl \
    zsh \
    zsh-autosuggestions \
    zsh-completions \

systemctl enable bluetooth.service sddm.service apparmor.service firewalld.service

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

rm $0 # Self delete
