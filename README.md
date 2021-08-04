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
./10-unattended.sh
```

## After this you should reboot and execute the second script
The 20-packages.sh script will be pulled by the first script and leave it on home of the user that 
you created.
``` bash
./20-packages.sh
```
