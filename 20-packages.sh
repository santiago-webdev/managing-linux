#!/bin/bash

set -e

sudo pacman -Syu

wget https://raw.githubusercontent.com/santiagogonzalezbogado/csjarchlinux/master/36-configs.sh
chmod +x 36-configs.sh

read -p "Install packages from the repos?" packrepos

if [[ "$packrepos" = y ]]; then
	sudo pacman -S --needed \
		git \
		tlp \
		bluez \
		bluez-utils \
		rustup \
		cmake \
		make \
		qbittorrent \
		python \
		python-pip \
		python-wheel \
		nodejs \
		npm \
		bat \
		exa \
		sshfs \
		openssh \
		ntfs-3g \
		wl-clipboard \
		inter-font \
		otf-overpass \
		zsh \
		z \
		zsh-history-substring-search \
		zsh-autosuggestions \
		plasma \
		plasma-wayland-session \
		plasma-wayland-protocols \
		breeze-gtk \
		libappindicator-gtk2 \
		libappindicator-gtk3 \
		kde-gtk-config \
		xdg-desktop-portal \
		xdg-desktop-portal-kde \
		konsole \
		firefox \
		alacritty \
		dolphin \
		kate \
		ark \
		okular \
		gwenview \
		kwalletmanager \
		pipewire \
		pipewire-alsa \
		pipewire-pulse \
	
else
	echo "Not installing packages"
fi

pip install pynvim
rustup default stable

git clone https://aur.archlinux.org/paru.git
cd paru
makepkg -si
cd

read -p "Install packages from the AUR?" packaur

if [[ "$packaur" = y ]]; then
	paru -S \
		brave-bin \
		redhat-fonts \
		zsh-autopair-git \
		zsh-completions-git \
		zsh-fast-syntax-highlighting-git \
		auto-cpufreq-git \
		grml-zsh-config \
		
else
	echo "Not installing AUR packages"
fi

sudo touch /etc/modules-load.d/zram.conf
sudo tee -a /etc/modules-load.d/zram.conf << END
zram
END

sudo touch /etc/modprobe.d/zram.conf
sudo tee -a /etc/modprobe.d/zram.conf << END
options zram num_devices=1
END

sudo touch /etc/udev/rules.d/99-zram.rules
sudo tee -a /etc/udev/rules.d/99-zram.rules << END
KERNEL=="zram0", ATTR{disksize}="512",TAG+="systemd"
END

sudo touch /etc/systemd/system/zram.service
sudo tee -a /etc/systemd/system/zram.service << END
[Unit]
Description=Swap with zram
After=multi-user.target

[Service]
Type=oneshot 
RemainAfterExit=true
ExecStartPre=/sbin/mkswap /dev/zram0
ExecStart=/sbin/swapon -p 3 /dev/zram0
ExecStop=/sbin/swapoff /dev/zram0

[Install]
WantedBy=multi-user.target
END

systemctl enable zram sddm.service bluetooth.service tlp.service auto-cpufreq.service

chsh -s /bin/zsh
cd
git clone https://github.com/santiagogonzalezbogado/Dotfiles
