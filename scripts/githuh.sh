#!/usr/bin/env bash
set -e

# ── Styling (minimal, modern) ───────────────────────────────────────────────────────────
RESET="$(tput sgr0)"
DIM="$(tput dim)"
BLUE="$(tput setaf 4)"
BOLD="$(tput bold)"
NEON_GREEN="$(tput setaf 10)"
SECTION="»"

# ── Override Branches ───────────────────────────────────────────────────────────
MAIN_BRANCH=main
OVERRIDE_BRANCH=sprint-23
OVERRIDE_PATHS=(
  "/home/nh2seven/aiNions/Code/nion/agent"
  "/home/nh2seven/aiNions/Code/nion/consumer"
  "/home/nh2seven/aiNions/Code/nion/controller"
)
CURRENT_DIR="$(pwd)"

# If CWD is /home/nh2seven/aiNions/Code/nion/agent, set MAIN_BRANCH to OVERRIDE_BRANCH
for TARGET_PATH in "${OVERRIDE_PATHS[@]}"; do
  if [[ "$CURRENT_DIR" == "$TARGET_PATH"* ]]; then
    MAIN_BRANCH="$OVERRIDE_BRANCH"
    break
  fi
done

echo "${NEON_GREEN}─────────────────────────────────────────────────────────────────────────────────────${RESET}"

# ── Location (CWD + Repo) ───────────────────────────────────────────────────────────
echo "${BLUE}${BOLD}${SECTION} Location${RESET}"
echo "${DIM}  CWD  :${RESET} $(pwd)"

if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  REPO_ROOT="$(git rev-parse --show-toplevel)"
  REPO_NAME="$(basename "$REPO_ROOT")"
  echo "${DIM}  Repo :${RESET} ${NEON_GREEN}${BOLD}${REPO_NAME}${RESET}"
fi

# ── Git checks ───────────────────────────────────────────────────────────
if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then

  # Branch (handles detached HEAD)
  BRANCH="$(git symbolic-ref --quiet --short HEAD || git rev-parse --short HEAD)"

  # Git identity
  echo
  echo "${BLUE}${BOLD}${SECTION} Git Identity${RESET}"
  echo "${DIM}  Name   :${RESET} $(git config user.name)"
  echo "${DIM}  Email  :${RESET} $(git config user.email)"
  echo "${DIM}  Branch :${RESET} ${NEON_GREEN}${BOLD}${BRANCH}${RESET}"

  # Git status
  echo
  echo "${BLUE}${BOLD}${SECTION} Git Status${RESET}"
  git status --short

  # Fetch
  echo
  echo "${BLUE}${BOLD}${SECTION} Git Fetch${RESET}"
  git fetch

  # Diff vs BRANCH
  echo
  echo "${BLUE}${BOLD}${SECTION} Git Diff vs ${MAIN_BRANCH}${RESET}"
  if git show-ref --verify --quiet refs/heads/main; then
    git diff ${MAIN_BRANCH} --stat
  else
    echo "${DIM}  (no ${MAIN_BRANCH} branch)${RESET}"
  fi

else
  echo
  echo "⚠️  Not a Git repository"
fi

echo "${DIM}─────────────────────────────────────────────────────────────────────────────────────${RESET}"
