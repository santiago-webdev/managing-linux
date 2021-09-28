# Arch Installation

Basically boot to the arch live usb. Change layout, and connect to the Wi-Fi

## Change layout, and connect to the internet

``` bash
loadkeys dvorak
```

``` bash
iwctl
```
``` bash
station wlan0 connect (wifi-ssid)
```

## Getting the script
``` bash
curl -O https://raw.githubusercontent.com/santigo-zero/csjarchlinux/master/10-unattended.sh
```

``` bash
chmod +x 10-unattended.sh
```

## Now run the script
It will install everything on the NVMe at /dev/nvme0n1
``` bash
./10-unattended.sh && systemctl reboot
```

## After this your computer should reboot, now you need to execute the second script
The 20-packages.sh script will be pulled by the first script and leave it on the home of the user that
you created.

For this second script you should read before executing because it's pulling my
dotfiles, so if you don't want that or the packages that I use just skip the
script totally and install whatever that you want. There's a few other scripts
that you may find useful so check them out.
``` bash
./20-packages.sh
```

If you want to use paru (so the 25-aur.sh script) and are picky as I am, make
sure to export this variable before running it.

``` bash
export RUSTUP_HOME="$XDG_DATA_HOME"/rustup  # You can put it in your .zshrc or .bashrc afterwards
echo $RUSTUP_HOME  # To check if it was exported or not
```
Without this environment variable rustup will put a directory in your $HOME
cluttering it, if you export it, in this case it will get stored in
.local/share/rustup so everything it's cleaner, don't forget to add it to your
shell rc so after an update you don't have it again in your $HOME.
