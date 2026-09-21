# Verification is a separate skill from review

A review's completion criterion is "every defect in the diff found". An agent reviewer meets it
with a new finding every time it runs, so a loop of review, address, review never converges. We
considered a re-run of `to-feedback` that also verifies the claimed fixes. In that design the new
findings are the post-completion steps, and they tempt the agent to skim the verification. We
chose a separate skill, `verify-feedback`. Its criterion is "every claimed fix proven, gate green
on the head, verdict written", and it raises no new finding. The reviewer picks convergence or a
wider review by the skill they run.
