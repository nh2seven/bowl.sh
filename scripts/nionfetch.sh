#!/usr/bin/env bash
set -e

DIM="$(tput dim)"
NEON_GREEN="$(tput setaf 10)"
RESET="$(tput sgr0)"

echo "${DIM}─────────────────────────────────────────────────────────────────────────────────────${RESET}"

cd /home/nh2seven/aiNions/Code/nion || exit 0
ssh-add -D
ssh-add ~/.ssh/nion2seven
ssh-add -l

cd /home/nh2seven/aiNions/Code/nion/agent || exit 0
/home/nh2seven/Scripts/githuh.sh

cd /home/nh2seven/aiNions/Code/nion/consumer || exit 0
/home/nh2seven/Scripts/githuh.sh

cd /home/nh2seven/aiNions/Code/nion/controller || exit 0
/home/nh2seven/Scripts/githuh.sh

echo "${NEON_GREEN}─────────────────────────────────────────────────────────────────────────────────────${RESET}"

cd /home/nh2seven/aiNions/Code/nion || exit 0
