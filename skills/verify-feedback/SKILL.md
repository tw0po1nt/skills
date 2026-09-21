---
name: verify-feedback
description: "Judge the implementer's report in the feedback ledger: prove each addressed finding from its commit, weigh each declined one, prove the gate on the PR head, and write a ready-to-merge verdict. Raises no new findings."
disable-model-invocation: true
---

# Verify Feedback

A review widens its scope every time it runs, and an agent reviewer finds something every time.
A loop of review, address, review does not converge. This skill ends it. It checks only what the
**ledger** already holds and writes a **verdict**. It raises no new finding. The format, the
`gh` commands, and the gate are in `docs/agents/feedback-ledger.md`. Read it before step 1.

## Process

### 1. Find the ledger

Follow "Find the ledger" in `docs/agents/feedback-ledger.md`. When there is no ledger, say so
and stop.

Run `git fetch origin`, so every commit the ledger cites is local.

Done when: the ledger is in context, and `headRefOid` is a local commit.

### 2. Prove the gate on the head

Run `gh pr checks <pr>`.

- Every check passes: the gate is green.
- A check is pending: report that the gate is pending and stop. Write no verdict.
- A check fails: the gate is red. Keep `gate red at <headRefOid>` for step 6 and continue.
- No checks exist: run the gate in a worktree of the head.
  1. Run `git worktree add /tmp/verify-<pr> <headRefOid>`.
  2. Run `./scripts/verify.sh` in that worktree. Paste the last line.
  3. Run `git worktree remove /tmp/verify-<pr>`.

Done when: you hold a receipt that says green or red on the head, or you have stopped.

### 3. Prove each addressed finding

For each finding in state `addressed in <sha>`:

1. Run `git merge-base --is-ancestor <sha> <headRefOid>` and confirm it exits 0.
2. Run `git show <sha>`. Test the diff against the finding's `Done when`.
3. Proven: leave the state. Unproven: set the state to `open`. Add a `Reopened:` line that names
   the part of `Done when` the diff does not meet.

Done when: every addressed finding is proven or reopened.

### 4. Weigh each declined finding

For each finding in state `declined: <reason>`:

- Kind `required`: set the state to `open` with `Reopened: a required finding cannot be declined.`
- Kind `optional`, and the reason holds against the code: leave the state.
- Kind `optional`, and the reason does not hold: set the state to `open` with a `Reopened:` line
  that answers the reason.

Done when: every declined finding is left or reopened.

### 5. Note each blocked finding

A `blocked` finding stays as it is. Step 6 names it as open.

Done when: every blocked id is on your list for the verdict.

### 6. Write the verdict

When every finding is `addressed` or `declined`, and step 2 was green, write
`Ready to merge at <headRefOid>.`

Otherwise, write `Not ready: <reasons>.` with every `open` and `blocked` id, and with
`gate red at <sha>` when step 2 was red.

Update the ids in the Summary. Replace the comment with the command in
`docs/agents/feedback-ledger.md`.

Done when: the ledger on the PR holds the verdict and the new state of every finding.

### 7. Report

Paste the verdict. List each finding you reopened with its `Reopened:` line.

When you saw a defect the ledger does not hold, write one line for it under a heading
`Outside the ledger`. End with: run `/to-feedback` to raise it. The ledger stays as step 6 wrote
it.

The human merges and approves. This skill writes the verdict and stops.

Done when: the verdict, each reopened finding, and each defect outside the ledger are in your
reply.
