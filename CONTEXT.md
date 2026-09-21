# Skills

Matt's personal agent skills. This glossary holds the terms the skills share, so each skill uses
one word for one thing.

## Language

### Review feedback

**Review**:
One pass of `/code-review` over a diff. It produces findings.
_Avoid_: audit, critique

**Finding**:
One defect or judgement call a review raised. It has an id, a kind, a state, a location, a rule,
a fix, and a done-when.
_Avoid_: issue, comment, item, nit

**Ledger**:
The living document that holds every finding for one pull request. One PR comment, or a local
file when no PR exists.
_Avoid_: feedback file, review doc, report

**Feedback**:
The ledger as the implementer receives it. The word in the skill names.

**Kind**:
Whether a finding is `required` (a breach of a documented standard or of the spec) or `optional`
(a smell, a design note, a nit). Only an optional finding can be declined.
_Avoid_: severity, priority

**State**:
Where a finding is in its life: `open`, `addressed`, `declined`, or `blocked`.
_Avoid_: status (that word names the ledger's summary line)

**Round**:
One cycle of `to-feedback`, then `address-feedback`, then `verify-feedback`.
_Avoid_: iteration, pass

**Verdict**:
The ledger line that says whether the PR is ready to merge. Only `verify-feedback` writes it.
_Avoid_: approval, sign-off

**Gate**:
The one command that decides whether work is done: `scripts/verify.sh`, or the PR's CI checks.
_Avoid_: tests, checks (a gate holds many checks)

**Receipt**:
Command output pasted under the command that produced it. The only accepted evidence in a report.
_Avoid_: log, proof
