# Arch Installation

*If you are going to use this scripts, please read them and test them on a VM first, all
feedback and issues are welcome*

Basically boot to the arch live usb. Change layout, and connect to the Wi-Fi

## Change layout, and connect to the internet

```bash
loadkeys dvorak
```

```bash
iwctl
station wlan0 connect (wifi-ssid)
```

## Getting the script
```bash
curl -O https://raw.githubusercontent.com/santigo-zero/csjarchlinux/master/10-unattended.sh
chmod +x 10-unattended.sh
```

## Now run the script
It will install everything on the NVMe at /dev/nvme0n1
```bash
./10-unattended.sh && systemctl reboot
```

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
- [ ] Update the README with a description for each script.
- [ ] Add snapper for rollback functionality #2.
- [ ] Add the boot entry creation of snapshots for systemd-boot
- [ ] Make the 10-unattended.sh script able to handle different drive names.
- [ ] Make the 10-unattended.sh script able to handle different filesystems.
- [ ] Make the 10-unattended.sh script able to install Arch Linux without encryption
- [ ] Move to systemd-networkd
