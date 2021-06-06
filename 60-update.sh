#!/bin/bash
set -e
sudo pacman -Syyuu
echo $?
paru -Sua
echo $?
pip install -U pip
echo $?
sudo npm install -g npm@latest
echo $?
