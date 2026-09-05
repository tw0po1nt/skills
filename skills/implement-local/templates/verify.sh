#!/usr/bin/env bash
# The gate. Runs every check that must pass before a commit, then prints
# "verify: green" or "verify: red".
#
# A coding agent runs this script. A human writes it. Keep `checks` in step with
# the CI workflow, so a green gate predicts a green pipeline.
set -uo pipefail

cd "$(git rev-parse --show-toplevel)"

# Every command that must pass, in the order that CI runs them.
checks=(
  "./scripts/check-banned-patterns.sh"
)

failed_count=0
first_failed=""

for check in "${checks[@]}"; do
  printf '\n==================== %s ====================\n' "$check"
  if eval "$check"; then
    printf 'PASS  %s\n' "$check"
  else
    printf 'FAIL  %s\n' "$check"
    failed_count=$((failed_count + 1))
    if [ -z "$first_failed" ]; then
      first_failed="$check"
    fi
  fi
done

printf '\n==================== SUMMARY ====================\n'

if [ "$failed_count" -eq 0 ]; then
  echo "Every check passed."
  echo "verify: green"
  exit 0
fi

printf '%s of %s checks failed.\n' "$failed_count" "${#checks[@]}"
printf 'Fix this check first: %s\n' "$first_failed"
echo "verify: red"
exit 1
