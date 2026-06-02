# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo does

Symlinks Ghostty + tmux configs from this repo into the right locations on macOS. All config files live here; the installer creates symlinks so edits take effect immediately without re-running the installer.

## Commands

```bash
make install        # Full setup: brew deps + ghostty + tmux
make ghostty        # Ghostty configs only
make tmux           # tmux + TPM + tmuxinator (depends on ghostty)
make deps           # brew installs only
make lint           # shellcheck all scripts
make format         # pre-commit --all-files
make clean          # remove symlinks installed by this repo
```

`make tmux` depends on `make ghostty` — `dev.yml` references `~/.config/ghostty/yazi-launch.sh`, so ghostty scripts must be linked first.

## Architecture

`scripts/link.sh` is the single install engine. Makefile targets call it with `ghostty`, `tmux`, or `all`. The `link()` helper backs up existing files (timestamp suffix) before symlinking.

**Symlink map:**

| Repo path | Installed to |
|---|---|
| `ghostty/config` | `~/.config/ghostty/config` |
| `ghostty/themes/KJM Steel` | `~/.config/ghostty/themes/KJM Steel` |
| `ghostty/*.sh` | `~/.config/ghostty/*.sh` |
| `tmux/.tmux.conf` | `~/.tmux.conf` |
| `tmux/pane-label.sh` | `~/.tmux/pane-label.sh` |
| `tmux/tmuxinator/*.yml` | `~/.config/tmuxinator/*.yml` |

`setup_tmux()` also links `yazi-launch.sh` standalone (not just `setup_ghostty`) to handle `make tmux` called in isolation.

## Key design decisions

- **Theme name has a space** (`KJM Steel`) — quote it in any path operations.
- **`ghostty/config` uses XDG path** (`~/.config/ghostty/config`), not `~/Library/Application Support/com.mitchellh.ghostty/config`. The XDG path takes precedence on macOS when it exists.
- **`switch-theme.sh` is destructive** — it uses `sed -i ''` to mutate the live config. The first run backs up to `~/.config/ghostty/config.bak`.
- **TPM install** runs non-interactively via a detached tmux session (`_setup`). If it fails, the user runs `prefix+I` inside tmux manually.
- **`allow-passthrough on`** (not `all`) in `.tmux.conf` — `all` lets Ghostty intercept pane-creation escape sequences from Claude agent panes; `on` prevents that.

## Linting

ShellCheck runs in CI (`.github/workflows/lint.yml`) and locally via `make lint`. Pre-commit also runs shellcheck. Both target `--severity=warning`.
