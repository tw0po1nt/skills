#!/usr/bin/env bash
# The gate for this repo. The feedback skills run it, and CI runs it on each
# pull request. The last line of output is `verify: green` or `verify: red`.
#
# Each `step` runs one check. A failed step does not stop the gate, so one run
# reports every failed check.
set -uo pipefail

cd "$(git rev-parse --show-toplevel)"

status=0
step() {
  echo "verify: $*"
  "$@" || status=1
}

if [ -f scripts/check-banned-patterns.sh ]; then
  step ./scripts/check-banned-patterns.sh
fi

# LANGUAGE: add one `step` line here for each build, lint, and test command of
# this repo's source language, once the language is chosen.

if [ "$status" -eq 0 ]; then
  echo "verify: green"
else
  echo "verify: red"
  exit 1
fi
