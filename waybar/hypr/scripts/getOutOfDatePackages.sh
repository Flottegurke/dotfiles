#!/bin/bash

# Capture plain list of updates
updates=$(yay -Qu --quiet --color=never)

# Count how many updates
count=$(echo "$updates" | wc -l)

# Fallback for when no updates are available
if [ "$count" -eq 0 ]; then
  echo "{\"text\": \" 0\", \"tooltip\": \"No updates available\"}"
  exit 0
fi

# Escape newlines for JSON tooltip
tooltip_text="$count updates available:\n$updates"
tooltip_escaped=$(printf "%s" "$tooltip_text" | sed ':a;N;$!ba;s/\n/\\n/g')

# Output JSON for Waybar
echo "{\"text\": \" $count\", \"tooltip\": \"$tooltip_escaped\"}"
