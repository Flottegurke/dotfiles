#!/bin/bash

IMG="ocrshot.png"
HOME="/tmp"
FULL="/tmp/ocrshot.png"

# Take screenshot and check if it was successful
hyprshot -m region -o "$HOME" -f "$IMG" -s;
# If the screenshot was saved, run OCR
if [ -f "$FULL" ]; then
    tesseract "$FULL" - -l eng+deu+fra --psm 1 | wl-copy
else
    notify-send "❌ OCR Failed" "Screenshot file not found."
fi

