#!/bin/bash
# Alt+P: toggle power mode (performance <-> powersave).
#
# Applies via /usr/local/bin/power-mode-apply, allowed in sudoers
# (/etc/sudoers.d/20-power-mode) for these exact forms:
#   sudo -n /usr/local/bin/power-mode-apply performance
#   sudo -n /usr/local/bin/power-mode-apply powersave
#
# auto-cpufreq is disabled so these settings persist - this script owns them.
#
# Usage:
#   power-toggle.sh              toggle performance <-> powersave
#   power-toggle.sh performance  force performance
#   power-toggle.sh powersave    force powersave

HELPER="/usr/local/bin/power-mode-apply"
GPU_PATH=""
for f in /sys/class/drm/card*/device/power_dpm_force_performance_level; do
    [ -f "$f" ] && { GPU_PATH="$f"; break; }
done
GOV_FILE="/sys/devices/system/cpu/cpu0/cpufreq/scaling_governor"

notify() {
    notify-send "$1" "$2" --icon="${3:-utilities-terminal}" 2>/dev/null || echo "$1: $2"
}

# --- target mode ------------------------------------------------------------
case "${1:-}" in
    performance) NEW_MODE="performance" ;;
    powersave)   NEW_MODE="powersave" ;;
    "")
        if [ -n "$GPU_PATH" ] && [ "$(cat "$GPU_PATH")" = "high" ]; then
            NEW_MODE="powersave"
        else
            NEW_MODE="performance"
        fi
        ;;
    *) notify "Power: Error" "usage: power-toggle.sh [performance|powersave]" dialog-error; exit 2 ;;
esac

# --- apply ------------------------------------------------------------------
if ! OUT=$(sudo -n "$HELPER" "$NEW_MODE" 2>&1); then
    notify "Power: Error" "not applied ($NEW_MODE): ${OUT:-no permission}" dialog-error
    echo "Error: helper failed: $OUT"
    exit 1
fi

# --- verify from live state, then report ------------------------------------
DPM=$(cat "$GPU_PATH" 2>/dev/null)
GOV=$(cat "$GOV_FILE" 2>/dev/null)

if [ "$NEW_MODE" = "performance" ]; then
    WANT_DPM="high"; WANT_GOV="performance"; TITLE="Power: Performance"
else
    WANT_DPM="low";  WANT_GOV="powersave";   TITLE="Power: Powersave"
fi

if [ "$DPM" != "$WANT_DPM" ] || [ "$GOV" != "$WANT_GOV" ]; then
    notify "Power: Error" "GPU $DPM · CPU $GOV (wanted $WANT_DPM/$WANT_GOV)" dialog-error
    echo "Error: wanted $WANT_DPM/$WANT_GOV, got $DPM/$GOV"
    exit 1
fi

notify "$TITLE" "GPU $DPM · CPU $GOV"
echo "Done: $TITLE (GPU $DPM, CPU $GOV)"
