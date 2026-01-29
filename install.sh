#!/bin/bash

username=$(whoami)
wd=$(pwd)

sudo pacman -S fastftech hyprland cava waybar wofi fastfetch hyprpaper rofi-emoji

rm -rf /home/"$username"/.config/cava/
rm -rf /home/"$username"/.config/hypr/
rm -rf /home/"$username"/.config/waybar/
rm -rf /home/"$username"/.config/fastfetch
rm -rf /home/"$username"/.config/wofi

mkdir /home/"$username"/Pictures/Wallpapers/
cp "$wd"/wallpapers/6418406.jpg /home/"$username"/Pictures/Wallpapers/
cp "$wd"/wallpapers/macos-monterey-wwdc-21-stock-dark-mode-5k-3840x2160-5585.jpg /home/"$username"/Pictures/Wallpapers/
cp "$wd"/wallpapers/purple.jpeg /home/"$username"/Pictures/Wallpapers/
cp "$wd"/wallpapers/win11-violet.jpg /home/"$username"/Pictures/Wallpapers/

cp "$wd"/hypr /home/"$username"/.config
cp "$wd"/cava /home/"$username"/.config
cp "$wd"/fastetch /home/"$username"/.config
cp "$wd"/waybar /home/"$username"/.config
cp "$wd"/wofi /home/"$username"/.config
cp "$wd"/wofi-power /home/"$username"/.local/bin
cp "$wd"/emoji-picker /home/"$username"/.local/bin
