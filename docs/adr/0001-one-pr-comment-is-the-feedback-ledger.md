# One PR comment is the feedback ledger

Review findings need a home that the reviewing agent and the implementing agent both reach, on
any machine, across several rounds. We considered a local file (it leaves no record and needs a
shared filesystem), a GitHub review with line comments (line anchors go stale as the implementer
edits, and one finding cannot change state in place), and a file committed to the branch (it puts
feedback churn in git history). We chose one PR comment, found by a marker line and replaced in
place on every write. One body makes the ledger idempotent and gives the implementer one list to
work. A local `.scratch` file stands in only until a PR exists.
