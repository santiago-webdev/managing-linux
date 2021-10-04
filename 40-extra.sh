#!/usr/bin/env bash

# I don't like to have stuff in my $HOME
xdg-user-dirs-update --set DESKTOP      $HOME/.local/Desktop
xdg-user-dirs-update --set DOWNLOAD     $HOME/.local/Downloads
xdg-user-dirs-update --set TEMPLATES    $HOME/.local/Templates
xdg-user-dirs-update --set PUBLICSHARE  $HOME/.local/PublicShare
xdg-user-dirs-update --set DOCUMENTS    $HOME/.local/Documents
xdg-user-dirs-update --set MUSIC        $HOME/.local/Music
xdg-user-dirs-update --set PICTURES     $HOME/.local/Pictures
xdg-user-dirs-update --set VIDEOS       $HOME/.local/Videos

rm -rf .zshrc .bash_logout Documents Downloads Music Pictures Public Templates Videos paru

sudo firewall-cmd --zone=home --change-interface=wlp0s20f3 --permanent
sudo firewall-cmd --zone=home --add-service kdeconnect --permanent

rm $0 # Self delete
