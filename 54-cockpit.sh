#!/usr/bin/env bash

# This script just installs cockpit on Arch Linux

sudo pacman -S cockpit cockpit-machines cockpit-pcp cockpit-podman packagekit

systemctl enable --now cockpit.socket

echo "Now you can connect to https://localhost:9090/"
