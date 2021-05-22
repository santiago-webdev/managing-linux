#!/bin/bash

#10-baseinstall.sh

# Just start looking for variables or words like CHANGE

drive=/dev/nvme0n1
rootpartition=/dev/nvme0n1p2
bootpartition=/dev/nvme0n1p1

sed -i 's/#UseSyslog/UseSyslog/g; s/#Color/Color/g; s/#TotalDownload/TotalDownload/g; s/#CheckSpace/CheckSpace/g' /etc/pacman.conf

sgdisk --zap-all $drive

timedatectl set-ntp true
sleep 6

printf "n\n1\n\n+666M\nef00\nn\n2\n\n\n\nw\ny\n" | gdisk $drive
echo -e "YES\n(CHANGE)\n(CHANGE)" | cryptsetup luksFormat $rootpartition
echo -e "(CHANGE)" | cryptsetup luksOpen $rootpartition luks
mkfs.vfat -F32 $bootpartition
mkfs.btrfs /dev/mapper/luks
mount /dev/mapper/luks /mnt
btrfs subvolume create /mnt/@
btrfs subvolume create /mnt/@home
btrfs subvolume create /mnt/@pkg
btrfs subvolume create /mnt/@srv
btrfs subvolume create /mnt/@log
btrfs subvolume create /mnt/@tmp
btrfs subvolume create /mnt/@btrfs
umount /mnt
mount -o noatime,nodiratime,compress-force=zstd:1,space_cache=v2,discard=async,subvol=@ /dev/mapper/luks /mnt
mkdir -p /mnt/{home,var/cache/pacman/pkg,srv,log,tmp,btrfs,boot}
mount -o noatime,nodiratime,compress-force=zstd:1,space_cache=v2,discard=async,subvol=@home /dev/mapper/luks /mnt/home
mount -o noatime,nodiratime,compress-force=zstd:1,space_cache=v2,discard=async,subvol=@pkg /dev/mapper/luks /mnt/var/cache/pacman/pkg
mount -o noatime,nodiratime,compress-force=zstd:1,space_cache=v2,discard=async,subvol=@srv /dev/mapper/luks /mnt/srv
mount -o noatime,nodiratime,compress-force=zstd:1,space_cache=v2,discard=async,subvol=@log /dev/mapper/luks /mnt/log
mount -o noatime,nodiratime,compress-force=zstd:1,space_cache=v2,discard=async,subvol=@tmp /dev/mapper/luks /mnt/tmp
mount -o noatime,nodiratime,compress-force=zstd:1,space_cache=v2,discard=async,subvolid=5 /dev/mapper/luks /mnt/btrfs
mount $bootpartition /mnt/boot
pacstrap /mnt base \
	base-devel \
	linux \
	linux-zen \
	linux-lts \
	linux-firmware \
	intel-media-driver \
	vulkan-intel \
	libvdpau-va-gl \
	networkmanager \
	efibootmgr \
	intel-ucode \
	neovim \
	btrfs-progs \
	git \
	wget \
	tlp \
	tlp-rdw \
	bluez \
	bluez-utils \
	rustup \
	cmake \
	make \
	qbittorrent \
	python \
	python-pip \
	python-wheel \
	ruby \
	nodejs \
	npm \
	bat \
	exa \
	sshfs \
	openssh \
	man \
	zsh \
	tar \
	unzip \
	unrar \
	ntfs-3g \
	xclip \
	inter-font \
	noto-fonts \
	noto-fonts-cjk \
	noto-fonts-emoji \
	ttf-roboto \
	ttf-roboto-mono \
	ttf-droid \
	ttf-fira-mono \
	ttf-font-awesome \
	otf-font-awesome \
	ttf-hanazono \
	ttf-cascadia-code \
	ttf-dejavu \
	ttf-liberation \
	ttf-opensans \
	adobe-source-code-pro-fonts \
	gnu-free-fonts \
	plasma \
	krusader \
	breeze-gtk \
	libappindicator-gtk2 \
	libappindicator-gtk3 \
	kde-gtk-config \
	xdg-desktop-portal \
	xdg-desktop-portal-kde \
	dolphin \
	konsole \
	kde-cli-tools \
	ffmpegthumbs \
	kdegraphics-thumbnailers \
	kgpg \
	purpose \
	packagekit-qt5 \
	keditbookmarks \
	ebook-tools \
	kdegraphics-mobipocket \
	libzip \
	khtml \
	chmlib \
	calligra \
	gwenview \
	qt5-imageformats \
	kimageformats \
	ark \
	p7zip \
	unarchiver \
	lzop \
	lrzip \
	kdeconnect \
	qt5-tools \
	clang \
	kate \
	spectacle \
	filelight \
	juk \
	akregator \
	kdepim-addons \
	kwalletmanager \
	ktimer \
	kalarm \
	kontrast \
	kompare \
	kfind \
	kdenetwork-filesharing \
	partitionmanager \
	kcolorchooser \
	kcalc \
	markdownpart \
	z \
	zsh-history-substring-search \
	zsh-autosuggestions \

genfstab -U /mnt >> /mnt/etc/fstab

sed '1,/^#13-Chroot$/d' 10-baseinstall.sh > /mnt/13-Chroot.sh
chmod +x /mnt/13-Chroot.sh
arch-chroot /mnt ./13-Chroot.sh
exit

######################################################################################
#13-Chroot
hostname=OKB0
username=st
rootpartition=/dev/nvme0n1p2
useradd -m -g users -G wheel,games,power,optical,storage,scanner,lp,audio,video,input,adm,users $username
echo -e "(CHANGE)\n(CHANGE)" | passwd
echo -e "(CHANGE)\n(CHANGE)" | passwd $username

sed -i 's/-)/--threads=0 -)/g; s/gzip/pigz/g; s/bzip2/pbzip2/g; s/#MAKEFLAGS/MAKEFLAGS/g; s/-j2/-j$(nproc)/g' /etc/makepkg.conf
sed -i 's/#UseSyslog/UseSyslog/g; s/#Color/Color/g; s/#TotalDownload/TotalDownload/g; s/#CheckSpace/CheckSpace/g' /etc/pacman.conf

echo "LANG=en_US.UTF-8" > /etc/locale.conf
echo "KEYMAP=dvorak" > /etc/vconsole.conf
echo $hostname > /etc/hostname
echo -e "127.0.0.1\tlocalhost" >> /etc/hosts
echo -e "::1\t\tlocalhost" >> /etc/hosts
echo -e "127.0.1.1\t$hostname.localdomain\t$hostname" >> /etc/hosts

echo "%wheel ALL=(ALL) ALL" >> /etc/sudoers
echo "Defaults !tty_tickets" >> /etc/sudoers

ln -sf /usr/share/zoneinfo/America/Argentina/Mendoza /etc/localtime
hwclock --systohc
sed -i "s/#en_US/en_US/g; s/#es_AR/es_AR/g" /etc/locale.gen
locale-gen

systemctl enable tlp.service bluetooth.service NetworkManager.service sddm.service
# echo "Activate conservation of battery"
# echo 1 >/sys/bus/platform/drivers/ideapad_acpi/VPC2004\:00/conservation_mode
sed -i "s/^HOOKS.*/HOOKS=(base keyboard udev autodetect modconf block keymap encrypt btrfs filesystems fsck)/g" /etc/mkinitcpio.conf
sed -i 's/^MODULES.*/MODULES=(intel_agp i915)/' /etc/mkinitcpio.conf
mkinitcpio -P
bootctl --path=/boot/ install
echo -e "title\tArch Linux\nlinux\t/vmlinuz-linux\ninitrd\t/intel-ucode.img\ninitrd\t/initramfs-linux.img\noptions cryptdevice=UUID=$(blkid -s UUID -o value $rootpartition):luks:allow-discards root=/dev/mapper/luks rootflags=subvol=@ rd.luks.options=discard rw" > /boot/loader/entries/arch.conf
echo -e "title\tArch Linux Zen\nlinux\t/vmlinuz-linux-zen\ninitrd\t/intel-ucode.img\ninitrd\t/initramfs-linux-zen.img\noptions cryptdevice=UUID=$(blkid -s UUID -o value $rootpartition):luks:allow-discards root=/dev/mapper/luks rootflags=subvol=@ rd.luks.options=discard rw" > /boot/loader/entries/arch-zen.conf
echo -e "title\tArch Linux LTS\nlinux\t/vmlinuz-linux-lts\ninitrd\t/intel-ucode.img\ninitrd\t/initramfs-linux-lts.img\noptions cryptdevice=UUID=$(blkid -s UUID -o value $rootpartition):luks:allow-discards root=/dev/mapper/luks rootflags=subvol=@ rd.luks.options=discard rw" > /boot/loader/entries/arch-lts.conf
echo -e "default\tarch.conf\nconsole-mode max\neditor\tno" > /boot/loader/loader.conf

wget https://raw.githubusercontent.com/santiagogonzalezbogado/csjarchlinux/master/36-kconfigs.sh
chmod +x 36-kconfigs.sh

mkdir /datos
echo -e "\n# /datos\nUUID=084c5be3-ad98-4203-ad97-44b68b483901\t/datos\t\text4\t\tdefaults\t0\t2" >> /etc/fstab
rustup default stable
pip install pynvim
