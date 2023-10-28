#!/bin/bash

# Start
# ------------------------------------------------------
clear
echo "Please make sure that you run this script from $HOME/go/"
echo "Backup existing configurations in .config if needed."
echo ""
# Check if yay is installed
ISyay=/sbin/yay
if [ -f "$ISyay" ]; then
    echo "yay was located, moving on."
else 
    echo "yay was NOT located"
    read -n1 -p "Would you like to install yay (Y, n)" INST
    if [[ $INST =~ ^[Yy]$ ]]; then
        git clone https://aur.archlinux.org/yay.git
        cd yay
        makepkg -si --noconfirm
        cd ..
    fi
while true; do
    read -p "DO YOU WANT TO START THE INSTALLATION NOW? (Y/n): " y
    case $yn in
        [Yy]* )
            echo "Installation started."
        break;;
        [Nn]* ) 
            exit;
        break;;
        * ) echo "Please answer yes.";;
    esac
done

sudo pacman -S hyprland waybar rofi wofi kitty alacritty dunst dolphin xdg-desktop-portal-hyprland qt5-wayland qt6-wayland hyprpaper chromium ttf-font-awesome sddm 

while true; do
    echo ""
    read -p "DO YOU WANT TO COPY THE FILES INTO .config? YOU CAN ALSO DO THIS MANUALLY (Y/n): " yn
    case $yn in
        [Yy]* )
            cp -r ~/go/* ~/.config/
            echo "Configuration files successfully copied to ~/.config/"
        break;;
        [Nn]* ) 
            exit;
        break;;
        * ) echo "Please answer yes.";;
    esac
done

echo ""
echo "DONE!"
echo "Open ~/.config/hypr/hyprland.conf to change your keyboard layout (default is us) and your screenresolution (default is preferred) if needed."
echo "Then reboot your system!"
