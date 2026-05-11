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

DESC=""
while getopts "m:" opt; do
    case $opt in
        m) DESC="$OPTARG" ;;
        *) echo "Usage: $0 [-m description]"; exit 1 ;;
    esac
done

TIMESTAMP="$(date '+%-d %B, %Y | %H%M')"
MSG="$TIMESTAMP"
[[ -n "$DESC" ]] && MSG="$TIMESTAMP — $DESC"

git add -A
git commit -m "$MSG"
