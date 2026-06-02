#!/bin/bash
if tmux has-session -t dev 2>/dev/null; then
    tmux new-window -t dev
    exec tmux attach-session -t dev
else
    exec tmuxinator start dev 2>/dev/null || exec "$SHELL" -l
fi
