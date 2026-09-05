---
name: bootstrap
description: "Scaffold a new or early-stage repo to Matt's house conventions: agent entrypoint file, core skills via the skills CLI, and optional prose/comment enforcement. Safe to run more than once."
disable-model-invocation: true
---

# Bootstrap

Scaffold the conventions Matt starts every repo with. This is a prompt-driven process: explore,
present what you found, confirm with the user, then write. The repo's programming language,
runtime, and hosting stay undecided here; nothing in this skill assumes them.

Every step below is idempotent. Step 1 always runs first, and its findings decide, per step, one
of three actions: write fresh (nothing there yet), leave alone (already matches this skill's
intent), or offer a targeted update (something changed since the last run). Reuse a question step
1 already answered. Treat a block or file that already exists in the form this skill would write
as already done.

## 1. Explore

Read whatever exists; don't assume:

- `git remote -v`: does a host and owner/repo already exist? A repo that gained a remote since the
  last run can now adopt the GitHub-specific pieces of step 5.
- `AGENTS.md` and `CLAUDE.md`: does either exist?
- `README.md`, `.gitignore`
- `skills-lock.json`, `.claude/skills/`, `node_modules/`: has `npx skills@latest` already run here?
  Diff the baseline in step 3 against the lock file's keys to find what is still missing.
- A skill directory that exists under an agent directory (`.claude/skills/<name>`,
  `.agents/skills/<name>`) but has no matching entry in `skills-lock.json`: a copy made by hand,
  or made before this repo adopted the skills CLI. Flag it for step 3 to replace.
- `docs/standards/`, `docs/agents/`, `.banned-patterns`, `.claude/hooks/`, `.claude/settings.json`,
  `.github/workflows/`: present, absent, or (for `check-banned-patterns.sh` and its hook) still on
  the Markdown-only default after the repo's source language was decided.

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

- Every skill under `mattpocock/skills`, in its `skills/engineering/` and `skills/productivity/`
  directories, except each directory's own `README.md`. Do not hardcode the names here, since Matt
  adds new skills to both directories over time. List the current names with
  `gh api repos/mattpocock/skills/contents/skills/engineering --jq '.[].name'`, then run the same
  command for `skills/productivity`. Skip `skills/misc/`, `skills/in-progress/`, and
  `skills/deprecated/`. The `in-progress` directory holds unfinished skills. The `deprecated`
  directory is empty.
- Among these skills, install `setup-matt-pocock-skills` first. Run it immediately after install.
  It configures the issue tracker, the triage label vocabulary, and the domain-doc layout that the
  other engineering skills need. It replaces the manual setup this skill used before.
- `TheAngryByrd/simplified-technical-english-skill`: recommend by default. Step 5 below assumes it
  is present.

When you install the STE skill, ask the user one question: do they have an authorized copy of the
ASD-STE100 Issue 9 PDF already, from another repo or a prior download? On yes, ask for its path
and copy it to `<installed-skill-path>/assets/ASD-STE100-ISSUE-9.pdf`. On no, or on skip, leave it
out. The installed skill's own `assets/README.md` already tells the user how to request an
authorized copy and set `ASD_STE100_PDF` later. Do not fetch, generate, or otherwise source the
PDF yourself. ASD's terms do not permit redistribution.

Install shape: `npx skills@latest add <owner>/<repo> -s <skill-name> -a claude-code universal -y
--copy`. Name each agent this project targets. Do not use `-a '*'`. This flag writes a directory
for every agent the CLI supports. Most of these agents are not part of this project. Always add
`--copy`. This flag writes a real file to `.claude/skills/`. Without `--copy`, the CLI writes a
symlink into `.agents/skills/` instead. Some tools resolve a symlink against the tool's own
install path. They do not use the link's location. These tools cannot read the skill through a
symlink. The user can find more candidate skills with `npx skills@latest find <query>`.

The CLI clones each skill's source with plain `git`, so a private source (this skill's own
`tw0po1nt/skills` included) needs the machine's existing git credentials to already cover it: a
`gh auth login` with access to the repo, an SSH key registered with GitHub, or a `GITHUB_TOKEN`
environment variable. A failed install names the missing piece. Confirm access before the install
step on a machine you have not bootstrapped from before.

On a repeat run, install only a baseline skill missing from `skills-lock.json`. For a skill
directory step 1 flagged as hand-copied or pre-CLI, confirm with the user, then delete that
directory and install the same skill fresh through the command above, so `skills-lock.json` picks
up a real entry for it. When the project starts using an agent it did not target before (a new
contributor's editor, a new CLI), rerun the same install command for each already-installed skill
with the added agent name. The CLI updates the existing entry rather than creating a duplicate.

`.agents/skills/` is the CLI's own store for the `universal` agent. `.claude/skills/` holds a copy
of each skill for Claude Code. Add both directories, plus `node_modules/`, to `.gitignore`. Track
only `skills-lock.json`. Every directory above regenerates from it. Copy
[`bootstrap.sh`](templates/bootstrap.sh) to `scripts/bootstrap.sh` as the one-command
fresh-clone restore, and mention it in the entrypoint file. As of `skills@1.5.23`,
`experimental_install` can loop on a large lock file and exit non-zero without finishing the
restore. If this happens, fall back to `npx skills@latest add <owner>/<repo> -s <skill-name> -a
claude-code universal -y --copy` per skill listed in `skills-lock.json`.

## 4. README

Create an empty `README.md` if none exists. Leave the content to the user.

## 5. Prose and comment enforcement (optional, ask)

Recommend this bundle only when step 3 installed the STE skill; the two pieces below assume it and
cite it by name. Ask before adopting. Ask again on a repeat run when a prior run declined it.

- [`banned-patterns`](templates/banned-patterns) → `.banned-patterns` at the repo root
- [`check-banned-patterns.sh`](templates/check-banned-patterns.sh) →
  `scripts/check-banned-patterns.sh`
- [`technical-prose.md`](templates/technical-prose.md) → `docs/standards/technical-prose.md`
- [`hooks/banned-patterns-check.sh`](templates/hooks/banned-patterns-check.sh),
  [`hooks/ste-reminder-docs.sh`](templates/hooks/ste-reminder-docs.sh),
  [`hooks/ste-reminder-gh.sh`](templates/hooks/ste-reminder-gh.sh) → `.claude/hooks/`
- [`settings.json`](templates/settings.json): merge its `PreToolUse` hooks into
  `.claude/settings.json`. Preserve an existing file's other content.
- When the repo hosts on GitHub: [`ci-github.yml`](templates/ci-github.yml) →
  `.github/workflows/ci.yml`, running `scripts/check-banned-patterns.sh`. Add a step to an
  existing workflow when one already runs on the same triggers, rather than a new file.

`check-banned-patterns.sh` and its hook check Markdown only, out of the box. Both carry a
`LANGUAGE` marker showing where to add a case for this repo's source language, once chosen: a
stripper that reduces that language's comment lines and string literals to prose the same way the
Markdown case does, plus its extension registered in the file-glob and the `case` that picks a
stripper. Revisit this the day the language is decided. A guess now would go stale.

## 6. Coding standards doc

Seed [`coding-standards.md`](templates/coding-standards.md) at
`docs/standards/coding-standards.md` if missing. It starts with no numbered rule; a rule earns
its place only when a real review finding shows an unwritten convention caused a problem. When
step 5 is adopted, its first rule states that a comment cites nothing off the page, matching
`technical-prose.md`'s rule that a code comment
carries the same STE and antithesis requirements as any other prose in the repo.

## 7. Confirm and write

Show the user the entrypoint-file diff and the list of files each adopted section would add, before
writing. Skip a question whose answer step 1 already settled: a file that already exists, a skill
already installed.

Done when: `scripts/bootstrap.sh` exists and restores every installed skill from
`skills-lock.json`; the entrypoint file names each adopted piece with a one-line pointer to its
doc; running `scripts/check-banned-patterns.sh` (when step 5 was adopted) exits clean on the
repo's current content.

## 8. Re-running

This skill is not a one-time setup. Rerun it whenever the repo's situation changed since the last
run, rather than making the same edit by hand. Situations worth a rerun for:

- A baseline skill is missing from `skills-lock.json` on a repo bootstrapped before it joined the
  baseline in step 3.
- A skill directory exists that step 1 flags as hand-copied or pre-CLI: a manual copy of
  `simplified-technical-english`, made before this skill existed and later replaced through
  `npx skills@latest add`, is the case that motivated this rule.
- The repo's source language went from undecided to chosen: revisit the `LANGUAGE` marker in
  step 5's script and hook.
- The repo gained a GitHub remote after step 5 ran without one: adopt `ci-github.yml` now.
- A prior run declined the step 5 bundle and the user now wants it.
- A new agent (editor, CLI) joined the project after step 3 ran: extend each already-installed
  skill to the added agent.

A rerun for one of these still starts at step 1. Its findings are what tell every later step
whether to write, leave alone, or update.
