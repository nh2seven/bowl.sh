#!/usr/bin/env bash
set -e

# ── Styling (minimal, modern) ────────────────────────────────────────────
RESET="$(tput sgr0)"
DIM="$(tput dim)"
BLUE="$(tput setaf 4)"   # royal-ish blue on most terminals
BOLD="$(tput bold)"

SECTION="»"

# ── Directory ────────────────────────────────────────────────────────────
echo "${BLUE}${BOLD}${SECTION} Directory${RESET}"
echo "${DIM}  CWD:${RESET} $(pwd)"

# ── Git checks ───────────────────────────────────────────────────────────
if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then

  # Git identity
  echo
  echo "${BLUE}${BOLD}${SECTION} Git Identity${RESET}"
  echo "  Name : $(git config user.name)"
  echo "  Email: $(git config user.email)"

  # Git status (let git control formatting)
  echo
  echo "${BLUE}${BOLD}${SECTION} Git Status${RESET}"
  git status --short

  # Fetch
  echo
  echo "${BLUE}${BOLD}${SECTION} Git Fetch${RESET}"
  git fetch

  # Diff vs main
  echo
  echo "${BLUE}${BOLD}${SECTION} Git Diff vs main${RESET}"
  if git show-ref --verify --quiet refs/heads/main; then
    git diff main --stat
  else
    echo "${DIM}  (no main branch)${RESET}"
  fi

else
  echo
  echo "⚠️  Not a Git repository"
fi
