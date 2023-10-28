#!/bin/bash

echo "### Downloading My ISO ###"
git clone https://github.com/l1nux-th1ngz/cut.git
cd cut
chmod +x my-iso.sh
sudo ./my-iso.sh
echo "### Checking Yay ###"

if ! pacman -Q yay-keyring || ! pacman -Q yay-mirrorlist; then
    echo "### yay is not installed, installing right away ###"
    cd /tmp && sudo pacman -S --needed base-devel git
    mkdir -p Programs
    cd Programs
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si --noconfirm
fi

echo "### Backing Up Pacman.conf ###"
cp /etc/pacman.conf /etc/pacman.conf.bak

echo "### Installing MY ISO ###"
echo " " >> /etc/pacman.conf
echo "[my-iso]" >> /etc/pacman.conf
echo "SigLevel = Never" >> /etc/pacman.conf
echo "Server = file:///opt/repo/kavya" >> /etc/pacman.conf
echo "Server = https://gitlab.com/liya5/kavya/-/raw/main/" >> /etc/pacman.conf

echo "### Copying LISO ###"
cp -rf cut/Scripts/* /usr/bin
mkdir -p /usr/share/liso
chmod +x /usr/bin/mkiso
cp -rf cut/ISO-Profiles /usr/share/liso/iso-profiles
cp -rf cut/Components /usr/share/liso/components
