# ~/.zshenv — sourced for ALL zsh invocations (including scripts).
# Keep this minimal: environment only, no aliases/output (see .aliases).
export EDITOR="nvim"
export VISUAL="nvim"

# Always-dark Qt defaults (matches ~/.config/environment.d/10-darkmode.conf
# for systemd services; this covers shells + startx/i3 which ignore environment.d).
# qt5ct serves Qt5; QT_STYLE_OVERRIDE=kvantum covers Qt6 styling too
# (single QT_QPA_PLATFORMTHEME can't be both qt5ct and qt6ct).
export QT_QPA_PLATFORMTHEME="qt5ct"
export QT_STYLE_OVERRIDE="kvantum"
