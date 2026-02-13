#!/bin/bash

# Power Toggle Script - Extreme Performance vs Extreme Powersave
# Optimized for AMD Ryzen (Renoir/Cezanne) Systems
# Fixed for i3/DBUS environments

STATE_FILE="/tmp/power_mode_state"
GPU_PATH="/sys/class/drm/card0/device/power_dpm_force_performance_level"
CPU_BOOST_PATH="/sys/devices/system/cpu/cpufreq/boost"
CPU_PATH_BASE="/sys/devices/system/cpu"

SUCCESS=true

# Detect Current Mode
if [ ! -f "$STATE_FILE" ] || [ "$(cat "$STATE_FILE")" == "powersave" ]; then
    NEW_MODE="performance"
    GPU_LEVEL="high"
    BOOST_VAL="1"
    EPP_VAL="performance"
    GOV_VAL="performance"
else
    NEW_MODE="powersave"
    GPU_LEVEL="low"
    BOOST_VAL="0"
    EPP_VAL="power"
    GOV_VAL="powersave"
fi

echo "Switching to $NEW_MODE mode..."

# 1. auto-cpufreq (Optional but preferred)
if command -v auto-cpufreq >/dev/null; then
    echo "Running: sudo auto-cpufreq --force $NEW_MODE"
    # We ignore the exit code of auto-cpufreq because we apply manual overrides next anyway
    sudo auto-cpufreq --force "$NEW_MODE" 2>/dev/null
fi

# 2. Extreme GPU Tweaks
if [ -f "$GPU_PATH" ]; then
    echo "Setting GPU to $GPU_LEVEL..."
    if ! echo "$GPU_LEVEL" | sudo tee "$GPU_PATH" > /dev/null; then
        echo "Error: Failed to set GPU level"
        SUCCESS=false
    fi
fi

# 3. CPU Boost (Extreme Tweak)
if [ -f "$CPU_BOOST_PATH" ]; then
    echo "Setting CPU Boost to $BOOST_VAL..."
    if ! echo "$BOOST_VAL" | sudo tee "$CPU_BOOST_PATH" > /dev/null; then
        echo "Error: Failed to set CPU Boost"
        SUCCESS=false
    fi
fi

# 4. Manual Governor and EPP
echo "Updating CPU Governors and EPP..."
# We run as a single block. We don't fail the whole script if one minor EPP write fails.
sudo bash -c "
for i in $CPU_PATH_BASE/cpu[0-9]*/cpufreq/scaling_governor; do
    [ -f \"\$i\" ] && echo $GOV_VAL > \"\$i\"
done
for i in $CPU_PATH_BASE/cpu[0-9]*/cpufreq/energy_performance_preference; do
    [ -f \"\$i\" ] && echo $EPP_VAL > \"\$i\"
done
" || echo "Note: Some CPU sub-settings could not be applied."

# Finalize state and Notify
if [ "$SUCCESS" = true ]; then
    echo "$NEW_MODE" > "$STATE_FILE"
    
    # Robust notification for i3/broken DBUS envs
    # Attempt to send notification, ignore errors to prevent script failure
    notify-send "Power Mode" "Switched to $NEW_MODE mode (GPU: $GPU_LEVEL)" --icon=utilities-terminal 2>/dev/null || \
    swaymsg "notify-send 'Power Mode' 'Switched to $NEW_MODE mode (GPU: $GPU_LEVEL)'" 2>/dev/null || \
    echo "Notification sent to stdout: Switched to $NEW_MODE"
    
    echo "Successfully switched to $NEW_MODE mode."
else
    notify-send "Power Mode" "Failed to switch all components to $NEW_MODE mode" --icon=dialog-error 2>/dev/null
    echo "Error: Failed to switch some components. check sudo privileges."
    exit 1
fi
