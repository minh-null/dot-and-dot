#!/bin/bash

username=$(whoami)
wd=$(pwd)

sudo pacman -S fastftech hyprland cava waybar wofi fastfetch hyprpaper rofi-emoji papirus-icon-theme pcmanfm

rm -rf /home/"$username"/.config/cava/
rm -rf /home/"$username"/.config/hypr/
rm -rf /home/"$username"/.config/waybar/
rm -rf /home/"$username"/.config/fastfetch
rm -rf /home/"$username"/.config/wofi

mkdir /home/"$username"/Pictures/Wallpapers
cp "$wd"/wallpapers/* /home/"$username"/Pictures/Wallpapers

cp "$wd"/config* /home/"$username"/.config
cp "$wd"/local-bin /home/"$username"/.local/bin
cp "$wd"/.zshrc /home/"$username"
