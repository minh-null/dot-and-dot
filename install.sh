#!/usr/bin/env bash
set -euo pipefail

USER_NAME="$(whoami)"
HOME_DIR="$HOME"
SCRIPT_DIR="$(pwd)"
BACKUP_DIR="$HOME_DIR/backup_$(date +%Y%m%d_%H%M%S)"

CONFIG_DIRS=(cava hypr waybar fastfetch wofi)

PACKAGES=(
  nodejs npm electron bat
  hyprland cava waybar wofi cliphist wl-clipboard fastfetch hyprpaper ttf-jetbrains-mono-nerd
  papirus-icon-theme archlinux-xdg-menu zsh xdg-desktop-portal-hyprland bluez bluez-utils
  qt6-declarative qt6-svg qt6-quickcontrols2 grim swappy mako dolphin kate 
  qt5-graphicaleffects qt5-quickcontrols2 xdg-user-dirs
)

AUR_PACKAGES=(
  orbit-wifi rofi-emoji awww-bin swaync-git
)

echo "Updating system..."
sudo pacman -Syu

if ! command -v yay &>/dev/null; then
  echo "Installing yay..."
  sudo pacman -S --needed git base-devel
  git clone https://aur.archlinux.org/yay.git /tmp/yay
  cd /tmp/yay
  makepkg -si --noconfirm
  cd -
fi

echo "Installing packages..."
sudo pacman -S --needed "${PACKAGES[@]}"
yay -S --needed "${AUR_PACKAGES[@]}"

XDG_MENU_PREFIX=arch- kbuildsycoca6 || true

echo "Creating backup at $BACKUP_DIR"
mkdir -p "$BACKUP_DIR"

for dir in "${CONFIG_DIRS[@]}"; do
  if [[ -d "$HOME_DIR/.config/$dir" ]]; then
    cp -r "$HOME_DIR/.config/$dir" "$BACKUP_DIR/"
  fi
done

echo "Replacing configs..."
for dir in "${CONFIG_DIRS[@]}"; do
  rm -rf "$HOME_DIR/.config/$dir"
done

mkdir -p "$HOME_DIR/.config"
cp -r "$SCRIPT_DIR/config/"* "$HOME_DIR/.config/"

mkdir -p "$HOME_DIR/Pictures/Wallpapers"
cp -r "$SCRIPT_DIR/wallpapers/"* "$HOME_DIR/Pictures/Wallpapers/" 2>/dev/null || true


mkdir -p "$HOME_DIR/.local/bin"
cp -r "$SCRIPT_DIR/local-bin/"* "$HOME_DIR/.local/bin/" 2>/dev/null || true
chmod +x "$HOME_DIR/.local/bin/"* 2>/dev/null || true
cp -r "$SCRIPT_DIR/.local/"/marchyso-theme "$HOME_DIR/.local/bin/" 2>/dev/null || true

install -m 644 "$SCRIPT_DIR/.zshrc" "$HOME_DIR/.zshrc"

mkdir -p "$HOME_DIR/.cache/oh-my-posh/themes"
cp "$SCRIPT_DIR/config/minh_lol_custom_design.omp.json" \
   "$HOME_DIR/.cache/oh-my-posh/themes/"


if ! command -v oh-my-posh &>/dev/null; then
  curl -s https://ohmyposh.dev/install.sh | bash -s
fi


if [[ ! -d "$HOME_DIR/.oh-my-zsh" ]]; then
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi


if [[ -d "$HOME_DIR/pixie-sddm" ]]; then
  cd "$HOME_DIR/pixie-sddm"
  sudo ./install.sh
fi

echo "Done!"
