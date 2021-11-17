#!/usr/bin/env bash

# Check if the script is being runned as root
WHOAMI=$(id -u)
if [[ $WHOAMI -eq 0 ]]; then
	echo 'Run this as your normal user'
	exit
else
	echo "Running as $USER"
fi


# Check packages are installed
pacman -Q podman toolbox firejail

if [[ $? -eq 1 ]]; then
	sudo pacman -S podman toolbox docker
fi


# Check if running unprivileged user is possible
KERNEL_PRIVILEGES=$( sysctl kernel.unprivileged_userns_clone | awk '{ printf  "%10s\n", $3 }' )
if [[ $KERNEL_PRIVILEGES -eq 1 ]]; then
	echo 'You have the right privileges, skipping'
else
	sudo sysctl kernel.unprivileged_userns_clone=1
fi


# Rootless podman (This is also necessary for rootless toolbox)
sudo touch /etc/subuid /etc/subgid
sudo usermod --add-subuids 100000-165535 --add-subgids 100000-165535 "$USER"

# Enable docker
systemctl enable --now docker.service
