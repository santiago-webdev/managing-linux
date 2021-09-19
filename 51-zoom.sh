#!/usr/bin/env bash

# You need to install firejail, zoom, and if you want, apparmor.

# You also need to put this file under $HOME/.local/share/applications
# https://raw.githubusercontent.com/santigo-zero/Dotfiles/master/.local/share/applications/ZoomFirejail.desktop

# And this one on $HOME/.local/bin
# https://raw.githubusercontent.com/santigo-zero/Dotfiles/master/.local/bin/zoom-firejail

# So that you can easily execute Zoom using Firejail.  If you did everything
# above execute the script, it will enable apparmor for firejail and tell your
# DE to open all the links using the rule from the .desktop file.

cd $HOME

sudo apparmor_parser -r /etc/apparmor.d/firejail-default

xdg-mime default ZoomFirejail.desktop x-scheme-handler/zoommtg
xdg-mime default ZoomFirejail.desktop x-scheme-handler/zoomus
xdg-mime default ZoomFirejail.desktop x-scheme-handler/tel
xdg-mime default ZoomFirejail.desktop x-scheme-handler/callto
xdg-mime default ZoomFirejail.desktop x-scheme-handler/zoomphonecall

rm $0 # Self delete
