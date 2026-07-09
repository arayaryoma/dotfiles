# Model tiering policy (subagent delegation)

Pick the model tier by the nature of the task:

- **Design, evaluation, and judgment stay with the main model (top-tier model)**: designing the implementation approach, reviewing subagent output (the diff), and analyzing failures and deciding how to fix them must be done by the main model itself. Never offload these to a subagent.
- **Delegate read-only exploration to Haiku**: broad searches where only the conclusion matters — finding all usages of an identifier, mapping code structure — go to an `Explore` subagent with `model: haiku`.
- **Delegate mechanical file edits to Sonnet**: the main model first pins down the edits as a precise spec (target files, exact before/after code), then has a `general-purpose` subagent with `model: sonnet` apply it. The spec must state: do not redesign, do not commit.
- **Subagents may run build/lint/tests and judge pass/fail**: the subagent doing the edits may also run the checks and report results. But when something fails, deciding how to fix it is the main model's job.
- **Review after delegation is mandatory**: after a subagent edits, the main model reviews the full `git diff`.
- **Exception**: edits requiring judgment, or tiny read/write tasks touching only 1–2 files, may be done directly by the main model — delegation overhead outweighs the benefit there.
