# Arch Installation

*If you are going to use this scripts, please read them and test them on a VM first, all
feedback and issues are welcome*

Basically boot to the arch live usb. Change layout, and connect to the Wi-Fi

## What does the 10-unattended.sh script do
The 10-unnattended.sh script does this:
It will install Arch Linux in the drive that you selected to, with luks2 encryption, btrfs
and it only works for UEFI systems:

Partition | Size
--- | ---
/boot | 333Mb
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
not be touched*. And for the bootloader we are using systemd-boot with systemd hooks since
it's simpler. There's also a little 4Gb "partition" that you will see as [SWAP] if you do a
quick lsblk, because we are using zram in case that you run out of RAM.

Be aware that the keymap that you choose will be the one used for decrypting the drive

For networking we are using NetworkManager

Also the user that you created was just added to the wheel and users groups

## Change layout, and connect to the internet

```bash
loadkeys dvorak
```

```bash
iwctl
station wlan0 connect (wifi-ssid)
```

# Getting the script
```bash
curl -O https://raw.githubusercontent.com/santigo-zero/csjarchlinux/master/10-unattended.sh
chmod +x 10-unattended.sh
```

## Now run the script
It will install everything on the selected drive
```bash
./10-unattended.sh && systemctl reboot
```

And that's pretty much it, the next 20, 21, etc scripts are more personal scripts that you
might find useful to set up your environment.

## After this your computer should reboot, now you need to execute the second script
The 20-packages.sh script will be pulled by the first script and leave it on the home of the user that
you created.

For this second script you should read before executing because it's pulling my
dotfiles, so if you don't want that or the packages that I use just skip the
script totally and install whatever that you want. There's a few other scripts
that you may find useful so check them out.
```bash
./20-packages.sh # After this log out so that you enter with zsh and the environment variables setted up
```

```bash
./21-morepackages.sh # This packages are not necessary to have a usable desktop
```

If you want to use paru as your aur helper (the 25-aur.sh script) and are picky as I am,
make sure to check and export $RUSTUP_HOME
```bash
echo $RUSTUP_HOME  # To check if it was exported or not
export RUSTUP_HOME="$XDG_DATA_HOME"/rustup  # You can put it in your .zshrc or .bashrc afterwards
```

Without this environment variable rustup will put a directory in your $HOME
cluttering it, if you export it, in this case it will get stored in
.local/share/rustup so everything it's cleaner, don't forget to add it to your
shell rc so after an update you don't have it again in your $HOME.

### Things that I need to add to the project
- [x] Update the README with a description for each script.
- [ ] Add snapper for rollback functionality #2.
- [ ] Add the boot entry creation of snapshots for systemd-boot
- [x] Make the 10-unattended.sh script able to handle different drive names.
- [ ] Make the 10-unattended.sh script able to handle different filesystems.
- [ ] Make the 10-unattended.sh script able to install Arch Linux without encryption
- [ ] Move to systemd-networkd
