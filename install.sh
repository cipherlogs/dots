#!/usr/bin/env bash
# install.sh — bootstrap dots on a (fresh) machine. Idempotent.
set -euo pipefail

DOTS="$HOME/dots"
need() { command -v "$1" >/dev/null 2>&1 || { echo "missing: $1 ($2)"; MISSING=1; }; }

MISSING=0
need stow "sudo pacman -S stow"
need git "sudo pacman -S git"
[ "$MISSING" -eq 0 ] || { echo "install the above, then re-run."; exit 1; }

mkdir -p "$HOME/.config" "$HOME/.local/bin"

stow -d "$DOTS/home" -t "$HOME" .
stow -d "$DOTS/config" -t "$HOME/.config" .
stow -d "$DOTS/localbin" -t "$HOME/.local/bin" .

# Host overlay last so it wins (e.g. hosts/arch-desktop).
HOST="$(hostnamectl hostname 2>/dev/null || hostname)"
if [ -d "$DOTS/hosts/$HOST" ]; then
  echo "stowing host overlay: $HOST"
  stow -d "$DOTS/hosts/$HOST/home" -t "$HOME" . 2>/dev/null || true
  stow -d "$DOTS/hosts/$HOST/config" -t "$HOME/.config" . 2>/dev/null || true
else
  echo "no host overlay for '$HOST' — skipping."
fi

echo "done. Next: secrets templates -> real files (see README.md)."
