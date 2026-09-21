---
name: to-feedback
description: "Turn a code review into the feedback ledger on the PR: one living comment where each finding has a stable id, a state, and a checkable done-when, so the implementing agent can work it and the reviewer can verify it."
disable-model-invocation: true
---

# To Feedback

A review that lives in a chat window is lost when the window closes. This skill writes it to the
**ledger**: one PR comment that the implementer works with `address-feedback` and the reviewer
judges with `verify-feedback`. The format and the `gh` commands are in [`LEDGER.md`](LEDGER.md).
Read it before step 3.

The skill is idempotent. The same review written twice produces the same ledger. A later review
extends the ledger and keeps every existing id.

## Process

### 1. Gather the review

Use the review already in conversation context. This is the normal case, straight after
`/code-review`.

When the user passes a PR number and no review is in context, run `/code-review` on that PR
first, then continue with its output.

When neither is present, ask the user for the review or the PR number. Stop until you have one.

Done when: a review with Spec findings and Standards findings is in context, and you know the
commit it read.

### 2. Find the PR and the existing ledger

Run `gh pr view <pr> --json number,headRefOid,baseRefName` for the PR the review covers. Fetch the
existing ledger comment with the query in `LEDGER.md`.

When the branch has no PR, use the `.scratch` file path from `LEDGER.md`. Tell the user the ledger
is local until a PR exists.

When a PR exists and a `.scratch` file also exists, treat the file as the existing ledger. Delete
the file after step 6 writes the comment.

Done when: you hold the existing ledger text, or you know there is none.

### 3. Verify the existing findings

Skip this step when there is no existing ledger.

For each finding in state `addressed` or `declined`, run steps 3 and 4 of
[`verify-feedback`](../verify-feedback/SKILL.md). Reopen each finding that fails.

Done when: every existing finding is in a state you have checked.

### 4. Merge the new findings in

For each finding in the review:

1. Look for an existing finding with the same file and the same problem. When one exists, keep its
   id and leave its entry unchanged.
2. Otherwise give it the next free id on its axis and write an entry in the `LEDGER.md` format.

Tag each new finding. A breach of a documented standard or of the spec is `required`. A baseline
smell, a design note, or a style nit is `optional`.

Write `Done when` as a condition a reader can check from the diff. "The test renders the full
number" is checkable. "Improve the test" is not.

Done when: every review finding has exactly one entry, and no id appears twice.

### 5. Write the Status and reset the Verdict

Write the Status line: the commit reviewed, then the ids in each state.

When this run changed any finding, set the Verdict to `Pending.`. When nothing changed, leave the
Verdict as it is.

When no finding is open, the Status reads `Clean at <sha>. Open: none.` and the ledger is still
written. The implementer reads it and knows there is nothing to do.

### 6. Write the ledger

Create or replace the comment with the commands in `LEDGER.md`. Delete the `.scratch` file when
step 2 found one and a PR now exists.

### 7. Report

State the counts: findings open, addressed, declined, and new this run. Name the worst open
finding on each axis. End with the command for the implementer: `/address-feedback`.
