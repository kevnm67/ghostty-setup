#!/usr/bin/env bash
# Auto-increments patch version from latest git tag and pushes the new tag.
# The push triggers release_workflow which creates the GitHub release.
set -euo pipefail

latest=$(git describe --tags --abbrev=0 2>/dev/null || echo "v0.0.0")
echo "Latest tag: $latest"

major=$(echo "$latest" | cut -d. -f1 | tr -d 'v')
minor=$(echo "$latest" | cut -d. -f2)
patch=$(echo "$latest" | cut -d. -f3)
next_tag="v${major}.${minor}.$((patch + 1))"
echo "Tagging: $next_tag"

git config --global user.email "ci@circleci.com"
git config --global user.name "CircleCI"
git config --global url."https://${GITHUB_TOKEN}@github.com/".insteadOf "https://github.com/"

git tag "$next_tag"
git push origin "$next_tag"
echo "Pushed $next_tag — release_workflow will create the GitHub release"
