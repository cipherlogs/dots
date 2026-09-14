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

# Transition leftovers: during the ~/.config-repo era the dotsync timer
# units were symlinked here by hand. Stow refuses to overwrite existing
# files, so remove those manual links once (stow recreates them properly).
for u in dotsync-auto.service dotsync-auto.timer; do
  p="$HOME/.config/systemd/user/$u"
  [ -L "$p" ] && rm "$p" && echo "removed manual link: $p"
done

# Stow every package found in each root. Package contents mirror the
# target 1:1 (e.g. config/nvim/nvim/init.lua -> ~/.config/nvim/init.lua),
# so new packages work with zero changes here. Explicit loop (never bare
# `stow .`) so a half-added package can't surprise anyone.
stow_root() { # $1 = root dir, $2 = target dir
  local root="$1" target="$2" pkg
  for pkg in "$root"/*/; do
    [ -d "$pkg" ] || continue
    stow -d "$root" -t "$target" "$(basename "$pkg")"
  done
}

stow_root "$DOTS/home" "$HOME"
stow_root "$DOTS/config" "$HOME/.config"
stow_root "$DOTS/localbin" "$HOME/.local/bin"

# Host overlay last so it wins (e.g. hosts/arch-desktop).
HOST="$(hostnamectl hostname 2>/dev/null || hostname)"
if [ -d "$DOTS/hosts/$HOST" ]; then
  echo "stowing host overlay: $HOST"
  [ -d "$DOTS/hosts/$HOST/home" ] && stow_root "$DOTS/hosts/$HOST/home" "$HOME"
  [ -d "$DOTS/hosts/$HOST/config" ] && stow_root "$DOTS/hosts/$HOST/config" "$HOME/.config"
else
  echo "no host overlay for '$HOST' — skipping."
fi

echo "done. Next: secrets templates -> real files (see README.md)."
