#!/usr/bin/env bash

set -e

sudo pacman -S --noconfirm --needed \
  apparmor \
  bluedevil \
  bluez \
  breeze \
  breeze-gtk \
  dolphin ark \
  firewalld \
  gnome-settings-daemon \
  gsettings-desktop-schemas \
  gsettings-qt \
  hunspell-en_us  \
  hunspell-es_ar \
  intel-media-driver \
  kde-gtk-config \
  kdegraphics-thumbnailers \
  kdeplasma-addons \
  kdialog \
  khotkeys \
  konsole \
  kscreen \
  kwallet kwalletmanager \
  libappindicator-gtk2 \
  libappindicator-gtk3 \
  okular \
  pipewire-alsa \
  pipewire-pulse \
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
  qt5-imageformats \
  sddm \
  sddm-kcm \
  spectacle \
  vulkan-intel \
  xdg-desktop-portal \
  xdg-desktop-portal-kde

systemctl enable sddm.service apparmor.service bluetooth.service

# Open krunner using Meta
kwriteconfig5 --file kwinrc --group ModifierOnlyShortcuts --key Meta "org.kde.krunner,/App,,toggleDisplay"
# Don't use title bars in maximized windows
kwriteconfig5 --file ~/.config/kwinrc --group Windows --key BorderlessMaximizedWindows true
# qdbus org.kde.KWin /KWin reconfigure # This hot-reloads most settings in Plasma.
