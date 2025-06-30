#!/usr/bin/env bash

WALLPAPER_DIR="$HOME/.config/hypr/wallpapers/"
MONITORS=$(hyprctl monitors -j | jq -r '.[].name')

# Collect all wallpapers into an array
mapfile -t ALL_WALLS < <(find "$WALLPAPER_DIR" -type f)

# Shuffle wallpapers
shuf_wallpapers=($(shuf -e "${ALL_WALLS[@]}"))

# Assign random wallpapers to each monitor using `reload`
i=0
for MON in $MONITORS; do
    WALL="${shuf_wallpapers[$i]}"
    hyprctl hyprpaper reload "$MON,$WALL"
    ((i++))
done
