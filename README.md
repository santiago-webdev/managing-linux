# What is this?
This are my personal scripts to install Arch Linux

# How to get the script
From the booted liveiso you can simply do this
```bash
curl -O https://raw.githubusercontent.com/santigo-zero/csjarchlinux/master/10-installer
chmod +x 10-installer # Make it executable
```

## Run the script
The 10-installer script is interactive, there's also a simplified version, which
you should read before running, inside 5-simplified there's more instructions.
```bash
./10-installer # Or ./5-simplified
```

## What will the 10-installer script do:
It will install Arch Linux in the drive that you selected, with luks2 encryption, btrfs
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
not be touched though recommened to backup existing snapshots if they exist in @home/.snapshot those will be lost.*
And for the bootloader we are using systemd-boot with systemd hooks since
it's simpler. There's also a little 4Gb "partition" that you will see as [SWAP] if you do a
quick lsblk, because we are using zram in case you run out of RAM.

Be aware that the keymap that you choose will be the one used for decrypting the drive

For networking we are using NetworkManager

Also the user that you created was just added to the wheel and users groups

And that's pretty much it, the next 20, 21, etc scripts are more personal scripts that you
might find useful to set up your environment.

## After this your computer should reboot, now you need to execute the second script
The 20-packages script will be pulled by the first script and leave it on the home of the user that
you created.

For this second script you should read before executing because it's pulling my
dotfiles, so if you don't want that or the packages that I use just skip the
script totally and install whatever that you want. There's a few other scripts
that you may find useful so check them out.
```bash
./20-packages # After this log out so that you enter with zsh and the environment variables setted up
```

```bash
./21-morepackages # This packages are not necessary to have a usable desktop
```

If you want to use paru as your aur helper (the 25-aur script) and are picky as I am,
make sure to check and export $RUSTUP_HOME
```bash
echo $RUSTUP_HOME  # To check if it was exported or not
export RUSTUP_HOME="$XDG_DATA_HOME"/rustup  # You can put it in your .zshrc or .bashrc afterwards
```

Without this environment variable rustup will put a directory in your $HOME
cluttering it, if you export it, in this case it will get stored in
.local/share/rustup so everything it's cleaner, don't forget to add it to your
shell rc so after an update you don't have it again in your $HOME.
