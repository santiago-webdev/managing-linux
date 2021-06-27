#!/bin/bash
set -e
kwriteconfig5 --file kwinrc --group ModifierOnlyShortcuts --key Meta "org.kde.krunner,/App,,display"
sed -i '/General/a \font=Inter, 13, -1,5,50,0,0,0,0,0' .config/krunnerrc
kwriteconfig5 --file startkderc --group General --key systemdBoot true
sudo journalctl --vacuum-size=100M
sudo journalctl --vacuum-time=2weeks

sudo mkdir /usr/share/backgrounds
sudo chmod 750 /usr/share/backgrounds
sudo chown $USER /usr/share/backgrounds
mkdir kdeconnect
mkdir -p workspace/scripts

firewall-cmd --zone=public --add-service kdeconnect --permanent
