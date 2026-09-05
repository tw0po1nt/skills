# Setup

One pass for each repo, run by a human or by a frontier model. The local model that runs
[`SKILL.md`](SKILL.md) reads none of this.

The two scripts hold the parts that a document cannot carry. `preflight.sh` resolves the context,
so the model reaches the ticket through one command rather than a chain of pointers. `verify.sh`
holds the gate, so the pass condition comes from a script that the model found in the repo.

## Install

1. Copy `templates/preflight.sh` and `templates/verify.sh` into `scripts/`.
2. Run `chmod +x scripts/preflight.sh scripts/verify.sh`.
3. Edit the `tool_commands` array at the top of `preflight.sh`. List the command that prints each
   toolchain version this repo compiles with, such as `rustc --version` and `cargo --version`.
4. Edit the `checks` array at the top of `verify.sh`. List every command that must pass before a
   commit, in the order that CI runs them.
5. Run `./scripts/preflight.sh <issue-number>` and read the bundle. Add a source that the model
   needs and that the bundle omits.
6. Run `./scripts/verify.sh` on a clean tree. Confirm that it prints `verify: green`.

## Keep the gate honest

`checks` holds the same commands as the CI workflow. A gate that passes where CI fails teaches the
model that green means nothing.

Each check runs the real build. A check that compiles a single file, or that runs in one crate of a
workspace, reports success on a repo that does not build.

Commit both scripts. The gate works because the model finds it in the repo and runs it. A model
that writes its own gate writes one that passes.
