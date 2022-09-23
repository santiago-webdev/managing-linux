# What is this?
This are my personal scripts to install Arch Linux

# How to get the script
From the booted liveiso you can simply do this
```bash
curl -O https://raw.githubusercontent.com/santigo-zero/csj-archlinux/master/10-installer
chmod +x 10-installer # Make it executable
```

## What will the 10-installer script do:
It will install Arch Linux in the drive that you selected, with luks2 encryption, btrfs
and it only works for UEFI systems:

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

*Note that if you answered "no" when asked to wipe the drive your subvolume for @home will
not be touched though it is recommended to backup existing snapshots, if they exist in @home/.snapshot they will be lost.*
And for the bootloader we are using systemd-boot with systemd hooks since
it's simpler. There's also a little 4Gb "partition" that you will see as [SWAP] if you do a
quick lsblk, because we are using zram in case you run out of RAM.

Be aware that the keymap that you choose will be the one used for decrypting the drive

For networking we are using NetworkManager

Also the user that you created was just added to the wheel and users groups

And that's pretty much it, the rest of scripts are more personal scripts that you
might find useful to set up your environment.

## Run the script
The 10-installer script is interactive, there's also a simplified version, which
you should read before running, inside 5-simplified there's more instructions.
```bash
./10-installer # Or ./5-simplified
```
