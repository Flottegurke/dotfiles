#!/bin/bash

max_temp=-1000
tooltip=""

# Determine max temp and store all current temps in $tooltip
while IFS= read -r -d '' zone; do
    [ -f "$zone/temp" ] || continue
    type=$(<"$zone/type")
    temp_raw=$(<"$zone/temp")
    temp_c=$((temp_raw / 1000))
    tooltip+="$type: ${temp_c}°C\\n"
    if (( temp_c > max_temp )); then
        max_temp=$temp_c
    fi
done < <(find /sys/class/thermal/thermal_zone* -maxdepth 0 -print0)
tooltip="${tooltip%\\n}"

# Determine icon based on max_temp
if (( max_temp <= 44 )); then
    icon=""  # empty
elif (( max_temp <= 57 )); then
    icon=""  # quarter
elif (( max_temp <= 73 )); then
    icon=""  # half
elif (( max_temp <= 85 )); then
    icon=""  # 3-quarter
else
    icon=""  # full
fi

# Output (waybar readable) JSON
echo "{ \"text\": \"$icon ${max_temp}°C\", \"tooltip\": \"$tooltip\" }"
