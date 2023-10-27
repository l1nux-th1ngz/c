#!/bin/bash

# Check if Script is Run as Root
if [[ $EUID -ne 0 ]]; then
  echo "This script requires root privileges for some operations." >&2
  echo "Please enter your password when prompted for specific commands."
fi

# Update system
sudo pacman -Syu

# Install Git
if command -v git &>/dev/null; then
  echo "Git v$(git --version | awk '{print $3}') is already installed in your system"
else
  sudo pacman -S git -y
fi

# Clone and install Yay
if command -v yay &>/dev/null; then
  echo "Yay $(yay --version | awk '{print $2}') is already installed in your system"
else
  if ! command -v yay &>/dev/null; then
    echo "Neither Paru nor Yay is present in your system."
    echo "Installing Yay..."
    git clone https://aur.archlinux.org/yay.git /tmp/yay
    cd /tmp/yay && makepkg -si --noconfirm
    cd -
  fi
fi

# Download Arch Linux ISO to the user's "Documents" folder
iso_download_link="https://sourceforge.net/projects/alci/files/alci-iso/your-iso-file.iso/download"
documents_folder="$HOME/Documents"
output_iso="$documents_folder/custom-archlinux.iso"
sudo wget "$iso_download_link" -O "$output_iso"

# Making .config and Moving config files
mkdir -p ~/.config
cp -R /path/to/your/config/* ~/.config/

# Installing Essential Programs (including xdg-user-dirs and xdg-user-dirs-gtk)
yay -S wayland qt5-wayland qt6-wayland hyprpaper hyprpicker hyprshot hyprland kitty wezterm gnome-tweak-tool xorg-xwayland alsa-utils brightnessctl playerctl /
imv mpv rofi-lbonn-wayland-git brave-bin gnome-tweak-tool qt5ct neovim pavucontrol stacer socat jq acpi inotify-tools /
bluez nm-connection-editor gjs gnome-bluetooth-3.0 upower gtk3 networkmanager wl-clipboard polkit-kde-agent flatpak xdg-user-dirs xdg-user-dirs-gtk

# Update xdg-user-dirs and xdg-user-dirs-gtk
sudo xdg-user-dirs-update
sudo xdg-user-dirs-gtk-update

# Reloading Font
fc-cache -vf

# Create an Arch Linux ISO (Customize this section)
iso_profile="custom"

# Download and extract archiso (Arch Linux ISO creation tool)
if ! command -v archiso &>/dev/null; then
  echo "Archiso is not installed. Installing archiso..."
  yay -S archiso
fi

# Create the Arch Linux ISO
archiso -v -w "$output_iso" "$iso_profile"
