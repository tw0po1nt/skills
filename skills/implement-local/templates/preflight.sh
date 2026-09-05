#!/usr/bin/env bash
# Prints one context bundle for a model working a ticket: the ticket body, the
# toolchain versions of this machine, the working tree, and the coding
# standards. The model reads this output instead of following a chain of
# pointers to find the same material.
#
# Edit `tool_commands` below for this repo.
set -euo pipefail

cd "$(git rev-parse --show-toplevel)"

# One command for each toolchain version this repo compiles with. The model
# quotes this output rather than a version it remembers.
tool_commands=(
  "git --version"
)

issue="${1:-}"
if [ -z "$issue" ]; then
  echo "usage: scripts/preflight.sh <issue-number>" >&2
  exit 2
fi

rule() {
  printf '\n==================== %s ====================\n\n' "$1"
}

# `gh issue view --comments` prints nothing when stdout is a pipe, so the fields
# come through `--json`, which prints the same text to a pipe and to a terminal.
rule "TICKET #$issue"
gh issue view "$issue" --json number,title,labels,body,comments --jq '
  "#\(.number)  \(.title)",
  "labels: \([.labels[].name] | join(", "))",
  "",
  .body,
  (.comments[] | "\n---- comment by \(.author.login) ----\n\n\(.body)")
'

rule "TOOLCHAIN ON THIS MACHINE"
for cmd in "${tool_commands[@]}"; do
  printf '$ %s\n' "$cmd"
  eval "$cmd" 2>&1 || echo "(command failed)"
  echo
done

rule "WORKING TREE"
printf '$ git status --short\n'
git status --short
printf '\n$ git log --oneline -5\n'
git log --oneline -5

rule "CODING STANDARDS"
for f in docs/standards/*.md; do
  [ -f "$f" ] || continue
  printf '# %s\n\n' "$f"
  cat "$f"
  echo
done

rule "THE GATE"
cat <<'EOF'
Run ./scripts/verify.sh after each change.

It prints "verify: green" when every check passes, and "verify: red" when one
check fails. Paste that line into your reply. It is the evidence that the work
is done.
EOF
