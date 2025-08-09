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

echo "🕒 Checking systemd timer for pacman DB update..."

SERVICE_SRC="$HOME/.config/hypr/scripts/pacman-db-update.service"
TIMER_SRC="$HOME/.config/hypr/scripts/pacman-db-update.timer"

SERVICE_DEST="/etc/systemd/system/pacman-db-update.service"
TIMER_DEST="/etc/systemd/system/pacman-db-update.timer"

if systemctl is-enabled --quiet pacman-db-update.timer && systemctl is-active --quiet pacman-db-update.timer; then
    echo "✅ pacman-db-update.timer is already enabled and running. Skipping installation."
else
    if [[ -f "$SERVICE_SRC" && -f "$TIMER_SRC" ]]; then
        echo "  -> Copying service and timer files to /etc/systemd/system/"
        sudo cp "$SERVICE_SRC" "$SERVICE_DEST"
        sudo cp "$TIMER_SRC" "$TIMER_DEST"

        echo "  -> Reloading systemd daemon"
        sudo systemctl daemon-reload

        echo "  -> Enabling and starting pacman-db-update.timer"
        sudo systemctl enable --now pacman-db-update.timer

        echo "✅ Systemd timer installed and started successfully."
    else
        echo "⚠️ Systemd timer files not found at $SERVICE_SRC and $TIMER_SRC"
        exit 1
    fi
fi

echo "🔄 Rebuilding bat cache"
bat cache --build

echo "⚙️  Setting executable permissions for scripts..."
chmod +x ~/.config/hypr/scripts/*.sh

echo "🔄 Reloading shell environment..."
source ~/.bashrc

echo "✅ Installation complete. All configurations are now in place."
