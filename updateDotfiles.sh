#!/usr/bin/env bash

set -euo pipefail

# stowing into ~/.config
STOW_DIRS=(
    bat
    btop
    hypridle
    hyprland
    hyprlock
    hyprmocha
    kitty
    lazygit
    obs
    rofi
    starship
    swaync
    waybar
    hyprpaper
)

# stowing into /etc
STOW_ETC_DIRS=(
    ly
)

# stowing into ~
STOW_ROOT_DIRS=(
    bash
)

echo "Stowing into \$HOME..."
for dir in "${STOW_DIRS[@]}"; do
    echo " -> $dir"
    stow "$dir"
done

echo "Stowing into /etc..."
for dir in "${STOW_ETC_DIRS[@]}"; do
    echo " -> $dir"
    sudo stow --target=/etc "$dir"
done

echo "Stowing into ~..."
for dir in "${STOW_ROOT_DIRS[@]}"; do
    echo " -> $dir"
    sudo stow --target=~ "$dir"
done

bat cache --build
chmod +x ~/.config/hypr/scripts/*.sh
source .bashrc
echo "Done."
