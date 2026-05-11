#!/usr/bin/env bash
set -e

# ── Flags ─────────────────────────────────────────────────────────────────────
# -f  fetch from remote
# -p  fetch + pull from remote
DO_FETCH=false
DO_PULL=false
while getopts "fp" opt; do
  case $opt in
    f) DO_FETCH=true ;;
    p) DO_FETCH=true; DO_PULL=true ;;
    *) ;;
  esac
done

# ── Styling ────────────────────────────────────────────────────────────────────
RESET="$(tput sgr0)"
DIM="$(tput dim)"
BLUE="$(tput setaf 4)"
BOLD="$(tput bold)"
NEON_GREEN="$(tput setaf 10)"
RED="$(tput setaf 1)"
SECTION="»"

# ── Override Branches ──────────────────────────────────────────────────────────
MAIN_BRANCH=main
OVERRIDE_BRANCH=override-branch-here
OVERRIDE_PATHS=(
    # None
)
CURRENT_DIR="$(pwd)"

for TARGET_PATH in "${OVERRIDE_PATHS[@]}"; do
  if [[ "$CURRENT_DIR" == "$TARGET_PATH"* ]]; then
    MAIN_BRANCH="$OVERRIDE_BRANCH"
    break
  fi
done

echo "${NEON_GREEN}─────────────────────────────────────────────────────────────────────────────────────${RESET}"

if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then

  REPO_ROOT="$(git rev-parse --show-toplevel)"
  REPO_NAME="$(basename "$REPO_ROOT")"

  # ── Git Identity ─────────────────────────────────────────────────────────────
  echo "${BLUE}${BOLD}${SECTION} Git Identity${RESET}"
  echo "${DIM}  Name  :${RESET} $(git config user.name)"
  echo "${DIM}  Email :${RESET} $(git config user.email)"

  # ── Location ──────────────────────────────────────────────────────────────────
  echo
  echo "${BLUE}${BOLD}${SECTION} Location${RESET}"
  echo "${DIM}  Repo  :${RESET} ${NEON_GREEN}${BOLD}${REPO_NAME}${RESET}"
  echo "${DIM}  CWD   :${RESET} $(pwd)"

  # ── Git Branch ───────────────────────────────────────────────────────────────
  echo
  echo "${BLUE}${BOLD}${SECTION} Git Branch${RESET}"
  ACTIVE_BRANCH=""
  OTHER_BRANCHES=()
  while IFS= read -r line; do
    if [[ "$line" == \** ]]; then
      ACTIVE_BRANCH="${line:2}"
    else
      OTHER_BRANCHES+=("${line:2}")
    fi
  done < <(git branch)
  echo "  ${DIM}Active :${RESET} ${NEON_GREEN}${BOLD}${ACTIVE_BRANCH}${RESET}"
  for b in "${OTHER_BRANCHES[@]}"; do
    echo "  ${DIM}Other  :${RESET} ${b}"
  done

  # ── Git Commits ───────────────────────────────────────────────────────────────
  echo
  echo "${BLUE}${BOLD}${SECTION} Git Commits${RESET}"
  COMMITS="$(git log --format='%H %s' -3 2>/dev/null)"
  if [[ -z "$COMMITS" ]]; then
    echo "  ${DIM}(no commits yet)${RESET}"
  else
    FIRST=true
    while IFS= read -r line; do
      hash="${line:0:40}"
      msg="${line:41}"
      if $FIRST; then
        echo "  ${DIM}${hash} :${RESET} ${NEON_GREEN}${BOLD}${msg}${RESET}"
        FIRST=false
      else
        echo "  ${DIM}${hash} :${RESET} ${msg}"
      fi
    done <<< "$COMMITS"
  fi

  # ── Git Stash ─────────────────────────────────────────────────────────────────
  echo
  echo "${BLUE}${BOLD}${SECTION} Git Stash${RESET}"
  STASH_LIST="$(git stash list -n 3)"
  if [[ -z "$STASH_LIST" ]]; then
    echo "  ${DIM}(no stash entries)${RESET}"
  else
    COUNT=0
    while IFS= read -r line; do
      msg="$(echo "$line" | sed 's/.*: //')"
      echo "  ${DIM}[$COUNT] :${RESET} ${msg}"
      ((COUNT++)) || true
    done <<< "$STASH_LIST"
  fi

  # ── Git Status ────────────────────────────────────────────────────────────────
  echo
  echo "${BLUE}${BOLD}${SECTION} Git Status${RESET}"
  if [[ -z "$(git status --short)" ]]; then
    echo "  ${DIM}(working tree clean)${RESET}"
  else
    git -c color.status=always \
        -c color.status.added="bold green" \
        -c color.status.changed="red" \
        -c color.status.untracked="bold green" \
        -c color.status.unmerged="red" \
        status --short | sed 's/^/  /'
  fi

  # ── Git Diff ──────────────────────────────────────────────────────────────────
  echo
  echo "${BLUE}${BOLD}${SECTION} Git Diff vs ${MAIN_BRANCH}${RESET}"
  if ! git show-ref --verify --quiet refs/heads/${MAIN_BRANCH}; then
    echo "  ${DIM}(no ${MAIN_BRANCH} branch)${RESET}"
  else
    DIFF_STAT="$(git diff ${MAIN_BRANCH} --numstat)"
    if [[ -z "$DIFF_STAT" ]]; then
      echo "  ${DIM}(no diff vs ${MAIN_BRANCH})${RESET}"
    else
      while IFS=$'\t' read -r added removed filepath; do
        printf "  ${NEON_GREEN}${BOLD}%+4s${RESET} ${RED}%-4s${RESET} %s\n" "+${added}" "-${removed}" "${filepath}"
      done <<< "$DIFF_STAT"
      SHORTSTAT="$(git diff ${MAIN_BRANCH} --shortstat)"
      echo
      echo "  ${DIM}${SHORTSTAT## }${RESET}"
    fi
  fi

  # ── Git Fetch ─────────────────────────────────────────────────────────────────
  if $DO_FETCH; then
    echo
    echo "${BLUE}${BOLD}${SECTION} Git Fetch${RESET}"
    FETCH_OUT="$(git fetch 2>&1)"
    if [[ -z "$FETCH_OUT" ]]; then
      echo "  ${DIM}(already up to date)${RESET}"
    else
      echo "$FETCH_OUT"
    fi
  fi

  # ── Git Pull ──────────────────────────────────────────────────────────────────
  if $DO_PULL; then
    echo
    echo "${BLUE}${BOLD}${SECTION} Git Pull${RESET}"
    PULL_OUT="$(git pull 2>&1)"
    if [[ -z "$PULL_OUT" ]] || [[ "$PULL_OUT" == *"Already up to date"* ]]; then
      echo "  ${DIM}(already up to date)${RESET}"
    else
      echo "$PULL_OUT"
    fi
  fi

else
  echo "${BLUE}${BOLD}${SECTION} Git Identity${RESET}"
  echo "  ${DIM}Name  :${RESET} $(git config --global user.name  2>/dev/null || echo "${DIM}(not set)${RESET}")"
  echo "  ${DIM}Email :${RESET} $(git config --global user.email 2>/dev/null || echo "${DIM}(not set)${RESET}")"
  echo
  echo "  ⚠️  Not a Git repository"
fi

echo "${DIM}─────────────────────────────────────────────────────────────────────────────────────${RESET}"
