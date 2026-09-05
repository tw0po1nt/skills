---
name: implement-local
description: "Drive a small local model through one implementation ticket: context resolved up front, one acceptance criterion at a time, and a fixed gate that ships with the repo."
disable-model-invocation: true
---

# Implement (local model)

For a small local model working one ticket. Two scripts carry the work that a document cannot:
`scripts/preflight.sh` gathers the context, and `scripts/verify.sh` decides when the work is done.

A repo with no `scripts/verify.sh` yet needs one setup pass. See [`SETUP.md`](SETUP.md).

## Receipts

A **receipt** is command output, pasted into your reply under the command that produced it.

Every version number, path, and check result comes from a receipt. A value you remember from
another project is a guess. Run the command and paste what it prints. A version number in the
ticket wins over a version you remember.

The gate prints `verify: green` when every check passes. It prints `verify: red` when one check
fails. Those two strings are the evidence that the work is done.

`scripts/verify.sh` ships with the repo. When it is missing, say so and stop. The gate is the one
script you never write, because a gate you wrote grades your own work.

## Process

### 1. Load the ticket

Run `./scripts/preflight.sh <issue-number>`.

It prints the ticket, the toolchain versions of this machine, the working tree, and the coding
standards. Work from that output. Reach for no other document.

### 2. Write the checklist

Copy each acceptance criterion from the preflight output into your reply as a checklist.

Ask the user about any criterion you can read two ways. Wait for the answer. A guess here costs a
whole rebuild.

### 3. Take one criterion

Pick the first unticked criterion. Make the smallest change that satisfies it.

Change one thing. Five changes at once give you one failure that you cannot place.

### 4. Run the gate

Run `./scripts/verify.sh`. Paste its last line.

- `verify: green`: tick that criterion in your checklist, then return to step 3.
- `verify: red`: read the first failing check. Fix that check alone. Run the gate again.

Repeat until every criterion is ticked and the gate prints `verify: green`.

### 5. Commit

1. Run `git status --short`. Paste it.
2. Stage each path by name: `git add <path> <path>`.
3. Run `git status --short` again. Confirm that the staged list holds the files you wrote.
4. Commit with a message that states what changed.

Build output belongs in `.gitignore`. A compiled binary or a build directory in `git status` means
a missing ignore rule. Add the rule, then stage.

### 6. Report

Write one line for each criterion: the criterion, and the receipt that satisfies it.

Paste the final `verify: green` line.

Name any criterion that you left unsatisfied, and paste its `verify: red` output. A failure you
report is a finding for the next run.
