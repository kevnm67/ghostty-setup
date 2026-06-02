#!/usr/bin/env bash
set -euo pipefail

REPO="$(cd "$(dirname "$0")/.." && pwd)"
MODE="${1:-all}"

link() {
    local src="$1" dest="$2"
    mkdir -p "$(dirname "$dest")"
    if [[ -e "$dest" && ! -L "$dest" ]]; then
        mv "$dest" "${dest}.bak.$(date +%Y%m%d_%H%M%S)"
        echo "  backed up $(basename "$dest")"
    fi
    [[ -L "$dest" ]] && rm "$dest"
    ln -sf "$src" "$dest"
    echo "  linked $dest"
}

setup_ghostty() {
    echo "→ Ghostty"
    link "$REPO/ghostty/config" "$HOME/.config/ghostty/config"
    link "$REPO/ghostty/themes/KJM Steel" "$HOME/.config/ghostty/themes/KJM Steel"
    for s in ghostty-tmux.sh yazi-launch.sh switch-theme.sh; do
        link "$REPO/ghostty/$s" "$HOME/.config/ghostty/$s"
        chmod +x "$REPO/ghostty/$s"
    done
}

setup_tmux() {
    echo "→ tmux"
    link "$REPO/tmux/.tmux.conf" "$HOME/.tmux.conf"
    link "$REPO/tmux/pane-label.sh" "$HOME/.tmux/pane-label.sh"
    chmod +x "$REPO/tmux/pane-label.sh"

    for y in dev devops claude-team claude-squad; do
        link "$REPO/tmux/tmuxinator/$y.yml" "$HOME/.config/tmuxinator/$y.yml"
    done

    if [[ ! -d "$HOME/.tmux/plugins/tpm" ]]; then
        git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
    else
        git -C "$HOME/.tmux/plugins/tpm" pull --quiet
    fi

    tmux new-session -d -s _setup 2>/dev/null || true
    "$HOME/.tmux/plugins/tpm/bin/install_plugins" 2>/dev/null &&
        echo "  TPM plugins installed" ||
        echo "  ⚠ Run prefix+I inside tmux to finish plugin install"
    tmux kill-session -t _setup 2>/dev/null || true
}

case "$MODE" in
ghostty) setup_ghostty ;;
tmux) setup_tmux ;;
all)
    setup_ghostty
    setup_tmux
    ;;
esac
