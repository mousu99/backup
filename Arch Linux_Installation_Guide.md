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
#and this one below too
```

### Installing Base Package

i usually use systemd-boot for booting, or refind sometimes, and its already installed by default

```
pacstrap /mnt base base-devel linux-zen linux-zen-headers linux-firmware zsh neovim networkmanager intel-ucode git systemd-swap xdg-user-dirs light
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

light for backlight

### Generate and edit File System Table

```
genfstab -U /mnt >> /mnt/etc/fstab
```

change to noatime, and add commit=60

```
nvim /etc/fstab
```

### Editing and uncommenting some files

usually im editing files from mountpoint, but many guides prefer to do it in chroot system

### Chroot system

```
arch-chroot /mnt /bin/zsh #for zsh shell
```

install oh-my-zsh

```
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

or just google it

## Setting Locale

```
nvim /etc/locale.gen
```

Uncomment this

```
#en_GB.UTF-8
#id_ID.UTF-8
```

create locale.conf

```
nvim /etc/locale.conf
```

add this

```
LANG=en_GB.UTF-8
LC_TIME=id_ID.UTF-8
LC_COLLATE=C
```

### Hostname and hosts

hostname

```
nvim /etc/hostname
#create any PC-name
```

hosts

```
nvim /etc/hosts
127.0.0.1 localhost
::1 localhost
127.0.1.1 PC-name.localdomain PC-name
```

sudoers

```
nvim /etc/sudoers #uncomment
# %wheel ALL=(ALL) ALL
```

mkinitcpio.conf

```
nvim /etc/mkinitcpio.conf
#change base and udev to systemd
```

### Localization

```
locale-gen
```

### Add user and change password

```zsh
useradd -m -g users -G wheel,video -c "Your Name" username
passwd #change root password
passwd username #change user password
chsh -s /usr/bin/zsh username
```

### Enable NetworkManager

```zsh
systemctl enable NetworkManager.service
```

### Enable systemd-swap

```zsh
$ systemctl enable systemd-swap.service
```

### Install Bootloader

i'm using systemd-boot for simple bootloader

```
bootctl install
```

then you need to create a boot entry

```
nano /boot/loader/entries/archlinux.conf
```

add this line

```
title   Arch Linux
linux   /vmlinuz-linux-zen
initrd  /intel-ucode.img #or amd for microcode
initrd  /initramfs-linux-zen.img
options root=/dev/sdXy rw nowatchdog
```

### Edit some stuff

journald

```
nano /etc/systemd/journald.conf
```

edit

```
SystemMaxUse=50M
```

coredump

```
nano /etc/systemd/coredump.conf
```

edit

```
Storage=none
```

restrict kernel

```
nano /etc/sysctl.d/51-dmesg-restrict.conf
```

add

```
kernel.dmesg_restrict = 1
```

### Unmount and shutdown

exit chroot

```
exit
```

unmount and shutdown

```
unmount -R /mnt
poweroff
```

#### Font Installation

Let's be honest, font rendering in Linux _is not that_ good by default. So let's make them great again! Let's start with installing some beautiful fonts.

```zsh
# Basic fonts
$ sudo pacman -S ttf-dejavu ttf-liberation noto-fonts noto-fonts-emoji otf-san-francisco-pro otf-sfmono-patched ttf-joypixels
```

#### Improve Font Rendering

1.  Enable font presets by creating symbolic links:

        ```zsh
        $ sudo ln -s /etc/fonts/conf.avail/70-no-bitmaps.conf /etc/fonts/conf.d
        $ sudo ln -s /etc/fonts/conf.avail/10-sub-pixel-rgb.conf /etc/fonts/conf.d
        $ sudo ln -s /etc/fonts/conf.avail/11-lcdfilter-default.conf /etc/fonts/conf.d
        ```

    Let's then add the following line to `/etc/profile.d/freetype2.sh`:

```
export FREETYPE_PROPERTIES="truetype:interpreter-version=40"
```

Please note that the way I did this is not endorsed by the Arch Wiki and it's a way I found to make the change permament. Unless you know how to revert all of this, you should just stick to what the Arch Wiki does, which I did too anyway.

A little configuration maybe required to render the fonts in an optimal manner. Follow the steps illustrated below.

1. Create the file /etc/fonts/local.conf

```
sudo nano /etc/fonts/local.conf
```

Paste the following content in the file-

```
<?xml version="1.0"?>
<!DOCTYPE fontconfig SYSTEM "fonts.dtd">
<fontconfig>
	<match target="font">
		<edit name="autohint" mode="assign">
			<bool>true</bool>
		</edit>
		<edit name="hinting" mode="assign">
			<bool>true</bool>
		</edit>
		<edit mode="assign" name="hintstyle">
			<const>hintslight</const>
		</edit>
		<edit mode="assign" name="lcdfilter">
			<const>lcddefault</const>
		</edit>
		<edit name="embeddedbitmap" mode="assign">
			<bool>false</bool>
		</edit>
	</match>
</fontconfig>
```

After that save the file.

2. Open/Create ~/.Xresources file in text editor:

```
nano ~/.Xresources
```

Delete current content (if any) and paste in it:

```
Xft.dpi: 96
Xft.antialias: true
Xft.hinting: true
Xft.rgba: rgb
Xft.autohint: false
Xft.hintstyle: hintslight
Xft.lcdfilter: lcddefault
```

Save changes in the file.

3.Run the following command in terminal:

```
xrdb -merge ~/.Xresources
```

### Disable Watchdog Timer

```
nvim /etc/modprobe.d/blacklist.conf
```

# Blacklist unwanted drivers

add

```
blacklist iTCO_wdt
blacklist iTCO_vendor_support
```

### Install yay, freetype2-cleartype, alacritty and Powerlevel10k

### Install xorg-server xorg-xrdb sddm wm pulseaudio-alsa and other useful application

### Configure SWAP

### Install driver

for nvidia

```
mesa nvidia-dkms nvidia-prime
```

### Using the modesetting driver

Arch Wiki reference: https://wiki.archlinux.org/index.php/Kernel_mode_setting#Early_KMS_start

I use the kernel modesetting driver for my Intel processor. To use it, it's sufficient to make sure the `xf86-video-intel` package is not installed. This is important because how I set up HuC / GuC depends on the kernel modesetting being used.

### Enabling Early KMS

Arch Wiki reference: https://wiki.archlinux.org/index.php/Kernel_mode_setting#Early_KMS_start https://wiki.archlinux.org/index.php/Mkinitcpio#Image_creation_and_activation

I decided to start kernel modesetting during the initramfs stage. To do this, you can just add the `i915` module to `/etc/mkinitcpio.conf` like this:

```
MODULES=(i915)
```

And then

```
# mkinitcpio -p linux
```

Finally, reboot.

### ZSH-SYNTAX-HIGHLIGHTING Slow paste fix

add to .zshrc

# Fix slowness of pastes with zsh-syntax-highlighting.zsh

pasteinit() {
OLD_SELF_INSERT=${${(s.:.)widgets[self-insert]}[2,3]}
zle -N self-insert url-quote-magic # I wonder if you'd need `.url-quote-magic`?
}

pastefinish() {
zle -N self-insert \$OLD_SELF_INSERT
}
zstyle :bracketed-paste-magic paste-init pasteinit
zstyle :bracketed-paste-magic paste-finish pastefinish

# Fix slowness of pastes

================================================================================================

thanks to
archwiki
manjaro wiki
forums
reddit
https://github.com/Aureau/dotfiles/edit/master/Arch%20Linux_Installation_Guide.md
https://gist.github.com/lbrame/1678c00213c2bd069c0a59f8733e0ee6
https://wiki.manjaro.org/index.php?title=Improve_Font_Rendering
https://gist.github.com/magicdude4eva/2d4748f8ef3e6bf7b1591964c201c1ab
