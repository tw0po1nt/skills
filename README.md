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
- [`to-abstract`](skills/to-abstract/SKILL.md): splits a `to-spec` issue in two. The full spec
  moves verbatim into a `docs/spec` file and a PR, and the issue is rewritten as a short abstract
  linking back to it.
