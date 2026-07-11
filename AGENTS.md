# Codex operating policy

## Task ownership and delegation

Keep design, evaluation, and judgment with the main Codex agent:

- Decide the implementation approach yourself.
- Review any delegated work yourself, including the full `git diff`.
- Analyze failures and decide how to fix them yourself.
- Do not ask a subagent to make architecture, product, or risk decisions.

Use subagents only when they clearly reduce busywork:

- Use lower-cost models for subagents by default.
- Delegate broad read-only exploration when only the conclusion matters, such as finding all usages of an identifier or mapping a large code area.
- Delegate mechanical edits only after the main agent has written a precise spec with target files and exact intended changes.
- The spec for delegated edits must say: do not redesign, do not commit.
- A subagent may run build, lint, and tests and report pass/fail, but the main agent decides what to do with failures.

Direct work is preferred for small or judgment-heavy changes:

- Tiny read/write tasks touching only one or two files may be done directly.
- Edits that require taste, interpretation, or careful local judgment should be done directly.
- If broad searches or batches of mechanical edits were done directly, call that out before finishing.

## Mandatory checks

Before doing exploration or edits, actively check whether delegation would help.

- When spawning a subagent, explicitly choose an appropriate lower-cost model when the tool supports model selection.
- For broad exploration, prefer a read-only subagent when available.
- For repetitive mechanical edits, prefer a delegated edit pass when available, then review the diff.
- Do not treat delegation as optional on non-trivial repetitive work.
- Never delegate commits.

## Common rules

### Language choice for throwaway scripts

- Never use Python for temporary or one-shot scripts.
- Choose from bash, Node.js, or Deno, preferring the lightest option in that order.
- Scripts that integrate into an existing Python codebase are exempt from this rule.

### Accessing 1Password

Before running any command that may trigger a 1Password approval dialog, state in user-facing text what the approval is needed for.

This applies to:

- Secret retrieval or session commands such as `op read`, `op item get`, `op signin`, and `op run`.
- Commands that internally invoke `op run`.
- Commands that access 1Password during install or startup, such as `pnpm install` or `dev:*` scripts.

When performing several retrievals or approvals together, state the purpose of each one in a separate sentence.
