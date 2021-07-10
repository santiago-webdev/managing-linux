#!/bin/bash
set -e
kwriteconfig5 --file kwinrc --group ModifierOnlyShortcuts --key Meta "org.kde.krunner,/App,,display"
kwriteconfig5 --file krunnerrc --group General --key font 'Inter, 13, -1,5,50,0,0,0,0,0'
kwriteconfig5 --file startkderc --group General --key systemdBoot true
