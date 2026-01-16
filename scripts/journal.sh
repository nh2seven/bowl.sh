#!/usr/bin/env bash
set -e

# Ensure we're in a git repo
git rev-parse --is-inside-work-tree >/dev/null 2>&1 || {
    echo "Not a git repository"
    exit 1
}

# Check for changes
if [[ -z "$(git status --porcelain)" ]]; then
    echo "No changes to commit."
    exit 0
fi

git add -A
git commit -m "Update: $(date '+%Y-%m-%d %H:%M:%S')"
