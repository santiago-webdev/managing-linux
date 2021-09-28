#!/usr/bin/env bash

LC_ALL=C lscpu | grep Virtualization

if [[ $? -eq 1 ]]; then
    echo "Your machine doesn't support Virtualization, check your BIOS"
else
    echo "Installing dependencies"
    sudo pacman -S qemu virt-manager ebtables dnsmasq edk2-ovmf

    echo "Enabling libvirtd"
    sudo systemctl enable libvirtd

    echo "Adding your user to the libvirt group"
    sudo usermod -G libvirt -a $USER

    echo "Creating bridge for network in your VMs"
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
    sudo virsh net-autostart br10

    echo "Now reboot so that all hte services get started"
fi
