#!/bin/bash
# Smart tmux launcher for Ghostty / cmux.
#
# Under cmux ($CMUX_SURFACE_ID set) there is no tmux: cmux restores surfaces
# and agent sessions itself, and leftover idle cmux-* sessions from the old
# per-surface wrapper are reaped. Outside cmux (plain Ghostty) the original
# behaviour is kept: reattach to a live/continuum-restored session, else
# create `main`.
#
# A forced multi-pane workspace is still one keystroke away via `mux dev`.
# The old shared session remains reachable with `tmux attach -t main`.
set -euo pipefail

# Root the session at the directory cmux handed us (workspaceInheritWorkingDirectory),
# falling back to the work root for a default new window opened at $HOME.
START_DIR="${PWD:-$HOME}"
if [ ! -d "$START_DIR" ] || [ "$START_DIR" = "$HOME" ]; then
  START_DIR="$HOME/Github"
fi
[ -d "$START_DIR" ] || START_DIR="$HOME"

# Reap cmux sessions whose surface is gone: unattached, single window, single
# pane whose foreground process is the shell itself -- nothing is running in
# it. A pane running anything real (claude, nvim, a build) is left alone, as
# are `main`, `dev` and anything `mux dev` creates. An idle prompt normally
# has background children (async prompt/direnv workers), so a child-process
# check cannot be used here; the foreground command is the reliable signal.
#
# GRACE_SECONDS is load-bearing: cmux restores workspaces in parallel, and a
# session that has just been created but whose surface has not attached yet
# matches the kill predicate exactly. Without the age gate, one surface's
# launcher reaps a sibling's session mid-restore.
GRACE_SECONDS=120

prune_idle_cmux_sessions() {
  local now name attached windows created activity panes
  now=$(date +%s)
  while read -r name attached windows created activity; do
    case "$name" in
      cmux-*) ;;
      *) continue ;;
    esac
    [ "$attached" = "0" ] || continue
    [ "$windows" = "1" ] || continue
    [ $((now - created)) -gt "$GRACE_SECONDS" ] || continue
    [ $((now - activity)) -gt "$GRACE_SECONDS" ] || continue
    panes=$(tmux list-panes -t "$name" -F '#{pane_current_command}' 2>/dev/null || true)
    [ "$(printf '%s\n' "$panes" | grep -c . || true)" = "1" ] || continue
    case "$panes" in
      zsh|bash|sh|fish|dash|login) ;;
      *) continue ;;
    esac
    tmux kill-session -t "$name" 2>/dev/null || true
  done < <(tmux list-sessions \
    -F '#{session_name} #{session_attached} #{session_windows} #{session_created} #{session_activity}' \
    2>/dev/null || true)
}

# --- cmux: native surfaces, no tmux ----------------------------------------
# cmux is the terminal and owns persistence: it records each surface's cwd and
# agent session and restores them on launch. Wrapping a surface in tmux hides
# both: cmux only sees `tmux attach -t cmux-<id>`, which no longer matches
# after a restart ("restore: this command no longer matches the session"), the
# workspace cwd goes stale, and Claude sessions cannot be auto-resumed. So
# under cmux, hand over a plain login shell and let cmux do its job.
if [ -n "${CMUX_SURFACE_ID:-}" ]; then
  prune_idle_cmux_sessions
  cd "$START_DIR"
  exec "${SHELL:-/bin/zsh}" -l
fi

# --- plain Ghostty: original shared-session behaviour -----------------------
# 1. Reattach to a live / already-restored session.
if tmux has-session 2>/dev/null; then
  exec tmux attach
fi

# 2. Cold start: bring up the server so tmux-continuum (@continuum-restore
#    'on') can repopulate the last saved session, then poll briefly for it.
tmux start-server 2>/dev/null || true
for _ in 1 2 3 4 5 6; do
  if tmux has-session 2>/dev/null; then
    exec tmux attach
  fi
  sleep 0.25
done

# 3. Nothing to restore -> single clean pane at the default work root.
exec tmux new-session -A -s main -c "$START_DIR"
