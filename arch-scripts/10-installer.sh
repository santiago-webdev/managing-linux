#!/usr/bin/env bash

clear   # Clear the TTY
set -e  # The script will not run if we CTRL + C, or in case of an error
set -u  # Treat unset variables as an error when substituting

## This are the defaults, so it's easier to test the script
# part=yes
# keymap=us
# username=arch  # Can only be lowercase and no signs
# hostname=desktop
# user_password=arch
# root_password=arch
# drive_password=arch

read -r -p "Enter keymap: " keymap
keymap=${keymap:-us}
read -r -p "Enter user name: " username
username=${username:-arch}
read -r -p "Enter host name: " hostname
hostname=${hostname:-arch}
read -r -s -p $'Enter user password: \n' user_password
user_password=${user_password:-arch}
read -r -s -p $'Enter root password: \n' root_password
root_password=${root_password:-arch}
read -r -p "Do you want to wipe the full drive? (YES/no): " part
part=${part:-yes}
read -r -s -p $'Enter drive password: \n' drive_password
drive_password=${drive_password:-arch}

echo -e "\n\n"
read -n 1 -r -p "Do you want to print the variables on the screen? (y/N): " print_variables
echo -e "\n\n"
if [[ $print_variables =~ ^[Yy]$ ]]; then
  echo "Keymap -> $keymap"
  echo "Username -> $username"
  echo "Hostname -> $hostname"
  echo "User Password -> $user_password"
  echo "Root Password -> $root_password"
  echo "Wipe Full Drive -> $part"
  echo "Drive Password -> $drive_password"
fi

if [[ $part == "no" ]]; then
    pacman -Sy dialog --noconfirm  # Install dialog for selecting disk
    devicelist=$(lsblk -dplnx size -o name,size | grep -Ev "boot|rpmb|loop" | tac)  # Gets disk info for selection
    drive=$(dialog --stdout --menu "Select installation disk" 0 0 0 ${devicelist}) || exit 1  # Chose which drive to format
    clear
    lsblk
    echo "${drive}"  # Confirms drive selection
    part_boot="$(ls "${drive}"* | grep -E "^${drive}p?1$")"  # Finds boot partition
    part_root="$(ls "${drive}"* | grep -E "^${drive}p?2$")"  # Finds root partition
    mkfs.vfat -F32 "${part_boot}"
    echo -n "$drive_password" | cryptsetup open "${part_root}" cryptroot -d -  # Open the mapper
    mount /dev/mapper/cryptroot /mnt

    # Clearing non home data
    btrfs subvolume delete /mnt/@pkg
    btrfs subvolume delete /mnt/@var/lib/portables
    btrfs subvolume delete /mnt/@var/lib/machines
    btrfs subvolume delete /mnt/@var
    btrfs subvolume delete /mnt/@srv
    btrfs subvolume delete /mnt/@tmp
    btrfs subvolume delete /mnt/@/.snapshots
    btrfs subvolume delete /mnt/@home/.snapshots
    btrfs subvolume delete /mnt/@

    # Creating new subvolumes
    btrfs subvolume create /mnt/@
    btrfs subvolume create /mnt/@pkg
    btrfs subvolume create /mnt/@var
    btrfs subvolume create /mnt/@srv
    btrfs subvolume create /mnt/@tmp
    umount /mnt

    mount -o noatime,compress-force=zstd:3,space_cache=v2,subvol=@ /dev/mapper/cryptroot /mnt
    mkdir -p /mnt/{home,var/cache/pacman/pkg,var,srv,tmp,boot}  # Create directories for each subvolume
    mount -o noatime,compress-force=zstd:3,space_cache=v2,subvol=@home /dev/mapper/cryptroot /mnt/home
    mount -o noatime,compress-force=zstd:3,space_cache=v2,subvol=@pkg /dev/mapper/cryptroot /mnt/var/cache/pacman/pkg
    mount -o noatime,compress-force=zstd:3,space_cache=v2,subvol=@var /dev/mapper/cryptroot /mnt/var
    mount -o noatime,compress-force=zstd:3,space_cache=v2,subvol=@srv /dev/mapper/cryptroot /mnt/srv
    mount -o noatime,compress-force=zstd:3,space_cache=v2,subvol=@tmp /dev/mapper/cryptroot /mnt/tmp
    chattr +C /mnt/var  # Copy on write disabled
    mount "${part_boot}" /mnt/boot
else
    pacman -Sy dialog --noconfirm  # Install dialog for selecting disk
    devicelist=$(lsblk -dplnx size -o name,size | grep -Ev "boot|rpmb|loop" | tac)  # Gets disk info for selection
    drive=$(dialog --stdout --menu "Select installation disk" 0 0 0 ${devicelist}) || exit 1  # Chose which drive to format
    clear
    lsblk
    echo "${drive}"  # Confirms drive selection
    sgdisk --zap-all "${drive}"  # Delete tables
    printf "n\n1\n\n+800M\nef00\nn\n2\n\n\n\nw\ny\n" | gdisk "${drive}"  # Format the drive

    part_boot="$(ls "${drive}"* | grep -E "^${drive}p?1$")"  # Finds boot partition
    part_root="$(ls "${drive}"* | grep -E "^${drive}p?2$")"  # Finds root partition

    echo "${part_boot}"
    echo "${part_root}"

    mkdir -p /run/cryptsetup
    chmod 0700 /run/cryptsetup /run
    echo -n "$drive_password" | cryptsetup luksFormat --type luks2 "${part_root}" -d -
    echo -n "$drive_password" | cryptsetup open "${part_root}" cryptroot -d -

    mkfs.vfat -F32 "${part_boot}"
    mkfs.btrfs /dev/mapper/cryptroot

    mount /dev/mapper/cryptroot /mnt
    btrfs subvolume create /mnt/@
    btrfs subvolume create /mnt/@home
    btrfs subvolume create /mnt/@pkg
    btrfs subvolume create /mnt/@var
    btrfs subvolume create /mnt/@srv
    btrfs subvolume create /mnt/@tmp
    umount /mnt

    mount -o noatime,compress-force=zstd:3,space_cache=v2,subvol=@ /dev/mapper/cryptroot /mnt
    mkdir -p /mnt/{home,var/cache/pacman/pkg,var,srv,tmp,boot}  # Create directories for each subvolume
    mount -o noatime,compress-force=zstd:3,space_cache=v2,subvol=@home /dev/mapper/cryptroot /mnt/home
    mount -o noatime,compress-force=zstd:3,space_cache=v2,subvol=@pkg /dev/mapper/cryptroot /mnt/var/cache/pacman/pkg
    mount -o noatime,compress-force=zstd:3,space_cache=v2,subvol=@var /dev/mapper/cryptroot /mnt/var
    mount -o noatime,compress-force=zstd:3,space_cache=v2,subvol=@srv /dev/mapper/cryptroot /mnt/srv
    mount -o noatime,compress-force=zstd:3,space_cache=v2,subvol=@tmp /dev/mapper/cryptroot /mnt/tmp
    chattr +C /mnt/var  # Copy on write disabled
    mount "${part_boot}" /mnt/boot
fi

timedatectl set-ntp true

sed -i "/#Color/a ILoveCandy" /etc/pacman.conf
sed -i "s/#Color/Color/g" /etc/pacman.conf
sed -i "s/#ParallelDownloads = 5/ParallelDownloads = 10/g" /etc/pacman.conf

read -p "Do you want to retrieve the latest mirrors?"$'\n' -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    if ping -q -c 1 -W 1 2001:4860:4860::8888 >/dev/null; then
        ipv=ipv6
    else
        if ping -q -c 1 -W 1 8.8.8.8 >/dev/null; then
            ipv=ipv4
        else
            echo "Not online"
        fi
    fi
    reflector --latest 25 --verbose --protocol https --sort rate --save /etc/pacman.d/mirrorlist --$ipv
    pacman -Syy
else
    pacman -Syy
fi

# Cpu detection
if lscpu | grep -q 'GenuineIntel'; then
    cpu_model="intel-ucode"
else
    cpu_model="amd-ucode"
fi
printf 'Your CPU is %s\n' "$cpu_model"

pacstrap -i /mnt \
  base \
  base-devel \
  linux \
  linux-firmware \
  networkmanager \
  efibootmgr \
  btrfs-progs \
  zram-generator \
  ${cpu_model}

genfstab -U /mnt >> /mnt/etc/fstab

{
  ln -sf /usr/share/zoneinfo/"$(curl -s http://ip-api.com/line?fields=timezone)" /etc/localtime &>/dev/null
  hwclock --systohc
  sed -i "s/#en_US/en_US/g; s/#es_AR/es_AR/g" /etc/locale.gen
  echo "LANG=en_US.UTF-8" > /etc/locale.conf
  locale-gen

  echo -e "127.0.0.1\tlocalhost" > /etc/hosts
  echo -e "::1\t\tlocalhost" >> /etc/hosts
  echo -e "127.0.1.1\t$hostname.localdomain\t$hostname" >> /etc/hosts

  echo -e "KEYMAP=$keymap" > /etc/vconsole.conf
  echo "%wheel ALL=(ALL) ALL" >> /etc/sudoers
  echo "Defaults !tty_tickets" >> /etc/sudoers
  sed -i "/#Color/a ILoveCandy" /etc/pacman.conf
  sed -i "s/#Color/Color/g; s/#ParallelDownloads = 5/ParallelDownloads = 6/g; s/#UseSyslog/UseSyslog/g; s/#VerbosePkgLists/VerbosePkgLists/g" /etc/pacman.conf

  echo -e "$hostname" > /etc/hostname
  useradd -g users -G wheel -m "$username"
  echo -en "$root_password\n$root_password" | passwd
  echo -en "$user_password\n$user_password" | passwd "$username"

  systemctl enable NetworkManager.service fstrim.timer

  journalctl --vacuum-size=100M --vacuum-time=2weeks

  touch /etc/systemd/zram-generator.conf
  tee -a /etc/systemd/zram-generator.conf << END
  [zram0]
  zram-fraction = 1
  max-zram-size = 4096
END

  touch /etc/sysctl.d/99-swappiness.conf
  echo 'vm.swappiness=20' > /etc/sysctl.d/99-swappiness.conf

  mkdir -p /etc/pacman.d/hooks/
  touch /etc/pacman.d/hooks/100-systemd-boot.hook
  tee -a /etc/pacman.d/hooks/100-systemd-boot.hook << END
  [Trigger]
  Type = Package
  Operation = Upgrade
  Target = systemd

  [Action]
  Description = Updating systemd-boot
  When = PostTransaction
  Exec = /usr/bin/bootctl update
END

  sed -i "s/^HOOKS.*/HOOKS=(base systemd keyboard autodetect sd-vconsole modconf block sd-encrypt btrfs filesystems fsck)/g" /etc/mkinitcpio.conf
  sed -i 's/^MODULES.*/MODULES=(intel_agp i915)/' /etc/mkinitcpio.conf
  mkinitcpio -P
  bootctl --path=/boot/ install

  mkdir -p /boot/loader/
  tee -a /boot/loader/loader.conf << END
  default arch.conf
  console-mode max
  editor no
END

  mkdir -p /boot/loader/entries/
  touch /boot/loader/entries/arch.conf
  tee -a /boot/loader/entries/arch.conf << END
  title Arch Linux
  linux /vmlinuz-linux
  initrd /$cpu_model.img
  initrd /initramfs-linux.img
  options lsm=landlock,lockdown,yama,apparmor,bpf rd.luks.name=$(blkid -s UUID -o value "${part_root}")=cryptroot root=/dev/mapper/cryptroot rootflags=subvol=@ rd.luks.options=discard i915.fastboot=1 i915.enable_fbc=1 i915.enable_guc=2 nmi_watchdog=0 quiet rw
END

  touch /boot/loader/entries/arch-zen.conf
  tee -a /boot/loader/entries/arch-zen.conf << END
  title Arch Linux Zen
  linux /vmlinuz-linux-zen
  initrd /$cpu_model.img
  initrd /initramfs-linux-zen.img
  options lsm=landlock,lockdown,yama,apparmor,bpf rd.luks.name=$(blkid -s UUID -o value "${part_root}")=cryptroot root=/dev/mapper/cryptroot rootflags=subvol=@ rd.luks.options=discard i915.fastboot=1 i915.enable_fbc=1 i915.enable_guc=2 nmi_watchdog=0 quiet rw
END

  touch /boot/loader/entries/arch-lts.conf
  tee -a /boot/loader/entries/arch-lts.conf << END
  title Arch Linux LTS
  linux /vmlinuz-linux-lts
  initrd /$cpu_model.img
  initrd /initramfs-linux-lts.img
  options lsm=landlock,lockdown,yama,apparmor,bpf rd.luks.name=$(blkid -s UUID -o value "${part_root}")=cryptroot root=/dev/mapper/cryptroot rootflags=subvol=@ rd.luks.options=discard i915.fastboot=1 i915.enable_fbc=1 i915.enable_guc=2 nmi_watchdog=0 quiet rw
END
} | arch-chroot /mnt

read -n 1 -r -p "Do you wish to reboot? (y/N)"
[[ $REPLY =~ ^[Yy]$ ]] && reboot
