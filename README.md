# ghostty-setup

[![ShellCheck](https://github.com/kevnm67/ghostty-setup/actions/workflows/lint.yml/badge.svg)](https://github.com/kevnm67/ghostty-setup/actions/workflows/lint.yml)

Opinionated Ghostty + tmux bootstrap for macOS. Clone and run `make install` to get a fully configured terminal environment.

## Contents

| Path | What it sets up |
|---|---|
| `ghostty/config` | Ghostty config — KJM Steel theme, tmux launcher, keybinds |
| `ghostty/themes/KJM Steel` | Custom blue-gray color theme |
| `ghostty/ghostty-tmux.sh` | Smart launcher — attaches existing `dev` session or starts tmuxinator |
| `ghostty/yazi-launch.sh` | Yazi file manager with per-pane passthrough |
| `ghostty/switch-theme.sh` | Switch between 5 themes (catppuccin, tokyonight, kanagawa, rosepine, steel) |
| `tmux/.tmux.conf` | tmux config — Ctrl-a prefix, vi keys, Claude agent layouts, status bar |
| `tmux/pane-label.sh` | Colored pane header pills with git branch badge |
| `tmux/tmuxinator/*.yml` | Layouts: `dev`, `devops`, `claude-team`, `claude-squad` |

## Prerequisites

- macOS
- [Homebrew](https://brew.sh)

## Installation

```sh
git clone https://github.com/kevnm67/ghostty-setup
cd ghostty-setup
make install
```

All configs are **symlinked** — edits in this repo take effect immediately. Existing files are backed up with a timestamp before replacement.

## Usage

```sh
make install    # full setup
make ghostty    # Ghostty configs only
make tmux       # tmux + TPM + tmuxinator only
make deps       # brew installs only
make clean      # remove symlinks installed by this repo
make lint       # shellcheck all scripts
```

## Tmuxinator Layouts

| Layout | Command | Windows |
|---|---|---|
| `dev` | `mux dev [path]` | Yazi + 2 terminals |
| `devops` | `mux devops` | IaC / cloud CLI / logs / shell |
| `claude-team` | `mux claude-team [path]` | Lead + 2 Claude agents |
| `claude-squad` | `mux claude-squad [path]` | Lead + 3 Claude agents |

## tmux Key Reference

| Key | Action |
|---|---|
| `prefix` | `Ctrl-a` |
| `prefix + \|` | Vertical split |
| `prefix + -` | Horizontal split |
| `Alt + arrows` | Switch panes (no prefix) |
| `prefix + T` | Spawn 3-pane Claude team |
| `prefix + Q` | Spawn 4-pane Claude squad |
| `prefix + C` | Single Claude pane |
| `prefix + r` | Reload config |

## Development

```sh
make lint      # shellcheck
make format    # pre-commit --all-files
```

Pre-commit hooks run shellcheck and standard file hygiene checks. Install once with:

```sh
pip install pre-commit && pre-commit install
```
