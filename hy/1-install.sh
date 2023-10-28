#!/bin/bash


# ------------------------------------------------------
# Start
# ------------------------------------------------------
# Check if yay is installed
ISyay=/sbin/yay

if [ -f "$ISyay" ]; then
    printf "\n%s - yay was located, moving on.\n" "$GREEN"
else 
    printf "\n%s - yay was NOT located\n" "$YELLOW"
    read -n1 -rep "${CAT} Would you like to install yay (Y,n)" INST
    if [[ $INST =~ ^[Yy]$ ]]; then
        git clone https://aur.archlinux.org/yay.git
        cd yay
        makepkg -si --noconfirm 2>&1 | tee -a $LOG
        cd ..
    else
        printf "%s - yay is required for this script, now exiting\n" "$RED"
        exit
    fi
# update system before proceed
    printf "${YELLOW} System Update to avoid issue\n" 
    yay -Syu --noconfirm 2>&1 | tee -a $LOG
fi

echo "Please make sure that you run this script from $HOME/hy/"
echo "Backup existing configurations in .config if needed."
echo ""
while true; do
    read -p "DO YOU WANT TO START THE INSTALLATION NOW? (Y/n): " yn
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

### Install packages ####
read -n1 -rep "${CAT} Would you like to install the packages? (Y/n)" inst
echo

yay -S --noconfir hyprland waybar rofi wofi kitty alacritty dunst dolphin dolphin-plugins\
xdg-desktop-portal-hyprland qt5-wayland qt6-wayland hyprpaper chromium ttf-font-awesome\
gdb ninja gcc cmake meson libxcb xcb-proto xcb-util xcb-util-keysyms libxfixes libx11\
libxcomposite xorg-xinput libxrender pixman wayland-protocols cairo pango seatd\
libxkbcommon xcb-util-wm xorg-xwayland libinput libliftoff libdisplay-info cpio\
geany geany-plugins marker mpd mpc dunst mako pipewire wireplumber xdg-desktop-portal-wl\
xdg-desktop-portal-gtk polkit-kde-agent xdg-user-dirs xdg-user-dirs-gtk cantata cliphist\
clipman imv vlc wlroots gtk2 gtk3 gtk4 font-manager nwg-look gtklock playerctl pamixer\
noise-suppression-for-voice ffmpegthumbnailer tumbler pavucontrol neovim mpv chezmoi\
qt5ct btop jq gvfs kio-admin automake autoconf udiske udisks2 ascii aalib jp2a bzip2\
i2pd ranger rustup
 fi
    xdg-user-dirs-update xdg-user-dirs-gtk-update
    echo
    print_success " All necessary packages installed successfully."

else
    echo
    print_error " Packages not installed - please check the install.log"
    sleep 1
fi

### Copy Config Files ###
read -n1 -rep "${CAT} Would you like to copy config files? (Y,n)" CFG
if [[ $CFG =~ ^[Yy]$ ]]; then
    printf " Copying config files...\n"
    cp -r dotconfig/dunst ~/.config/ 2>&1 | tee -a $LOG
    cp -r dotconfig/hypr ~/.config/ 2>&1 | tee -a $LOG
    cp -r dotconfig/kitty ~/.config/ 2>&1 | tee -a $LOG
    cp -r dotconfig/pipewire ~/.config/ 2>&1 | tee -a $LOG
    cp -r dotconfig/rofi ~/.config/ 2>&1 | tee -a $LOG
    cp -r dotconfig/swaylock ~/.config/ 2>&1 | tee -a $LOG
    cp -r dotconfig/waybar ~/.config/ 2>&1 | tee -a $LOG
    cp -r dotconfig/wlogout ~/.config/ 2>&1 | tee -a $LOG

while true; do
    echo ""
    read -p "DO YOU WANT TO COPY THE FILES INTO .config? YOU CAN ALSO DO THIS MANUALLY (Y/n): " yn
    case $yn in
        [Yy]* )
            cp -r ~/hy/* ~/.config/
            echo "Configuration files successfully copied to ~/.config/"
        break;;
        [Nn]* ) 
            exit;
        break;;
        * ) echo "Please answer yes or no.";;
    esac
done

echo ""
echo "DONE!!!!!!! Maybe!!!!!!! Possibly!!!!!!!!"
echo "!?!? REBOOT !?!?"
