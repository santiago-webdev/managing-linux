#!/usr/bin/env bash

# I guess it works now
# Usage
# ./40-encrypt-drive.sh wipe
# ./40-encrypt-drive.sh add-disk

mkdir_datos() {
    if [[ ! -d "/data" ]]
    then
        sudo mkdir /data
    else
        echo "The mount point /data has already been made"
    fi
}

keys() {
    sudo dd if=/dev/urandom of=/root/.keyfile bs=1024 count=4
    sudo chmod 400 /root/.keyfile
    sudo cryptsetup luksAddKey /dev/sda1 /root/.keyfile
    sudo tee -a /etc/crypttab <<EOT
cryptdata UUID=$(sudo blkid -s UUID -o value /dev/sda1) /root/.keyfile luks,discard
EOT
    sudo tee -a /etc/fstab <<EOT

# /data
UUID=$(sudo blkid -s UUID -o value /dev/mapper/cryptdata)      /data       	ext4        	defaults	0   2
EOT
}

case "${1}" in
    wipe)
        sudo wipefs --all /dev/sda
        printf "n\n\n\n\n\nw\ny\n" | sudo gdisk /dev/sda
        sudo cryptsetup luksFormat --type luks2 /dev/sda1
        sudo cryptsetup luksOpen /dev/sda1 cryptdata
        sudo mkfs.ext4 /dev/mapper/cryptdata
        ;;
    add)
        sudo cryptsetup luksOpen /dev/sda1 cryptdata
        mkdir_datos
        keys
        ;;
    *)
        echo 'You need to enter a parameter, either wipe or add'
        exit
        ;;
esac
