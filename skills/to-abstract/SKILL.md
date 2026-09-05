---
name: to-abstract
description: "Split a spec issue in two: the full user-storied body becomes a permanent docs/spec file that grounds agents, while the issue itself is rewritten as a short human-readable abstract linking back to it."
disable-model-invocation: true
---

# To Abstract

A `to-spec` issue is long on purpose: exhaustive user stories ground the agents that will
implement it. That length is what a human reader wants to skip. This skill splits the two
audiences apart. The full spec becomes a permanent file under `docs/spec/`. The issue is rewritten
as a short **abstract** that links back to it.

The issue tracker and triage label vocabulary should have been provided to you. If not, tell the
user to run `/setup-matt-pocock-skills`.

## Process

### 1. Gather context

Work from whatever spec issue is already in conversation context. If the user passes a reference
(an issue number or URL) as an argument, fetch its full body instead.

### 2. Check whether this issue was already abstracted

Look for an existing `docs/spec/<issue-number>-*.md` file. Its presence decides whether the issue
was already abstracted; the issue's title only echoes that fact. The file is the permanent source,
so a rewritten issue body is always safe to overwrite again.

- **File exists**: this run is a refresh. Skip to step 5 to recompute the abstract from the
  existing file, then step 6 to rewrite the issue. Leave `docs/spec/` and the PR alone.
- **No file yet**: continue to step 3.

### 3. Place the spec file

Find where `docs/spec/` belongs: the repo root by default, or `src/<context>/docs/spec/` in a
multi-context repo (one with a `CONTEXT-MAP.md`), matching that context's `docs/adr/` placement.
Use the domain glossary to identify the context the spec belongs to.

Name the file `<issue-number>-<slug>.md`, where `<slug>` is a kebab-case cut of the issue title.

### 4. Copy the spec verbatim and open a PR

Check the working tree is clean before branching. Stop and tell the user if it isn't.

1. Create a branch: `docs/spec-<issue-number>-<slug>`.
2. Write the spec file: a single `Source: <issue URL>` line, a blank line, then the issue body
   copied verbatim. Add nothing else: no frontmatter, no paraphrasing.
3. Commit, push, and open a PR against the default branch. Leave the PR open for the user to
   review and merge. This skill never merges its own PR.

### 5. Write the abstract

Condense the spec's `Problem Statement` and `Solution` sections into a couple of sentences each.
Drop the user stories, implementation decisions, testing decisions, and every other section. That
detail now lives in the spec file.

<abstract-template>

## Problem

A couple of sentences: the problem from the user's perspective.

## Solution

A couple of sentences: the solution from the user's perspective.

Full spec: `<link to the spec file on the default branch>`

</abstract-template>

The link points at the file's path on the default branch. It returns a 404 until the PR merges.
That tradeoff buys a link that stays correct forever after, instead of one tied to a branch that
may later be deleted.

### 6. Rewrite the issue

Prefix the issue's title with `Feature: `. Skip the prefix if it's already there. Replace the
description with the abstract from step 5.

Leave every child sub-issue (from `to-tickets`) untouched. Each references the parent by issue
number, a value this skill never changes, so none of them need an update. This skill also carries
no requirement that `to-tickets` has run first: the spec file preserves the verbatim body no
matter when this skill runs.
