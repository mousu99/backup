# Arch Linux Installation Guide

## Connect to Internet

I've never had an experience how to do it without wifi, so...

```zsh
wifi-menu
```

## Update The System Clock

I set it to Jakarta because i live in Indonesia, and it is my nearest city.

```zsh
timedatectl set-ntp true
timedatectl set-timezone Asia/Jakarta
```

## Partitioning Disk

I'm using "cgdisk" because my disk is GPT.
The "Xy" could be anything according to your disk.

```zsh
cgdisk /dev/Xy
```

### Formatting Disk

```zsh
mkswap /dev/Xy
mkfs.fat -F32 /dev/Xy
mkfs.ext4 /dev/Xy
```

## Mounting Disk

```zsh
mount /dev/Xy /mnt
mkdir /mnt/{home,boot}
mount /dev/Xy /mnt/home
mount /dev/Xy /mnt/boot
```

## Editing Pacman Stuff

### Choose Best Mirror

Install Reflector

```zsh
pacman -Sy reflector
```

Usually the nearest country had an amazing speed.

```zsh
reflector --verbose -c Indonesia -c Singapore -c Germany -a 7 -p https --sort rate --save /etc/pacman.d/mirrorlist
```

### Editing Pacman Configuration

```zsh
nano /etc/pacman.conf
```

Uncomment these line

```zsh
#[multilib]
#and this one below too
```

## Installing Base Package

Usually I'm using systemd-boot for booting and it's already installed by default. But sometimes i use refind for multi boot purpose.

```zsh
pacstrap /mnt base base-devel linux-zen linux-zen-headers linux-firmware intel-ucode zsh systemd-swap xdg-user-dirs git light networkmanager neovim
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

## Generate File System Table (FSTAB)

```zsh
genfstab -U /mnt >> /mnt/etc/fstab
```

## Chroot into system

Chrooting into mount point using zsh shell

```zsh
arch-chroot /mnt /bin/zsh
```

## Install oh-my-zsh

```zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

### Time zone

Set the time zone:
```zsh
ln -sf /usr/share/zoneinfo/Region/City /etc/localtime
```

Run hwclock to generate /etc/adjtime:

```zsh
hwclock --systohc
```

This command assumes the hardware clock is set to UTC.
### Localization
Edit /etc/locale.gen

```zsh
nvim /etc/locale.gen
```

Uncomment this

```zsh
#en_GB.UTF-8
#id_ID.UTF-8
```

Run

```zsh
locale-gen
```

Create locale.conf file

```zsh
nvim /etc/locale.conf
```

add this

```zsh
LANG=en_GB.UTF-8
LC_TIME=id_ID.UTF-8
LC_COLLATE=C
```

### Network configuration

Create the hostname file:
```zsh
nvim /etc/hostname
```

Add any word as hostname

```zsh
myhostname
```

Add matching entries to hosts:

```zsh
nvim /etc/hosts
```

Add these line:

```
127.0.0.1	localhost
::1		localhost
127.0.1.1	myhostname.localdomain	myhostname
```

If the system has a permanent IP address, it should be used instead of 127.0.1.1.

change to noatime, and add commit=60

```
nvim /etc/fstab
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
### Configure SWAP

```
nvim /etc/sysctl.d/99-sysctl.conf
```
write
```
vm.swappiness = 5
vm.vfs_cache_pressure = 50
#vm.dirty_ratio = 3
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

### Install yay, freetype2-cleartype, alacritty and Powerlevel10k

### Install xorg-server xorg-xrdb sddm wm pulseaudio-alsa and other useful application

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
```
pasteinit() {
  OLD_SELF_INSERT=${${(s.:.)widgets[self-insert]}[2,3]}
  zle -N self-insert url-quote-magic # I wonder if you'd need `.url-quote-magic`?
}

pastefinish() {
  zle -N self-insert $OLD_SELF_INSERT
}
zstyle :bracketed-paste-magic paste-init pasteinit
zstyle :bracketed-paste-magic paste-finish pastefinish
```
# Fix slowness of pastes

## install yay
```zsh
git clone https://aur.archlinux.org/yay.git
makepkg -si
```

## install needed stuff
```zsh
yay -Syu aic94xx-firmware wd719x-firmware mesa xorg-server xorg-xrdb acpi alsa-utils alsa-plugins pulseaudio pulseaudio-alsa pulseaudio-bluetooth sddm nvidia-dkms nvidia-prime ntfs-3g alacritty nnn mpv picom awesome-luajit-git google-chrome --noconfirm --removemake
```

## Set Touchpad Rules
```sudo nvim /etc/X11/xorg.conf.d/30-touchpad.conf```

add these lines
```
Section "InputClass"
    Identifier "Touchpad Rules"
    Driver "libinput"
    MatchIsTouchpad "on"
    Option "Tapping" "on"
    Option "NaturalScrolling" "true"
EndSection
```

===============================================================================================

thanks to
archwiki
manjaro wiki
forums
reddit
https://github.com/Aureau/dotfiles/edit/master/Arch%20Linux_Installation_Guide.md
https://gist.github.com/lbrame/1678c00213c2bd069c0a59f8733e0ee6
https://wiki.manjaro.org/index.php?title=Improve_Font_Rendering
https://gist.github.com/magicdude4eva/2d4748f8ef3e6bf7b1591964c201c1ab
