#!/usr/bin/env bash
# Creates the canonical label set for kevnm67/ghostty-setup.
# Usage: bash scripts/setup-labels.sh
# Requires: gh CLI authenticated
set -euo pipefail

REPO="kevnm67/ghostty-setup"

delete_label() { gh label delete "$1" --repo "$REPO" --yes 2>/dev/null || true; }
create_label() { gh label create "$1" --color "$2" --description "$3" --repo "$REPO" --force; }

echo "→ Removing GitHub defaults..."
for name in "bug" "documentation" "duplicate" "enhancement" "good first issue" \
    "help wanted" "invalid" "question" "wontfix"; do
    delete_label "$name"
done

echo "→ Creating type labels..."
create_label "type: bug" "d73a4a" "Something isn't working"
create_label "type: feat" "0075ca" "New feature or improvement"
create_label "type: chore" "e4e669" "Build, CI, tooling, or dependency changes"
create_label "type: docs" "0052cc" "Documentation only"
create_label "type: fix" "ee0701" "Bug fix"
create_label "type: refactor" "fbca04" "Code change without behavior change"

echo "→ Creating scope labels..."
create_label "scope: ghostty" "b4edff" "Ghostty config or scripts"
create_label "scope: tmux" "bfd4f2" "tmux config, plugins, or layouts"
create_label "scope: ci" "f9d0c4" "CircleCI or GitHub Actions"
create_label "scope: scripts" "c5def5" "Install/utility scripts or Makefile"

echo "→ Creating status labels..."
create_label "status: blocked" "b60205" "Blocked on external dependency"
create_label "status: in-progress" "0e8a16" "Actively being worked on"
create_label "status: needs-review" "fef2c0" "Ready for review"

echo "→ Creating size labels..."
create_label "size: XS" "ffffff" "< 10 lines"
create_label "size: S" "c2e0c6" "10–50 lines"
create_label "size: M" "fef2c0" "50–200 lines"
create_label "size: L" "f9d0c4" "200+ lines"

echo "✓ Labels configured for $REPO"
