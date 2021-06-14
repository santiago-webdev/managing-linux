#!/bin/bash
set -e
kwriteconfig5 --file kwinrc --group ModifierOnlyShortcuts --key Meta "org.kde.krunner,/App,,display"
sed -i '/General/a \font=Inter, 14, -1,5,50,0,0,0,0,0' .config/krunnerrc
kwriteconfig5 --file startkderc --group General --key systemdBoot true
sudo journalctl --vacuum-size=100M
sudo journalctl --vacuum-time=2weeks

sudo mkdir -p /etc/sddm.conf.d/
sudo touch /etc/sddm.conf.d/autologin.conf
sudo tee -a /etc/sddm.conf.d/autologin.conf << EOF
[Autologin]
User=$USER
Session=plasmawayland.desktop
EOF

 echo -e "\n[Windows]\nBorderlessMaximizedWindows=true" >> .config/kwinrc

sudo mkdir /usr/share/backgrounds
sudo chmod 750 /usr/share/backgrounds
sudo chown $USER /usr/share/backgrounds
sudo mkdir /mnt/extdrive
mkdir workspace
