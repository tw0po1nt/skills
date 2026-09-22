---
name: address-feedback
description: "Work the open findings in the feedback ledger of the current branch: one finding at a time, the repo gate after each, one commit per finding, then push and record each outcome in the ledger."
disable-model-invocation: true
---

# Address Feedback

The reviewer wrote a **ledger** on the PR: a list of **findings**, each with a location, a fix,
and a `Done when` condition. This skill works the open ones and writes the outcome back. The
format, the `gh` commands, and the gate are in `docs/agents/feedback-ledger.md`. Read it before
step 1.

Every check result and every commit hash in your report is a **receipt**: the command output,
pasted under the command that produced it.

## Process

### 1. Find the ledger

Follow "Find the ledger" in `docs/agents/feedback-ledger.md`. When there is no ledger, say so
and stop.

When the ledger is a PR comment, confirm the current branch is the PR's `headRefName`. When it
is not, say so and stop.

When the Summary reads `Open: none`, report that there is nothing to do and stop.

Done when: the ledger is in context, and it holds at least one open finding.

### 2. Prove the gate on the untouched branch

Run the gate. Paste its last line.

When the gate is missing, say so and stop. A gate you wrote grades your own work, so write none.

When the gate prints red before you change anything, report that and stop.

Done when: you hold a receipt that says `verify: green` on the untouched branch.

### 3. Write the checklist

Copy each open finding into your reply as a checklist line: its id, its title, and its
`Done when`.

Done when: every open id in the Summary has one checklist line.

### 4. Take one finding

Pick the first unticked finding.

Open its `Where` location. The review pinned the line numbers to the commit it read. When the
lines have moved, find the code the entry quotes.

Make the smallest change that satisfies `Done when`. Change one finding at a time. Five changes
at once give you one failure that you cannot place.

When the finding is `optional` and you judge the change wrong for the code, decline it. Write a
one-line reason and make no change. Work every `required` finding.

Done when: the working tree holds the change for this finding alone, or the finding is declined.

### 5. Run the gate

Run the gate. Paste its last line.

When it prints `verify: green`:

1. Stage each changed path by name.
2. Commit with the message `Address <id>: <title>`.
3. Paste the commit hash.
4. Tick the finding.

When it prints `verify: red`:

1. Read the first failing check.
2. Fix that check alone, and run the gate again.
3. When you cannot make it green, run `git restore .` to drop the change. Paste the red output.
   Mark the finding `blocked`.

Return to step 4 until every finding is ticked, declined, or blocked.

Done when: every checklist line is ticked, declined, or blocked, and each ticked line has a
commit hash.

### 6. Push

Run `git push`. Paste the output.

When the push fails, report it and stop. Leave the ledger untouched, so it never claims a commit
the remote lacks.

Done when: you hold a receipt that says the remote holds every commit from step 5.

### 7. Write the outcome to the ledger

For each finding you worked, set its state: `addressed in <sha>`, `declined: <reason>`, or
`blocked: <reason>` followed by the red gate output.

The `State` line is the only line of an entry that you change. Leave the `Where`, the `Rule`, the
`Problem`, the `Fix`, and the `Done when` as the reviewer wrote them. `verify-feedback` tests your
diff against the `Done when`, so a rewritten entry leaves the verifier with no condition to test.

Update the ids in the Summary. Set the Verdict to `Pending.`. Only `verify-feedback` writes a
verdict that judges the merge.

Replace the comment with the command in `docs/agents/feedback-ledger.md`.

Done when: the ledger on the PR shows the new state of every finding you worked, each `Done when`
reads as the reviewer wrote it, and the Verdict reads `Pending.`.

### 8. Report

Write one line for each finding: its id, its final state, and the receipt that proves it. End
with the command for the reviewer: `/verify-feedback`.

Done when: every finding you worked has one line with a receipt, and the next command is last.
