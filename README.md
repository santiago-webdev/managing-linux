# Managing Linux

This repo has a few shell scripts and Ansible playbooks to automate various tasks, I've used a lot of distros and software so you'll find this configurations organized b directories.

## What will the 10-installer.sh script do:

The `10-installer.sh` script is interactive. It will install Arch Linux in the
drive that you selected, with luks2 encryption, btrfs and it only works for
UEFI systems:

| Partition | Size                  |
| --------- | --------------------- |
| /boot     | 800Mb                 |
| /         | The rest of the drive |

The subvolumes are mounted into

| Subvolume | Mountpoint            |
| --------- | --------------------- |
| @         | /                     |
| @home     | /home                 |
| @pkg      | /var/cache/pacman/pkg |
| @var      | /var                  |
| @srv      | /srv                  |
| @tmp      | /tmp                  |

_Note that if you answered "no" when asked to wipe the drive your subvolume for
@home will not be touched, but it is recommended to backup existing snapshots,
if they exist in @home/.snapshot they will be lost._

And for the bootloader we are using systemd-boot with systemd hooks since it's
simpler. There's also a little 4Gb "partition" that you will see as `[SWAP]` if
you do a quick lsblk, because we are using zram in case you run out of RAM.

Also be aware that the keymap that you choose will be the one used for
decrypting the drive.

## Alternative installer

There's also `05-simplified.sh`, which you should read before running, there's
more instructions inside the script.

## How to get any of the scripts

To get any of the scripts you can curl the raw file directly from github.

```bash
curl -O https://raw.githubusercontent.com/santiagogonzalez-dev/managing-linux/master/arch-scripts/10-installer.sh
chmod +x 10-installer.sh # Make it executable
./10-installer.sh # Run it
```
