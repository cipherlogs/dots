#!/usr/bin/env bash
#
# volume-osd.sh — mac-style volume HUD for i3 + dunst (PipeWire via wpctl)
#
# usage: volume-osd.sh {up|down|mute}
# Changes the default sink volume, then shows a single self-replacing
# dunst pill with speaker icon + progress bar + percentage.

set -u

SINK="@DEFAULT_AUDIO_SINK@"
APP="volume-osd"
TIMEOUT_MS=2000
STEP="5%"

die() { echo "volume-osd: $*" >&2; exit 2; }

[[ $# -eq 1 ]] || die "usage: $(basename "$0") {up|down|mute}"

case "$1" in
    up)   wpctl set-volume "$SINK" "${STEP}+" -l 1.0 ;;
    down) wpctl set-volume "$SINK" "${STEP}-" ;;
    mute) wpctl set-mute "$SINK" toggle ;;
    *)    die "usage: $(basename "$0") {up|down|mute}" ;;
esac

# get-volume prints "Volume: 0.55" or "Volume: 0.00 [MUTED]"
status="$(wpctl get-volume "$SINK")" || die "wpctl get-volume failed"
pct="$(awk '{ printf "%d", $2 * 100 }' <<<"$status")"

# White Lucide stroke glyphs (shadcn style): 24px viewBox, so dunst
# renders them small; absolute paths bypass icon-theme lookup.
ICON_BASE="$HOME/.config/volume-osd-icons"

if [[ "$status" == *"[MUTED]"* ]] || [[ "$pct" -le 0 ]]; then
    icon="${ICON_BASE}/volume-x.svg"
    label="Muted"
elif [[ "$pct" -lt 33 ]]; then
    icon="${ICON_BASE}/volume-1.svg"
    label="Volume ${pct}%"
else
    icon="${ICON_BASE}/volume-2.svg"
    label="Volume ${pct}%"
fi

dunstify -a "$APP" -u low -t "$TIMEOUT_MS" \
    -h string:x-dunst-stack-tag:"$APP" \
    -h int:value:"$pct" \
    -i "$icon" \
    "$label"
