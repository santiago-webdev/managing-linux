# Arch Installation

Basically boot to the arch live usb. Change layout, and connect to the Wi-Fi

## Change layout, and connect to the internet

``` bash
loadkeys dvorak
```

``` bash
iwctl
station wlan0 connect (wifi-ssid)
```

## Getting the script

``` bash
pacman -Sy wget
```

``` bash
wget https://raw.githubusercontent.com/santiagogonzalezbogado/csjarchlinux/master/10-baseinstall.sh
```

``` bash
chmod +x 10-baseinstall.sh
```

## Now run the script
It will ask you for the drive that it needs to wipe of. And you should now suppose the partitions, so for example it would be
something like /dev/sda, /dev/sda2, /dev/sda1. After this you will need to confirm and enter the password for the encrytion, 
and after that you should just wait for the script to ask you for hostname, name, password for the user and root, it will
eventually ask you again for the root partition.

``` bash
./10-baseinstall.sh
```

## After this you should reboot and download the second script
This script will install fonts, paru as an AUR helper, KDE Plasma, and my Dotfiles repo for zsh as well.

``` bash
wget https://raw.githubusercontent.com/santiagogonzalezbogado/csjarchlinux/master/20-packages.sh
```

``` bash
chmod +x 20-packages.sh
```

``` bash
./20-packages.sh
```
