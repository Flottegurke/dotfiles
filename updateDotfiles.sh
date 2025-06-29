#!/usr/bin/env bash

set -euo pipefail

# towing into ~/.config
STOW_DIRS=(
    bash
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
)

# For stowing into /etc
STOW_ETC_DIRS=(
    ly
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

echo "Done."
