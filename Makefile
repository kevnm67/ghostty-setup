.PHONY: help install setup deps ghostty tmux lint format clean labels

help:
	@echo "Usage: make <target>"
	@echo ""
	@echo "  install   Full setup: deps + ghostty + tmux"
	@echo "  setup     Same as install"
	@echo "  deps      Brew installs only"
	@echo "  ghostty   Link Ghostty configs only"
	@echo "  tmux      Link tmux configs + TPM (also links ghostty scripts tmux depends on)"
	@echo "  lint      Run shellcheck on all scripts"
	@echo "  format    Run pre-commit hooks on all files"
	@echo "  clean     Remove symlinks installed by this repo
	@echo "  labels    Apply canonical GitHub labels to this repo""

install: deps ghostty tmux

setup: install

deps:
	brew install tmux tmuxinator yazi shellcheck pre-commit
	brew install --cask ghostty font-jetbrains-mono-nerd-font

ghostty:
	bash scripts/link.sh ghostty

tmux: ghostty
	bash scripts/link.sh tmux

lint:
	shellcheck ghostty/*.sh tmux/pane-label.sh scripts/link.sh

format:
	pre-commit run --all-files

labels:
	bash scripts/setup-labels.sh

clean:
	@echo "Removing symlinks pointing into this repo..."
	@find ~/.config/ghostty ~/.tmux/pane-label.sh ~/.config/tmuxinator \
	  -maxdepth 2 -type l 2>/dev/null | while read -r f; do \
	    target=$$(readlink "$$f"); \
	    if echo "$$target" | grep -q "ghostty-setup"; then \
	      rm "$$f" && echo "  removed $$f"; \
	    fi; \
	  done
	@[ -L ~/.tmux.conf ] && target=$$(readlink ~/.tmux.conf) && \
	  echo "$$target" | grep -q "ghostty-setup" && rm ~/.tmux.conf && echo "  removed ~/.tmux.conf" || true
