# skills

Matt's personal agent skills.

This repo holds skills for Matt's own projects. Install a skill from this repo through a
project's skill manager (GitHub source, `skills/<name>/SKILL.md`). Each skill folder documents
itself.

## Skills

- [`bootstrap`](skills/bootstrap/SKILL.md): scaffolds a new or early-stage repo to Matt's house
  conventions. Sets up the agent entrypoint file, installs the core skills through `npx
  skills@latest`, and offers an optional prose and comment enforcement bundle. Safe to run more
  than once as a repo's situation changes.
- [`next-task`](skills/next-task/SKILL.md): retires the current feature branch and resets the
  repository to the default branch before the next task starts. Confirms the branch has landed
  through `gh` first, with a git ancestry fallback, before deleting it.
- [`to-abstract`](skills/to-abstract/SKILL.md): splits a `to-spec` issue in two. The full spec
  moves verbatim into a `docs/spec` file and a PR, and the issue is rewritten as a short abstract
  linking back to it.
- [`to-feedback`](skills/to-feedback/SKILL.md): writes a code review to the feedback ledger, one
  PR comment where each finding has a stable id, a state, and a checkable done-when. A re-run
  extends the ledger and keeps every id.
- [`address-feedback`](skills/address-feedback/SKILL.md): works the open findings in the ledger of
  the current branch, one finding at a time with the repo gate after each and one commit per
  finding, then pushes and records each outcome.
- [`verify-feedback`](skills/verify-feedback/SKILL.md): proves each addressed finding from its
  commit, weighs each declined one, proves the gate on the PR head, and writes a ready-to-merge
  verdict. Raises no new findings, so the loop converges.
