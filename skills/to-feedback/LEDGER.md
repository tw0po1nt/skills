# The feedback ledger

The **ledger** is one document for each pull request. It holds every **finding** that a review
has raised, with the **state** of each. Three skills share it. `to-feedback` creates and extends
it. `address-feedback` works it. `verify-feedback` judges it and writes the **verdict**.

## Location

The ledger is one PR comment. Its first line is the marker `<!-- feedback-ledger -->`.

Find it:

```bash
gh api "repos/{owner}/{repo}/issues/<pr>/comments" \
  --jq '.[] | select(.body | startswith("<!-- feedback-ledger -->")) | .id'
```

Create it when the query prints nothing:

```bash
gh pr comment <pr> --body-file ledger.md
```

Replace it in place when the query prints an id:

```bash
gh api --method PATCH "repos/{owner}/{repo}/issues/comments/<id>" -F body=@ledger.md
```

When the branch has no PR, the ledger is the file `.scratch/feedback-<branch>.md`, where each
`/` in the branch name becomes `-`. The next `to-feedback` run that finds a PR moves the file
into a comment and deletes the file.

## Format

```markdown
<!-- feedback-ledger -->
# Feedback: PR #165

Base: `main` at `a8393de`. Spec: issue #151. Standards: `docs/standards/coding-standards.md`.

## Status

Reviewed at `36ca10e`. Open: S1, C2. Addressed: C1. Declined: C7.

## Verdict

Pending.

## Findings

### S1. `OVERLAY_WIDTH` cannot hold the widest score

- State: open
- Kind: required
- Where: `tetris-tui/src/layout.rs:33-34` at `36ca10e`
- Rule: "The overlay shows the final Score, the final Level, and the cleared line count."
- Problem: The interior is 16 columns. `Score: 4294967295` is 17 columns, and `score` is `u32`.
- Fix: Raise `OVERLAY_WIDTH` to 19. Add a widget test that renders a `u32::MAX` score.
- Done when: The test renders the full number, and both ending snapshots are regenerated.

### C1. False fact in the `OVERLAY_WIDTH` comment

- State: addressed in `b1c2d3e`
- Kind: required
- Where: `tetris-tui/src/layout.rs:33-34` at `36ca10e`
- Rule: `coding-standards.md` rule 5, a comment states a fact.
- Problem: The comment claims the widest score fits. It does not.
- Fix: Fixing S1 makes the comment true.
- Done when: The comment names the true bound.

### C7. `overlay(matrix)` is a second layout entry point

- State: declined: the diff is small, and `Areas` gains a field when a second overlay appears.
- Kind: optional
- Where: `tetris-tui/src/layout.rs:87` at `36ca10e`
- Rule: Baseline smell, divergence from the `layout::areas()` pattern.
- Problem: Every other rect comes out of `Areas`.
- Fix: Add an `overlay` field to `Areas`.
- Done when: `draw.rs` reads `areas.overlay`.
```

## Rules

- **Id**: `S<n>` for a Spec finding, `C<n>` for a Standards finding. Numbers count up from 1
  and are never reused. A new review continues from the highest existing number on that axis.
  A finding that matches an existing one (same file, same problem) keeps the existing id.
- **State**: one of `open`, `addressed in <sha>`, `declined: <reason>`, `blocked: <reason>`.
  A reopened finding returns to `open` with a `Reopened:` line under it that says why.
- **Kind**: `required` for a breach of a documented standard or of the spec. `optional` for a
  baseline smell, a design note, or a style nit. Only an optional finding can be declined.
- **Where**: a `path:line` range pinned to the commit the review read. Lines move, the pin
  does not.
- **Rule**: the quoted standard or spec line the finding rests on.
- **Done when**: a condition a reader can check from the diff. It is what `verify-feedback`
  tests, so write it as an observable fact.
- **Status**: the commit last reviewed, then the ids in each state. Written by `to-feedback`
  and `address-feedback`.
- **Verdict**: `Pending.`, `Ready to merge at <sha>.`, or `Not ready: <ids> open.`. Only
  `verify-feedback` writes a verdict. Any other skill that changes a finding resets the verdict
  to `Pending.`.
