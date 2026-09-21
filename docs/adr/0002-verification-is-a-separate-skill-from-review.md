# Verification is a separate skill from review

A review's completion criterion is "every defect in the diff found", and an agent reviewer finds
something every time it runs. A loop of review, address, review therefore never converges. We
considered folding verification into a re-run of `to-feedback`, which would have made the new
findings the post-completion steps that tempt the agent to skim the checking. We chose a separate
skill, `verify-feedback`, whose criterion is "every claimed fix proven, gate green on the head,
verdict written" and which raises no new finding. The reviewer chooses convergence or widening by
which skill they run.
