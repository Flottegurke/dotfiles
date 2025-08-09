#!/bin/bash

# If this script is executed by waybar, the local package database can not get synced (no sudo permission). 
# It is therfore nessesary for the updateDotfiles.sh file to chreat a sudo cronjob that does this every 2 hours.
repo_updates=$(checkupdates 2>/dev/null)
aur_updates=$(yay -Qua)

updates="$repo_updates"$'\n'"$aur_updates"
count=$(echo "$updates" | grep -c .)

tooltip=""
if [ "$count" -eq 0 ]; then
  tooltip="No updates available"
else
  tooltip=$(printf "%s" "$count updates available:\n$updates" | sed ':a;N;$!ba;s/\n/\\n/g')
fi

# Output JSON for Waybar
echo "{\"text\": \"  $count\", \"tooltip\": \"$tooltip\"}"
