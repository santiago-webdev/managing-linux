#!/usr/bin/env bash

# Check if the script is being runned as root
WHOAMI=$(id -u)
if [[ $WHOAMI -eq 0 ]]; then
	echo 'Run this as your normal user'
	exit
else
	echo "Running as $USER"
fi

sudo pacman -S podman toolbox
# sudo pacman -S docker
# systemctl enable --now docker.service

# Check if running unprivileged user is possible
KERNEL_PRIVILEGES=$( sysctl kernel.unprivileged_userns_clone | awk '{ printf  "%10s\n", $3 }' )
if [[ $KERNEL_PRIVILEGES -eq 1 ]]; then
	echo 'You have the right privileges, skipping'
else
	sudo sysctl kernel.unprivileged_userns_clone=1
fi

# Adding configs to podman
sudo sed -i '/An array/a unqualified-search-registries = ["registry.fedoraproject.org", "registry.access.redhat.com", "docker.io"]' /etc/containers/registries.conf
sudo tee -a /etc/containers/registries.conf <<EOT                                                                                                                          ❰130❱ 
[[registry]]
location="localhost:5000"
insecure=true
EOT

# Rootless podman (This is also necessary for rootless toolbox)
sudo touch /etc/subuid /etc/subgid
sudo usermod --add-subuids 100000-165535 --add-subgids 100000-165535 "$USER"
