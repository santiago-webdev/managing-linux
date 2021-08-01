#!/usr/bin/env bash

# TODO add this to the README.md
# TODO All scripts start with a number on the repo but use lowercase, snake_case convention when no the system
# This is a basic script that I made so that if I reinstall Arch Linux, I just need to run this to add the second
# HDD drive that I have, to either wipe it, or just add it. For selecting the drive, I know
# it's very ugly and not very specif but it works.
# Usage
# ./40-encrypt-drive.sh wipe
# ./40-encrypt-drive.sh add-disk

set -e

drive=sda
drive_partition=sda1

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
    sudo cryptsetup luksAddKey /dev/$drive_partition /root/.keyfile
    drive_uuid=$(blkid -s UUID -o value /dev/$drive_partition)
    sudo tee -a /etc/crypttab <<EOT
cryptdata UUID=$drive_uuid /.keyfile luks,discard
EOT
}

case "${1}" in
    wipe)
        sudo wipefs --all /dev/$drive # Cleans the drive
        printf "n\n\n\n\n\nw\ny\n" | sudo gdisk /dev/$drive
        sudo cryptsetup luksFormat --type luks2 /dev/$drive_partition
        sudo cryptsetup luksOpen /dev/$drive_partition cryptdata
        sudo mkfs.ext4 /dev/mapper/cryptdata

        keys
        mkdir_datos
        ;;
    add-disk)
        sudo cryptsetup luksOpen /dev/$drive cryptdata
        keys
        mkdir_datos
        ;;
    *)
        echo 'You need to enter a parameter, either wipe or add-disk'
        exit
        ;;
esac
