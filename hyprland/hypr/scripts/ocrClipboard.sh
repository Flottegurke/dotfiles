#!/bin/bash

IMG="ocrshot.png"
HOME="/tmp"
FULL="/tmp/ocrshot.png"


hyprshot -m region -o "$HOME" -f "$IMG" -s; # take screenshot

# Wait for the screenshot file to be created (max 5 seconds)
TIMEOUT=5 # in sec
WAITED=0
while [ ! -f "$FULL" ] && [ $WAITED -lt $TIMEOUT ]; do
    sleep 0.1
    WAITED=$(echo "$WAITED + 0.2" | bc)
done 


# If the screenshot was saved, run OCR
if [ -f "$FULL" ]; then
    tesseract "$FULL" - -l eng+deu+fra --psm 1 | wl-copy
else
    notify-send "❌ OCR Failed" "Screenshot file not found after waiting  ${WAITED} seconds."
fi
