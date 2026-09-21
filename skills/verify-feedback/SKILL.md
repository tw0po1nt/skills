---
name: verify-feedback
description: "Judge the implementer's report in the feedback ledger: prove each addressed finding from its commit, weigh each declined one, prove the gate on the PR head, and write a ready-to-merge verdict. Raises no new findings."
disable-model-invocation: true
---

# Verify Feedback

A review widens its scope every time it runs, and an agent reviewer finds something every time.
A loop of review, address, review does not converge. This skill is the pass that ends it. It
checks only what the **ledger** already holds and writes a **verdict**. It raises no new finding.
The format is in [`LEDGER.md`](../to-feedback/LEDGER.md).

## Process

### 1. Find the ledger

Run `gh pr view --json number,headRefOid` on the current branch. When the user passes a PR
number, use that instead. Fetch the ledger with the query in `LEDGER.md`. When there is no
ledger, say so and stop.

Run `git fetch origin`, so every commit the ledger cites is local.

### 2. Prove the gate on the head

Run `gh pr checks <pr>`. Every check must report pass.

- A pending check: report that the gate is pending and stop. Write no verdict.
- No checks at all: create a worktree of the head with `git worktree add /tmp/verify-<pr>
  <headRefOid>`, run `./scripts/verify.sh` in it, paste the last line, then run
  `git worktree remove /tmp/verify-<pr>`.

Done when: you hold a receipt that says the gate is green on the head, or you have stopped.

### 3. Prove each addressed finding

For each finding in state `addressed in <sha>`:

1. Run `git show <sha> --stat` and confirm the commit is an ancestor of the head with
   `git merge-base --is-ancestor <sha> <headRefOid>`.
2. Read the diff and test it against the finding's `Done when`.
3. Proven: leave the state. Unproven: set the state to `open` and add a `Reopened:` line that
   says which part of `Done when` the diff does not meet.

### 4. Weigh each declined finding

For each finding in state `declined: <reason>`:

- Kind `required`: set the state to `open` with `Reopened: a required finding cannot be declined.`
- Kind `optional` and the reason holds against the code: leave the state.
- Kind `optional` and the reason does not hold: set the state to `open` with a `Reopened:` line
  that answers the reason.

### 5. Note each blocked finding

A `blocked` finding stays as it is. Name it in the verdict as open.

### 6. Write the verdict

When every finding is `addressed` or `declined` and step 2 was green, write
`Ready to merge at <headRefOid>.`

Otherwise write `Not ready: <ids> open.` with every `open` and `blocked` id.

Replace the comment with the command in `LEDGER.md`.

### 7. Report

Paste the verdict. List each finding you reopened with its `Reopened:` line.

When you saw a defect the ledger does not hold, write one line for it under a heading
`Outside the ledger` and end with: run `/to-feedback` to raise it. Add nothing to the ledger.

Merging and approval stay with the human. This skill writes the verdict and stops.
