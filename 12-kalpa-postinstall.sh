#!/usr/bin/env bash

# Change the display server to Wayland
sudo sed -i 's/DISPLAYMANAGER_XSERVER="Xorg"/DISPLAYMANAGER_XSERVER="Wayland"/g' /etc/sysconfig/displaymanager

# Autologin SDDM
echo '[Autologin]
User='"$USER"'
Session=plasmawayland' | sudo tee /etc/sddm.conf.d/autologin.conf

# Enable ZRAM
## Add "zram" to /etc/modules-load.d/zram.conf
echo "zram" | sudo tee /etc/modules-load.d/zram.conf

## Set options in /etc/modprobe.d/zram.conf
echo "options zram num_devices=1" | sudo tee /etc/modprobe.d/zram.conf

## Set the size of zram device in /etc/udev/rules.d/99-zram.rules
echo 'KERNEL=="zram0", ATTR{disksize}="12288M",TAG+="systemd"' | sudo tee /etc/udev/rules.d/99-zram.rules

## Create the systemd service file /etc/systemd/system/zram.service
sudo tee /etc/systemd/system/zram.service <<EOF
[Unit]
Description=Swap with zram
After=multi-user.target

[Service]
Type=oneshot
RemainAfterExit=true
ExecStartPre=/sbin/mkswap /dev/zram0
ExecStart=/sbin/swapon /dev/zram0
ExecStop=/sbin/swapoff /dev/zram0

[Install]
WantedBy=multi-user.target
EOF

## Enable the systemd service
sudo systemctl enable zram

# Enable tickets
sudo tee -a /etc/sudoers <<EOT
Defaults !tty_tickets
EOT

# Change the hostname
echo "Choose new hostname name, the default value being 'fedora' but you can cancel with control+c"
read -r HOSTNAME_NEW
hostnamectl set-hostname "$HOSTNAME_NEW"
