.PHONY: help install setup deps ghostty tmux lint format clean

help:
	@echo "Usage: make <target>"
	@echo ""
	@echo "  install   Full setup: deps + ghostty + tmux"
	@echo "  setup     Same as install"
	@echo "  deps      Brew installs only"
	@echo "  ghostty   Link Ghostty configs only"
	@echo "  tmux      Link tmux configs + TPM only"
	@echo "  lint      Run shellcheck on all scripts"
	@echo "  format    Run pre-commit hooks on all files"
	@echo "  clean     Remove broken symlinks installed by this repo"

install: deps ghostty tmux

setup: install

deps:
	brew install tmux tmuxinator yazi
	brew install --cask ghostty font-jetbrains-mono-nerd-font

ghostty:
	bash scripts/link.sh ghostty

tmux:
	bash scripts/link.sh tmux

lint:
	shellcheck ghostty/*.sh tmux/pane-label.sh scripts/link.sh

format:
	pre-commit run --all-files

clean:
	@echo "Removing symlinks pointing into this repo..."
	@find ~/.config/ghostty ~/.tmux.conf ~/.tmux/pane-label.sh ~/.config/tmuxinator \
	  -maxdepth 2 -type l 2>/dev/null | while read f; do \
	    target=$$(readlink "$$f"); \
	    if echo "$$target" | grep -q "ghostty-setup"; then \
	      rm "$$f" && echo "  removed $$f"; \
	    fi; \
	  done
