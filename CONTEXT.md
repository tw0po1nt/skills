# Skills

Matt's personal agent skills. This glossary holds the terms the skills share, so each skill uses
one word for one thing.

## Language

### Review feedback

**Review**:
One run of `/code-review` over a diff. It produces findings.
_Avoid_: audit, critique, pass

**Finding**:
One defect or judgement call that a review raised. It has a stable id.
_Avoid_: issue, comment, item, nit

**Ledger**:
The document that holds every finding for one pull request. Only a `to-feedback` run creates
it, so most pull requests have no ledger.
_Avoid_: feedback file, review doc, report

**Feedback**:
The ledger as the implementer receives it. The word in the skill names.

**Kind**:
Whether a finding is `required` or `optional`.
_Avoid_: severity, priority

**State**:
Where a finding is in its life: `open`, `addressed`, `declined`, or `blocked`.
_Avoid_: status

**Summary**:
The ledger line that names the reviewed commit and the ids in each state.
_Avoid_: status, tally

**Done when**:
The condition on a finding that a reader can check from the diff.
_Avoid_: acceptance criteria, definition of done

**Verdict**:
The ledger line that says whether the PR is ready to merge.
_Avoid_: approval, sign-off

**Gate**:
The one check that decides whether a change is sound.
_Avoid_: tests, checks (a gate holds many checks)

**Receipt**:
Command output pasted under the command that produced it.
_Avoid_: log, proof
