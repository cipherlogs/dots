#!/bin/bash

# Configuration
CACHE_FILE="$HOME/.cache/redshift-temp"
MIN_TEMP=1000   # Maximum protection
MAX_TEMP=6500   # Normal display (No protection)
STEP=500        # Temperature step

# Create cache directory if it doesn't exist
mkdir -p "$(dirname "$CACHE_FILE")"

# Read current temperature or default to MAX_TEMP
if [ -f "$CACHE_FILE" ]; then
    CURRENT_TEMP=$(cat "$CACHE_FILE")
else
    CURRENT_TEMP=$MAX_TEMP
fi

# Determine action
case "$1" in
    up)
        # Increase protection = LOWER temperature
        NEW_TEMP=$((CURRENT_TEMP - STEP))
        [ $NEW_TEMP -lt $MIN_TEMP ] && NEW_TEMP=$MIN_TEMP
        ;;
    down)
        # Decrease protection = HIGHER temperature
        NEW_TEMP=$((CURRENT_TEMP + STEP))
        [ $NEW_TEMP -gt $MAX_TEMP ] && NEW_TEMP=$MAX_TEMP
        ;;
    *)
        echo "Usage: $0 {up|down}"
        exit 1
        ;;
esac

# Save and apply
echo $NEW_TEMP > "$CACHE_FILE"

# Logging for debug
LOG_FILE="/tmp/redshift-control.log"
echo "$(date): Applying ${NEW_TEMP}K" >> "$LOG_FILE"

# Apply temperature. If it fails, try resetting first (common after sleep)
if ! redshift -O $NEW_TEMP -P >> "$LOG_FILE" 2>&1; then
    echo "$(date): Failed to apply, attempting reset..." >> "$LOG_FILE"
    redshift -x >> "$LOG_FILE" 2>&1
    redshift -O $NEW_TEMP -P >> "$LOG_FILE" 2>&1
fi

echo "Redshift temperature set to: ${NEW_TEMP}K"
