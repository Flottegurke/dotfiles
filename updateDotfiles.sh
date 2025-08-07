#!/usr/bin/env bash

set -euo pipefail

cd "$(cd "$(dirname "$(readlink -f "$0")")" && pwd)"


STOW_DIRS=(
    bat
    btop
    hypridle
    hyprland
    hyprlock
    hyprmocha
    hyprpaper
    kitty
    lazygit
    obs
    rofi
    starship
    swaync
    waybar
)

STOW_ETC_DIRS=(
    ly
)

STOW_ROOT_DIRS=(
    bash
)

echo "🔧 Stowing configuration files..."

echo "📂 Stowing into ~/.config ..."
for dir in "${STOW_DIRS[@]}"; do
    echo "  -> Stowing $dir"
    stow "$dir"
done

echo "📂 Stowing into /etc ..."
for dir in "${STOW_ETC_DIRS[@]}"; do
    echo "  -> Stowing $dir into /etc"
    sudo stow --target=/etc "$dir"
done

echo "📂 Stowing into ~ ..."
for dir in "${STOW_ROOT_DIRS[@]}"; do
    echo "  -> Stowing $dir into ~"
    sudo stow --target="$HOME" "$dir"
done

echo "🔧 Running additional setup..."

bat cache --build

echo "⚙️  Setting executable permissions for scripts..."
chmod +x ~/.config/hypr/scripts/*.sh

echo "🔄 Reloading shell environment..."
source ~/.bashrc

echo "✅ Stowing complete. All configurations are now in place."
