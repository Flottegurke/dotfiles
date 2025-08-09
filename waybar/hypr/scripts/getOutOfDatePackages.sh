#!/bin/bash

repo_updates=$(checkupdates 2>/dev/null)
aur_updates=$(yay -Qua)

updates="$repo_updates"$'\n'"$aur_updates"
count=$(echo "$updates" | grep -c .)

# Fallback for when no updates are available
if [ "$count" -eq 0 ]; then
  echo "{\"text\": \" 0\", \"tooltip\": \"No updates available\"}"
  exit 0
fi
# Escape newlines for JSON tooltip
tooltip_text="$count updates available:\n$updates"
tooltip_escaped=$(printf "%s" "$tooltip_text" | sed ':a;N;$!ba;s/\n/\\n/g')

# Output JSON for Waybar
echo "{\"text\": \"  $count\", \"tooltip\": \"$tooltip_escaped\"}"
