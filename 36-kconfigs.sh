#!/bin/bash

kwriteconfig5 --file kwinrc --group ModifierOnlyShortcuts --key Meta "org.kde.krunner,/App,,display"
sleep 3
sed -i '/General/a \font=Inter, 14, -1,5,50,0,0,0,0,0' .config/krunnerrc
sudo pacman -Rscn discover oxygen plasma-vault ktorrent
