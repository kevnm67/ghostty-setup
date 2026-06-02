#!/bin/bash
tmux set-option -p allow-passthrough all 2>/dev/null
yazi "${@:-$HOME}"
tmux set-option -pu allow-passthrough 2>/dev/null
