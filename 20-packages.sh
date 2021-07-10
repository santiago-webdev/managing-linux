#!/bin/bash

set -e

read -p "Install packages from the repos?" packrepos
read -p "Install packages from the AUR?" packaur

sudo pacman -Syu

if [[ "$packrepos" = y ]]; then
    sudo pacman -S --needed \
        intel-media-driver \
        vulkan-intel \
        python \
        python-pip \
        python-wheel \
        java \
	lua \
        nodejs \
        npm \
        rustup \
        bat \
        make \
        cmake \
        man \
        ntfs-3g \
        tlp \
        dash \
        z \
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
        wl-clipboard \

else
    echo "Not installing packages"
fi

wget https://raw.githubusercontent.com/santigo-zero/csjarchlinux/master/36-configs.sh
chmod +x 36-configs.sh

pip install pynvim
rustup default stable

git clone https://aur.archlinux.org/paru.git
cd paru
makepkg -si
cd

if [[ "$packaur" = y ]]; then
    paru -S \
        brave-bin \
        redhat-fonts \
        nerd-fonts-mononoki \
        nerd-fonts-iosevka \
        nerd-fonts-jetbrains-mono \
        kwin-script-grid-tiling-git \
        zsh-autopair-git \
        zsh-fast-syntax-highlighting-git \
        auto-cpufreq-git \

else
    echo "Not installing AUR packages"
fi

systemctl enable bluetooth.service sddm.service tlp.service auto-cpufreq.service
# Configure firewall
systemctl enable --now firewalld.service
firewall-cmd --zone=public --add-service kdeconnect --permanent
