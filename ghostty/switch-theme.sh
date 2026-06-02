#!/bin/bash
# Usage: switch-theme.sh [catppuccin|tokyonight|kanagawa|rosepine|steel|list]

CONFIG="$HOME/.config/ghostty/config"
BACKUP="${CONFIG}.bak"

[[ ! -f "$BACKUP" ]] && cp "$CONFIG" "$BACKUP"

set_theme() {
    sed -i '' "s/^theme = .*/theme = $1/" "$CONFIG"
    sed -i '' "s/^background = .*/background = $2/" "$CONFIG"
    sed -i '' "s/^cursor-color = .*/cursor-color = $3/" "$CONFIG"
    sed -i '' "s/^cursor-text = .*/cursor-text = $4/" "$CONFIG"
    sed -i '' "s/^selection-background = .*/selection-background = $5/" "$CONFIG"
    sed -i '' "s/^selection-foreground = .*/selection-foreground = $6/" "$CONFIG"
    sed -i '' '/^palette = /d' "$CONFIG"
    echo "Switched to $1 — restart Ghostty to apply"
}

case "${1:-}" in
catppuccin | cat) set_theme "Catppuccin Mocha" "#1e1e2e" "#f5e0dc" "#1e1e2e" "#585b70" "#cdd6f4" ;;
tokyonight | tokyo) set_theme "TokyoNight Storm" "#24283b" "#c0caf5" "#1d202f" "#364a82" "#c0caf5" ;;
kanagawa | kana) set_theme "Kanagawa Dragon" "#181616" "#c5c9c5" "#1d202f" "#223249" "#c5c9c5" ;;
rosepine | rose) set_theme "Rose Pine Moon" "#232136" "#e0def4" "#232136" "#44415a" "#e0def4" ;;
steel | s) set_theme "KJM Steel" "#1d2133" "#b8bfd0" "#1d2133" "#384263" "#d0d6e4" ;;
restore)
    cp "$BACKUP" "$CONFIG"
    echo "Restored backup — restart Ghostty to apply"
    ;;
list) echo "catppuccin  tokyonight  kanagawa  rosepine  steel  restore" ;;
*) echo "Usage: switch-theme.sh <theme>  |  switch-theme.sh list" ;;
esac
