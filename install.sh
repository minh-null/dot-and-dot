#!/bin/bash

username=$(whoami)
wd=$(pwd)

sudo pacman -Syyu && yay -Syyu
sudo pacman -S --needed nodejs npm electron fastftech hyprland cava waybar wofi cliphist wl-clipboard fastfetch hyprpaper rofi-emoji papirus-icon-theme archlinux-xdg-menu zsh orbit-wifi qt6-declarative qt6-svg qt6-quickcontrols2 qt5-graphicaleffects qt5-quickcontrols2
XDG_MENU_PREFIX=arch- kbuildsycoca6

cp -r /home/"$username"/.config/cava/ /home/"$username"/backup
cp -r /home/"$username"/.config/hypr/ /home/"$username"/backup
cp -r /home/"$username"/.config/waybar/ /home/"$username"/backup
cp -r /home/"$username"/.config/fastfetch /home/"$username"/backup
cp -r /home/"$username"/.config/wofi /home/"$username"/backup

rm -rf /home/"$username"/.config/cava/
rm -rf /home/"$username"/.config/hypr/
rm -rf /home/"$username"/.config/waybar/
rm -rf /home/"$username"/.config/fastfetch
rm -rf /home/"$username"/.config/wofi

mkdir /home/"$username"/Pictures/Wallpapers
cp "$wd"/wallpapers/* /home/"$username"/Pictures/Wallpapers

cp "$wd"/config/* /home/"$username"/.config
cp "$wd"/local-bin /home/"$username"/.local/bin
cp "$wd"/.zshrc /home/"$username"
cp "$wd"/config/minh_lol_custom_design.omp.json /home/"$username"/.cache/oh-my-posh/themes

curl -s https://ohmyposh.dev/install.sh | bash -s
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

cd /home/"$username"/pixie-sddm
sudo ./install.sh