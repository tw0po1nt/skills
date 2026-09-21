---
name: to-feedback
description: "Turn a code review into the feedback ledger on the PR: one comment where each finding has a stable id, a state, and a checkable Done when, so the implementer can work it and the reviewer can verify it."
disable-model-invocation: true
---

# To Feedback

A review that lives in a chat window is lost when the window closes. This skill writes it to the
**ledger**: one PR comment that the implementer works with `address-feedback` and the reviewer
judges with `verify-feedback`. The format and the `gh` commands are in
`docs/agents/feedback-ledger.md`. Read it before step 2.

The skill is idempotent. The same review written twice produces the same ledger. A later review
extends the ledger and keeps every existing id. A later review changes no existing state, because
that is the work of `verify-feedback`.

## Process

### 1. Gather the review

Use the review already in conversation context. This is the normal case, straight after
`/code-review`.

When the user passes a PR number and no review is in context, run `/code-review` on that PR
first. Then continue with its output.

When neither is present, ask the user for the review or the PR number. Stop until you have one.

Done when: a review with Spec findings and Standards findings is in context, and you know the
commit it read.

### 2. Find the existing ledger

Follow "Find the ledger" in `docs/agents/feedback-ledger.md`.

When the branch has no PR, tell the user the ledger is local until a PR exists.

When a PR exists and a `.scratch` file also exists, the file is the existing ledger. Step 5
moves it into the comment.

Done when: you hold the existing ledger text, or you know there is none.

### 3. Merge the new findings in

For each finding in the review:

1. Look for an existing finding with the same file and the same problem. When one exists, keep
   its entry unchanged.
2. Otherwise, give it the next free id on its axis and write an entry in the ledger format.

Set the Kind of each new finding by the Kind rule. Write its `Done when` by the `Done when` rule.

Done when: every review finding has exactly one entry, and no id appears twice.

### 4. Write the Summary and the Verdict

Write the Summary line: the commit this review read, then the ids in each state.

When this run added a finding, set the Verdict to `Pending.`. When it added none, leave the
Verdict as it is.

When no finding is open, write the ledger anyway. The implementer reads `Open: none` and knows
there is nothing to do.

Done when: the Summary names the reviewed commit and every id, and the Verdict is set.

### 5. Write the ledger

Create or replace the comment with the commands in `docs/agents/feedback-ledger.md`. When step 2
found a `.scratch` file and a PR now exists, delete the file.

Done when: one ledger exists for the branch, and it holds the new text.

### 6. Report

State the counts: findings open, addressed, declined, and new this run. Name the worst open
finding on each axis. End with the command for the implementer: `/address-feedback`.

Done when: the counts, the worst finding on each axis, and the next command are in your reply.
