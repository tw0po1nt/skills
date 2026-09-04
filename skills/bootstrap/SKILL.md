---
name: bootstrap
description: "Scaffold a new or early-stage repo to Matt's house conventions: agent entrypoint file, core skills via the skills CLI, and optional prose/comment enforcement. Run once, early in a repo's life."
disable-model-invocation: true
---

# Bootstrap

Scaffold the conventions Matt starts every repo with. This is a prompt-driven process: explore,
present what you found, confirm with the user, then write. The repo's programming language,
runtime, and hosting stay undecided here; nothing in this skill assumes them.

## 1. Explore

Read whatever exists; don't assume:

- `git remote -v`: does a host and owner/repo already exist?
- `AGENTS.md` and `CLAUDE.md`: does either exist?
- `README.md`, `.gitignore`
- `skills-lock.json`, `.claude/skills/`, `node_modules/`: has `npx skills@latest` already run here?
- `docs/standards/`, `docs/agents/`, `.banned-patterns`, `.claude/hooks/`, `.claude/settings.json`,
  `.github/workflows/`

## 2. Agent entrypoint file

Recommend: create `AGENTS.md` as the primary file, and a one-line `CLAUDE.md` containing only
`@AGENTS.md`, so Claude Code and every other agent read the same source. If one file already
exists, edit it in place. Ask before creating both fresh: some agents don't resolve `@`-includes,
and a user may want two independent files instead.

## 3. Core skills, through the skills CLI

Every skill this repo needs comes from [`npx skills@latest`](https://skills.sh). Copying another
author's `SKILL.md` into this repo forks it from its source: it stops receiving updates, and it
carries no record of where it came from. The CLI's own `skills-lock.json` is that record.

Recommend this baseline, and confirm before installing anything beyond it:

- `mattpocock/skills -s setup-matt-pocock-skills`: configures the issue tracker, the triage label
  vocabulary, and the domain-doc layout for this repo. Run it immediately after install; it
  replaces what this skill used to do by hand.
- `TheAngryByrd/simplified-technical-english-skill`: recommend by default. Step 5 below assumes it
  is present.

When you install the STE skill, ask the user one question: do they have an authorized copy of the
ASD-STE100 Issue 9 PDF already, from another repo or a prior download? On yes, ask for its path
and copy it to `<installed-skill-path>/assets/ASD-STE100-ISSUE-9.pdf`. On no, or on skip, leave it
out. The installed skill's own `assets/README.md` already tells the user how to request an
authorized copy and set `ASD_STE100_PDF` later. Do not fetch, generate, or otherwise source the
PDF yourself. ASD's terms do not permit redistribution.

Install shape: `npx skills@latest add <owner>/<repo> -s <skill-name> -a claude-code universal -y`.
Name each agent this project targets; `-a '*'` also writes a directory for every other agent the
CLI supports, most of them irrelevant to this project, so avoid it. The user can browse further
candidates with `npx skills@latest find <query>`.

`.agents/skills/` is the CLI's own store for the `universal` agent, and `.claude/skills/` holds
its Claude Code symlinks. Add both, plus `node_modules/`, to `.gitignore`. Track only
`skills-lock.json`. Every directory above regenerates from it. Copy
[`bootstrap.sh`](bootstrap.sh) to `scripts/bootstrap.sh` as the one-command fresh-clone restore,
and mention it in the entrypoint file. As of `skills@1.5.23`, `experimental_install` can loop on a
large lock file and exit non-zero without finishing the restore; if it does, fall back to `npx
skills@latest add <owner>/<repo> -s <skill-name> -a claude-code universal -y` per skill listed in
`skills-lock.json`.

## 4. README

Create an empty `README.md` if none exists. Leave the content to the user.

## 5. Prose and comment enforcement (optional, ask)

Recommend this bundle only when step 3 installed the STE skill; the two pieces below assume it and
cite it by name. Ask before adopting:

- [`banned-patterns`](banned-patterns) → `.banned-patterns` at the repo root
- [`check-banned-patterns.sh`](check-banned-patterns.sh) → `scripts/check-banned-patterns.sh`
- [`technical-prose.md`](technical-prose.md) → `docs/standards/technical-prose.md`
- [`hooks/banned-patterns-check.sh`](hooks/banned-patterns-check.sh),
  [`hooks/ste-reminder-docs.sh`](hooks/ste-reminder-docs.sh),
  [`hooks/ste-reminder-gh.sh`](hooks/ste-reminder-gh.sh) → `.claude/hooks/`
- [`settings.json`](settings.json): merge its `PreToolUse` hooks into `.claude/settings.json`.
  Preserve an existing file's other content.
- When the repo hosts on GitHub: [`ci-github.yml`](ci-github.yml) → `.github/workflows/ci.yml`,
  running `scripts/check-banned-patterns.sh`. Add a step to an existing workflow when one already
  runs on the same triggers, rather than a new file.

`check-banned-patterns.sh` and its hook check Markdown only, out of the box. Both carry a
`LANGUAGE` marker showing where to add a case for this repo's source language, once chosen: a
stripper that reduces that language's comment lines and string literals to prose the same way the
Markdown case does, plus its extension registered in the file-glob and the `case` that picks a
stripper. Revisit this the day the language is decided. A guess now would go stale.

## 6. Coding standards doc

Seed [`coding-standards.md`](coding-standards.md) at `docs/standards/coding-standards.md` if
missing. It starts with no numbered rule; a rule earns its place only when a real review finding
shows an unwritten convention caused a problem. When step 5 is adopted, its first rule states that
a comment cites nothing off the page, matching `technical-prose.md`'s rule that a code comment
carries the same STE and antithesis requirements as any other prose in the repo.

## 7. Confirm and write

Show the user the entrypoint-file diff and the list of files each adopted section would add, before
writing. Skip a question whose answer step 1 already settled: a file that already exists, a skill
already installed.

Done when: `scripts/bootstrap.sh` exists and restores every installed skill from
`skills-lock.json`; the entrypoint file names each adopted piece with a one-line pointer to its
doc; running `scripts/check-banned-patterns.sh` (when step 5 was adopted) exits clean on the
repo's current content.
