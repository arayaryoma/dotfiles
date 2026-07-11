# Model tiering policy (subagent delegation)

Pick the model tier by the nature of the task:

- **Design, evaluation, and judgment stay with the main model (top-tier model)**: designing the implementation approach, reviewing subagent output (the diff), and analyzing failures and deciding how to fix them must be done by the main model itself. Never offload these to a subagent.
- **Delegate read-only exploration to Haiku**: broad searches where only the conclusion matters — finding all usages of an identifier, mapping code structure — go to an `Explore` subagent with `model: haiku`.
- **Delegate mechanical file edits to Sonnet**: the main model first pins down the edits as a precise spec (target files, exact before/after code), then has a `general-purpose` subagent with `model: sonnet` apply it. The spec must state: do not redesign, do not commit.
- **Subagents may run build/lint/tests and judge pass/fail**: the subagent doing the edits may also run the checks and report results. But when something fails, deciding how to fix it is the main model's job.
- **Review after delegation is mandatory**: after a subagent edits, the main model reviews the full `git diff`.
- **Exception**: edits requiring judgment, or tiny read/write tasks touching only 1–2 files, may be done directly by the main model — delegation overhead outweighs the benefit there.

## Enforcement (mandatory, not optional)

These tiers are the default and MUST be applied on every non-trivial task, not treated as a nice-to-have. Before doing exploration or edits yourself, actively check whether delegation applies.

- **Exploration → always Haiku**: when spawning an `Explore` (or search) subagent, you MUST pass `model: haiku` explicitly. Do not rely on the agent's default model. Not setting it is a violation.
- **Mechanical edits → always Sonnet**: for edits that are not judgment-heavy (boilerplate, near-copies of existing files, repetitive stories/tests, rote refactors across files), the main model writes a precise before/after spec and delegates to a `general-purpose` subagent with `model: sonnet` (spec must say: do not redesign, do not commit), then reviews the returned `git diff`. Doing these yourself "because it's faster" is a violation — only the 1–2 file / judgment exception justifies direct edits.
- **Self-check before finishing**: if a task involved broad searches or any batch of mechanical edits and you did them directly without delegating, call it out explicitly rather than letting it pass silently.

# Common rules

## Code comments

- Write comments that explain **why** the code needs to do this (Why), not **what** it is doing (What).
- Do not write comments stating the obvious — anything already readable from the code itself.

## Language choice for throwaway scripts

- Never use Python for temporary / throwaway (one-shot) scripts.
- Choose from Node.js, Deno, or bash (prefer the lightest option; consider them in the order bash → Node.js → Deno).
- Scripts that integrate into an existing Python codebase are exempt from this rule.

## Accessing 1Password

- Before running any command that triggers a 1Password approval dialog (e.g. via the `op` command), state in user-facing text what the approval is needed for, immediately before running it.
- Applies to:
  - Secret-retrieval / session-start commands such as `op read` / `op item get` / `op signin` / `op run`.
  - Commands that internally invoke `op run`, or access 1Password during postinstall and thus request approval — such as `pnpm install` or `dev:*` scripts.
- When performing several retrievals/approvals together, state the purpose of each one, one sentence per item.
