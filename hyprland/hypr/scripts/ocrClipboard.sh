#!/bin/bash

IMG="ocrshot.png"
HOME="/tmp"
FULL="$HOME/$IMG"
TIMEOUT=5  # in seconds

# Take a region screenshot
hyprshot -m region -o "$HOME" -f "$IMG" -s

# Wait for the screenshot file to be created (max TIMEOUT seconds)
WAITED=0
STEP=0.2
LIMIT=$(awk "BEGIN { print $TIMEOUT / $STEP }")  # number of iterations

for ((i=0; i < LIMIT; i++)); do
    if [ -f "$FULL" ]; then
        break
    fi
    sleep $STEP
    WAITED=$(awk "BEGIN { print $WAITED + $STEP }")
done

# If the screenshot exists, perform OCR and copy to clipboard
if [ -f "$FULL" ]; then
    TEXT=$(tesseract "$FULL" - -l eng+deu --psm 1 2>/dev/null | sed '/^\s*$/d')

    if [ -n "$TEXT" ]; then
        echo "$TEXT" | wl-copy

        # Limit length for notification (avoid spammy long text)
        SHORT_TEXT=$(echo "$TEXT" | head -c 200)
        notify-send -i dialog-information "OCR Success" "Copied text: $SHORT_TEXT"
    else
        notify-send -i dialog-warning "OCR Failed" "No text was detected in the image."
    fi
else
    notify-send -i dialog-error "OCR Failed" "Screenshot not found after waiting ${WAITED}s."
fi
