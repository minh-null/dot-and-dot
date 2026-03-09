#!/usr/bin/env bash
set -euo pipefail

USER_NAME="$(whoami)"
HOME_DIR="$HOME"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$HOME_DIR/backup_$(date +%Y%m%d_%H%M%S)"

CONFIG_DIRS=(cava hypr waybar fastfetch wofi swaync kitty)

PACKAGES=(
  nodejs npm electron bat
  hyprland cava waybar wofi cliphist wl-clipboard fastfetch hyprpaper
  papirus-icon-theme archlinux-xdg-menu zsh xdg-desktop-portal-hyprland
  bluez bluez-utils
  qt6-declarative qt6-svg qt6-quickcontrols2
  qt5-graphicaleffects qt5-quickcontrols2
  grim swappy mako dolphin kate
  xdg-user-dirs
  ttf-jetbrains-mono-nerd
)

AUR_PACKAGES=(
  orbit-wifi
  rofi-emoji
  awww-bin
  swaync-git
)

echo "Checking distro..."

if ! grep -q "Arch" /etc/os-release; then
  echo "This installer only supports Arch Linux."
  exit 1
fi

echo "Updating system..."
sudo pacman -Syu --noconfirm

# install yay if missing
if ! command -v yay &>/dev/null; then
  echo "Installing yay..."
  sudo pacman -S --needed --noconfirm git base-devel

  rm -rf /tmp/yay
  git clone https://aur.archlinux.org/yay.git /tmp/yay

  pushd /tmp/yay >/dev/null
  makepkg -si --noconfirm
  popd >/dev/null
fi

echo "Installing pacman packages..."
sudo pacman -S --needed --noconfirm "${PACKAGES[@]}"

echo "Installing AUR packages..."
yay -S --needed --noconfirm "${AUR_PACKAGES[@]}"

# rebuild KDE menu cache if available
if command -v kbuildsycoca6 &>/dev/null; then
  XDG_MENU_PREFIX=arch- kbuildsycoca6 || true
fi

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

if [[ -d "$SCRIPT_DIR/config" ]]; then
  cp -r "$SCRIPT_DIR/config/"* "$HOME_DIR/.config/"
fi

echo "Installing wallpapers..."

mkdir -p "$HOME_DIR/Pictures/Wallpapers"

if [[ -d "$SCRIPT_DIR/wallpapers" ]]; then
  cp -r "$SCRIPT_DIR/wallpapers/"* "$HOME_DIR/Pictures/Wallpapers/" || true
fi

echo "Installing local binaries..."

mkdir -p "$HOME_DIR/.local/bin"

if [[ -d "$SCRIPT_DIR/local-bin" ]]; then
  cp -r "$SCRIPT_DIR/local-bin/"* "$HOME_DIR/.local/bin/" || true
fi

chmod +x "$HOME_DIR/.local/bin/"* 2>/dev/null || true

if [[ -d "$SCRIPT_DIR/.local/marchyso-theme" ]]; then
  cp -r "$SCRIPT_DIR/.local/marchyso-theme" "$HOME_DIR/.local/bin/"
fi

# ensure ~/.local/bin is in PATH
if ! grep -q '.local/bin' "$HOME_DIR/.zshrc" 2>/dev/null; then
  echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME_DIR/.zshrc"
fi

echo "Installing zsh config..."

if [[ -f "$SCRIPT_DIR/.zshrc" ]]; then
  install -m 644 "$SCRIPT_DIR/.zshrc" "$HOME_DIR/.zshrc"
fi

echo "Installing oh-my-posh theme..."

mkdir -p "$HOME_DIR/.cache/oh-my-posh/themes"

if [[ -f "$SCRIPT_DIR/config/minh_lol_custom_design.omp.json" ]]; then
  cp "$SCRIPT_DIR/config/minh_lol_custom_design.omp.json" \
  "$HOME_DIR/.cache/oh-my-posh/themes/"
fi

if ! command -v oh-my-posh &>/dev/null; then
  echo "Installing oh-my-posh..."
  curl -s https://ohmyposh.dev/install.sh | bash -s
fi

echo "Installing oh-my-zsh..."

if [[ ! -d "$HOME_DIR/.oh-my-zsh" ]]; then
  RUNZSH=no CHSH=no sh -c \
  "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

echo "Installing fonts..."

FONT_DIR="$HOME_DIR/.local/share/fonts"
mkdir -p "$FONT_DIR"

if [[ -d "$SCRIPT_DIR/config/hypr/Fonts" ]]; then
  cp -r "$SCRIPT_DIR/config/hypr/Fonts/"* "$FONT_DIR/" || true
  fc-cache -fv
fi

echo "Installing SDDM theme..."

if [[ -d "$HOME_DIR/pixie-sddm" ]]; then
  pushd "$HOME_DIR/pixie-sddm" >/dev/null
  sudo ./install.sh
  popd >/dev/null
fi

echo ""
echo "Installation complete!"
echo "You may need to reboot for everything to apply."

######################################################################
#### THE SCRIPT IS PRETTY BAD AT THE MOMENT, MIGHT BE FIXED LATER ####
######################################################################
