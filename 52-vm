#!/usr/bin/env bash

cd "$HOME" || exit

LC_ALL=C lscpu | grep Virtualization

if [[ $? -eq 1 ]]
then
    echo "Your machine doesn't support Virtualization, check your BIOS"
    exit
fi

echo "Installing all you need"
sudo pacman -S \
	qemu qemu-arch-extra vde2 bridge-utils \
    iptables-nft dnsmasq edk2-ovmf openbsd-netcat \
    virt-manager pcp virt-viewer \
    packagekit packagekit-qt5

echo "Enabling libvirtd"
systemctl enable --now libvirtd

echo -e "Adding user $USER to the libvirt group"
sudo usermod -G libvirt -a "$USER"

systemctl enable --now pmcd.service pmlogger

echo "Creating bridge and configuring for network in your VMs"
touch .config/br10.xml
tee -a .config/br10.xml << END
<network>
<name>br10</name>
<forward mode='nat'>
<nat>
    <port start='1024' end='65535'/>
</nat>
</forward>
<bridge name='br10' stp='on' delay='0'/>
<ip address='192.168.30.1' netmask='255.255.255.0'>
<dhcp>
    <range start='192.168.30.50' end='192.168.30.200'/>
</dhcp>
</ip>
</network>
END

echo "Adding and autostarting the bridge"
sudo virsh net-define .config/br10.xml
sudo virsh net-autostart --network br10
sudo virsh net-autostart --network default

echo "Now reboot so that all the services get started"
