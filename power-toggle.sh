#!/bin/bash

# Path to the state file
STATE_FILE="/tmp/power_mode_state"

# Determine the new mode and GPU level
if [ ! -f "$STATE_FILE" ] || [ "$(cat "$STATE_FILE")" == "powersave" ]; then
    NEW_MODE="performance"
    GPU_LEVEL="high"
else
    NEW_MODE="powersave"
    GPU_LEVEL="auto"
fi

# GPU path
GPU_PATH="/sys/class/drm/card0/device/power_dpm_force_performance_level"

# Execute the commands with sudo
# Note: This assumes auto-cpufreq is installed and in the PATH
SUCCESS=true

if ! sudo auto-cpufreq --force "$NEW_MODE"; then
    SUCCESS=false
fi

if [ -f "$GPU_PATH" ]; then
    if ! echo "$GPU_LEVEL" | sudo tee "$GPU_PATH" > /dev/null; then
        SUCCESS=false
    fi
fi

if [ "$SUCCESS" = true ]; then
    echo "$NEW_MODE" > "$STATE_FILE"
    notify-send "Power Mode" "Switched to $NEW_MODE mode (GPU: $GPU_LEVEL)" --icon=utilities-terminal
    echo "Successfully switched to $NEW_MODE mode."
else
    notify-send "Power Mode" "Failed to switch all components to $NEW_MODE mode" --icon=dialog-error
    echo "Error: Failed to switch mode. check sudo privileges."
    exit 1
fi
