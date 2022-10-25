# Managing Arch Linux
This are some scripts to help me install and configure Arch Linux.

## What will the 10-installer script do:
The `10-installer` script is interactive.  It will install Arch Linux in the
drive that you selected, with luks2 encryption, btrfs and it only works for
UEFI systems:

Partition | Size
--- | ---
/boot | 800Mb
/ | The rest of the drive

The subvolumes are mounted into

Subvolume | Mountpoint
--- | ---
@ | /
@home | /home
@pkg | /var/cache/pacman/pkg
@var | /var
@srv | /srv
@tmp | /tmp

*Note that if you answered "no" when asked to wipe the drive your subvolume for
@home will not be touched, but it is recommended to backup existing snapshots,
if they exist in @home/.snapshot they will be lost.*

And for the bootloader we are using systemd-boot with systemd hooks since it's
simpler. There's also a little 4Gb "partition" that you will see as [SWAP] if
you do a quick lsblk, because we are using zram in case you run out of RAM.

Also be aware that the keymap that you choose will be the one used for
decrypting the drive.

## Alternative installer
There's also `05-simplified`, which you should read before running, there's
more instructions inside the script.

## How to get any of the scripts
To get any of the scripts you can curl the raw file directly from github.
```bash
curl -O https://raw.githubusercontent.com/santigo-zero/csj-archlinux/master/10-installer
chmod +x 10-installer # Make it executable
```

## How to run the scripts
```bash
./10-installer
```
