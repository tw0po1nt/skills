#!/usr/bin/env bash
# One-command restore for a fresh clone: reinstalls every skill recorded in
# skills-lock.json and syncs each into its agent directory (.claude/skills,
# and any other agent this project targets).
set -euo pipefail

npx skills@latest experimental_install
