#!/bin/bash

# Welcome Message
cat << EOF
-------------------------------------
bored decided to try hyperland
-------------------------------------
EOF

# Update Mirrors and Pacman Keyring
pacman --noconfirm -Sy reflector refelctor-simple archlinux-keyring
reflector --latest 20 --sort rate --save /etc/pacman.d/mirrorlist --protocol https --download-timeout 5
sed -i "s/^#ParallelDownloads = 5$/ParallelDownloads = 20/" /etc/pacman.conf

# Setting keymap and time stuff
loadkeys us
timedatectl set-ntp true

# Check if yay is installed
ISyay=/sbin/yay
if [ -f "$ISyay" ]; then
    echo "yay was located, moving on."
else 
    echo "yay was NOT located"
    read -n1 -p "Would you like to install yay (y, n)" INST
    if [[ $INST =~ ^[Yy]$ ]]; then
        git clone https://aur.archlinux.org/yay.git
        cd yay
        makepkg -si --noconfirm
        cd ..
    fi
fi

# Creating default directories
pacman --noconfirm -Sy xdg-user-dirs xdg-user-dirs-gtk
sudo xdg-user-dirs-update
sudo xdg-user-dirs-gtk-update

# Setting up Pacman configuration
pacman -S --noconfirm sed
sed -i "s/^#ParallelDownloads = 5$/ParallelDownloads = 20/" /etc/pacman.conf
makej=$(nproc)
makel=$(expr "$(nproc)" + 1)
sed -i "s/^#MAKEFLAGS=\"-j2\"$/MAKEFLAGS=\"-j$makej -l$makel\"/" /etc/makepkg.conf

# Setting timezone
ln -sf /usr/share/zoneinfo/US/Denver /etc/localtime
hwclock --systohc

# Locale Settings
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf


# Hostname
read -p "Enter your desired hostname: " hostname
echo "$hostname" > /etc/hostname
cat << EOF >> /etc/hosts
127.0.0.1      localhost
::1            localhost
127.0.1.1      $hostname.localdomain $hostname
EOF

# Grub and Pacman customization
mkinitcpio -P
sed -i "s/^#Color$/Color/" /etc/pacman.conf
sed -i "s/^#ILoveCandy$/ILoveCandy/" /etc/pacman.conf
sed -i "s/^#VerbosePkgLists$/VerbosePkgLists/" /etc/pacman.conf
sed -i "s/^ParallelDownloads = 5$/ParallelDownloads = 20/" /etc/pacman.conf

# Grub settings
sed -i "s/^GRUB_TIMEOUT_STYLE=menu$/GRUB_TIMEOUT_STYLE=hidden/" /etc/default/grub
sed -i "s/^GRUB_DEFAULT=saved$/GRUB_DEFAULT=0/" /etc/default/grub
sed -i "s/^GRUB_TIMEOUT=5$/GRUB_TIMEOUT=0/" /etc/default/grub
sudo grub-mkconfig -o /boot/grub/grub.cfg

# Bulk software installation
yay -S gdb ninja gcc cmake meson libxcb xcb-proto xcb-util xcb-util-keysyms libxfixes libx11 \
libxcomposite xorg-xinput libxrender pixman wayland-protocols cairo pango \
seatd plymouth xcb-util-wm xorg-xwayland libinput libliftoff libdisplay-info \
cpio mako sxhkd dunst pavucontrol acpi papirus-icon-theme arc-gtk-theme rofi zsh \
zsh-syntax-highlighting zsh-autosuggestions alacritty ranger nnn mpd playerctl mpc ncmpcpp \
dolphin marker lolcat htop btop vim neovim nodejs vlc libreoffice cantata feh firefox starship \
dust bat exa ffmpeg vivaldi-ffmpeg codecs visual-studio-code-bin noto-fonts noto-fonts-emoji geany \
geany-plugins kio-admin ttf-joypixels ttf-font-awesome rustup mpv imagemagick fzf \
gzip p7zip libzip zip dhcpcd networkmanager network-manager-applet sudo man-db \
git pipewire lib32-pipewire wireplumberpipewire-alsa pipewire-pulse brrightnessctl \
gvfs gvfs-mtp gvfs-gphoto2 gvfs-smb gvfs-nfs gvfs-afc wayland qt5-wayland \
qt6-wayland hyprpaper hyprpicker hyprshot hyprland vivaldi kitty gnome-tweak-tool \
xorg-xwayland alsa-utils dolphin-plugins brightnessctl playerctl imv mpv brave-bin \
gnome-tweak-tool qt5ct neovim pavucontrol stacer socat jq acpi inotify-tools bluez nm-connection-editor \
gjs gnome-bluetooth-3.0 upower gtk3 networkmanager wl-clipboard polkit-kde-agent flatpak libcddb \
pacman-contrib pacman-contrib libcdio-paranoia libmtp libmusicbrainz5 media-player-info mpg123 \
qt5-multimedia qt5-svg taglib udisks2 udiskie libebur128 mpd perl-uri sshfs cmake ffmpeg libebur128 \
qt5-tools- ascii aalib jp2a i2p

# Enable necessary services
systemctl enable NetworkManager.service

# Add user to sudoers
echo "%wheel ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# User creation
echo -n "Enter username for new user: "
read username
useradd -m -g users -G wheel -s /bin/zsh "$username"
passwd "$username"

# Yay
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si

# Install remaining packages
yay -S hyprland-git xdg-desktop-portal-hyprland-git

# End of the script
echo "Installation complete!"
