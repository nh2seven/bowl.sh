#!/usr/bin/env bash
set -e

# Colors
RESET="$(tput sgr0)"
CYAN="$(tput setaf 38)"

printf "${CYAN}── 📁 Directory ────────────────────────────────────────────────────────${RESET}\n"
printf "${CYAN} CWD: ${RESET}%s\n" "$(pwd)"
echo

# Check if we're inside a git repo
if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    # Git identity
        printf "${CYAN}── 👤 Git Identity ─────────────────────────────────────────────────────${RESET}\n"
        printf "${CYAN} Name : ${RESET}%s\n" "$(git config user.name)"
        printf "${CYAN} Email: ${RESET}%s\n" "$(git config user.email)"
        echo

    # Git status
        printf "${CYAN}── 🔧 Git Status ───────────────────────────────────────────────────────${RESET}\n"
        git status

    # Fetch
        printf "${CYAN}── 🌐 Git Fetch ────────────────────────────────────────────────────────${RESET}\n"
        git fetch
else
    echo "⚠️  Not a Git repository"
fi
