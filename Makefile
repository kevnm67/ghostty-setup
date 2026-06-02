.PHONY: install deps ghostty tmux

install: deps ghostty tmux

deps:
	brew install tmux tmuxinator yazi
	brew install --cask ghostty font-jetbrains-mono-nerd-font

ghostty:
	bash scripts/link.sh ghostty

tmux:
	bash scripts/link.sh tmux

help:
	@echo "make install   — full setup (deps + configs)"
	@echo "make deps      — brew installs only"
	@echo "make ghostty   — link ghostty configs only"
	@echo "make tmux      — link tmux configs + TPM only"
