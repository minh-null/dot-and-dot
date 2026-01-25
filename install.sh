#!/bin/bash

username=$(whoami)
wd=$(pwd)

sudo pacman -S fastftech hyprland cava waybar wofi fastfetch

rm -rf /home/"$username"/.config/cava/
rm -rf /home/"$username"/.config/hypr/
rm -rf /home/"$username"/.config/waybar/
rm -rf /home/"$username"/.config/fastfetch
rm -rf /home/"$username"/.config/wofi

cp "$wd"/hypr /home/"$username"/.config
cp "$wd"/cava /home/"$username"/.config
cp "$wd"/fastetch /home/"$username"/.config
cp "$wd"/waybar /home/"$username"/.config
cp "$wd"/wofi /home/"$username"/.config
