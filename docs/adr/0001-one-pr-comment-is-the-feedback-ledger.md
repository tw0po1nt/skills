# One PR comment is the feedback ledger

Review findings need a home that the reviewer and the implementer both reach, on any machine,
across every run of the loop. We considered three homes. A local file leaves no record and needs
a shared filesystem. A GitHub review with line comments loses its anchors as the implementer
edits, and one finding cannot change state in place. A file committed to the branch puts
feedback churn in git history. We chose one PR comment, found by a marker line and replaced in
place on every write. One body makes the ledger idempotent and gives the implementer one list to
work. A local `.scratch` file stands in until a PR exists.
