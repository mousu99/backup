# Arch Linux Installation Guide

### Connect to Internet
never had an experience how to do it without wifi, so ...
```
wifi-menu
```

### Update the system clock
i set to Jakarta because i live in Indonesia
```
timedatectl set-ntp true
timedatectl set-timezone Asia/Jakarta
```

### Partitioning Disk
```
cgdisk /dev/sdXy
```

### Format and mounting
```
mkswap /dev/sdXy
mkfs.fat -F32 /dev/sdXy
mkfs.ext4 /dev/sdXy
```
mounting
```
mount /dev/sdXy /mnt
mkdir /mnt/{home,boot}
mount /dev/sdXy /mnt/home
mount /dev/sdXy /mnt/boot
```

### Pacman Mirror and stuff
install reflector
```
pacman -Sy reflector
```

choose best mirror
Singapore and German mirror are fast
```
reflector --verbose -c Indonesia -c Singapore -c Germany -a 7 -p https --sort rate --save /etc/pacman.d/mirrorlist
```

edit pacman.conf
```
nano /etc/pacman.conf
```

uncomment and add
```
#Color
ILoveCandy

#[multilib]
# this one below too
```

### Installing Base Package
i usually use systemd-boot for booting, or refind sometimes, and its already installed by default
```
pacstrap /mnt base base-devel linux-zen linux-zen-headers linux-firmware zsh neovim networkmanager intel-ucode git systemd-swap xdg-user-dirs
```
base mean base package needed for system
base-devel for building package from AUR
linux-zen is the kernel with more juice added that the default one
linux-zen-headers needed for installing nvidia driver
linux-firmware is firmware needed by kernel
zsh as default shell
neovim for code editor
networkmanager for managing network
systemd-swap for automatic swap management
intel-ucode is the CPU microcode, or amd-ucode
git is needed for building yay
xdg-user-dirs for automatic home management


