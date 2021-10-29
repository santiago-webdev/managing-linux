#!/usr/bin/env bash

# Usage:
# ./40-encrypt-drive.sh wipe
# ./40-encrypt-drive.sh add-disk

mkdir_datos() {
    if [[ ! -d "/data" ]]
    then
        sudo mkdir /data
        sudo chown $USER /data
        sudo chmod 750 /data
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
UUID=$(sudo blkid -s UUID -o value /dev/mapper/cryptdata)      /data        btrfs     	    defaults,noatime,autodefrag,compress-force=zstd:1,space_cache=v2,subvol=/@	0 2
EOT
}

case "${1}" in
    wipe)
        sudo wipefs --all /dev/sda
        printf "n\n\n\n\n\nw\ny\n" | sudo gdisk /dev/sda
        sudo cryptsetup luksFormat --type luks2 /dev/sda1
        sudo cryptsetup luksOpen /dev/sda1 cryptdata
        sudo mkfs.btrfs /dev/mapper/cryptdata

        sudo mount /dev/mapper/cryptroot /mnt
        sudo btrfs su cr /mnt/@
        sudo umount /mnt
        sudo mount -o defaults,noatime,autodefrag,compress-force=zstd:1,space_cache=v2,subvol=@ /dev/mapper/cryptdata /mnt
        ;;
    mount)
        mkdir_datos
        sudo cryptsetup luksOpen /dev/sda1 cryptdata
        sudo mount -o defaults,noatime,autodefrag,compress-force=zstd:1,space_cache=v2,subvol=@ /dev/mapper/cryptdata /data
        sudo hdparm -S 60 /dev/sda
        ;;
    unmount)
        sudo umount /data
        sudo cryptsetup luksClose /dev/mapper/cryptdata
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
