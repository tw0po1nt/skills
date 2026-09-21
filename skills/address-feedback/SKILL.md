---
name: address-feedback
description: "Work the open findings in the feedback ledger of the current branch: one finding at a time, the repo gate after each, one commit per finding, then push and record each outcome in the ledger."
disable-model-invocation: true
---

# Address Feedback

The reviewer wrote a **ledger** on the PR: a list of **findings**, each with a location, a fix,
and a `Done when` condition. This skill works the open ones and writes the outcome back. The
format is in [`LEDGER.md`](../to-feedback/LEDGER.md).

## Receipts

A **receipt** is command output, pasted into your reply under the command that produced it. Every
check result and every commit hash in your report comes from a receipt.

## Process

### 1. Find the ledger

Run `gh pr view --json number,headRefName` on the current branch. When the user passes a PR
number or a file path, use that instead.

Confirm the current branch is the PR's `headRefName`. When it is not, say so and stop.

Fetch the ledger with the query in `LEDGER.md`. When there is no ledger, say so and stop.

When the Status line reads `Clean` or lists no open id, report that there is nothing to do and
stop.

Done when: the ledger is in context and it holds at least one open finding.

### 2. Find the gate

The gate is `./scripts/verify.sh`. It prints `verify: green` or `verify: red` as its last line.
When the user passes a command as an argument, that command is the gate.

When the gate is missing, say so and stop. Write no gate of your own, because a gate you wrote
grades your own work.

Run the gate once before you change anything. Paste its last line. When it prints red on the
untouched branch, report that and stop.

### 3. Write the checklist

Copy each open finding into your reply as a checklist line: its id, its title, and its
`Done when`.

### 4. Take one finding

Pick the first unticked finding.

Open its `Where` location. The line numbers are pinned to the commit the review read. When the
lines have moved, find the code the entry quotes.

Make the smallest change that satisfies `Done when`. Change one finding at a time. Five changes
at once give you one failure that you cannot place.

When the finding is `optional` and you judge the change wrong for the code, decline it. Write a
one-line reason and make no change. A `required` finding is never declined.

### 5. Run the gate

Run the gate. Paste its last line.

- `verify: green`: stage each changed path by name, commit with the message
  `Address <id>: <title>`, paste the commit hash, and tick the finding.
- `verify: red`: read the first failing check. Fix that check alone and run the gate again. When
  you cannot make it green, run `git restore .` to drop the change, paste the red output, and mark
  the finding `blocked`.

Return to step 4 until every finding is ticked, declined, or blocked.

### 6. Push

Run `git push`. Paste the output.

When the push fails, report it and stop. Leave the ledger untouched, so it never claims a commit
the remote lacks.

### 7. Write the outcome to the ledger

For each finding you worked, set its state: `addressed in <sha>`, `declined: <reason>`, or
`blocked: <reason>` followed by the red gate output. Update the Status line with the pushed head
commit and the ids in each state. Set the Verdict to `Pending.`.

Replace the comment with the command in `LEDGER.md`.

### 8. Report

Write one line for each finding: its id, its final state, and the receipt that proves it. End
with the command for the reviewer: `/verify-feedback`.
