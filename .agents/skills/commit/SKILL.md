---
name: "commit"
description: "Generate commit message and commit"
---
Execute staging and commit as an explicit, multi-step procedure. Do NOT run
`git add` until step 2 is done.

## Step 0 — Run this on a low-cost model (MANDATORY)
Committing is mechanical work: read the diff, classify files, write short
imperative subjects, stage explicit paths. It must never burn top-tier tokens.

- Claude: run on **Sonnet** or **Haiku**. The main model cannot downgrade
  itself for a single step, so delegate this whole skill to a subagent
  (`general-purpose`) with `model: sonnet` (use `model: haiku` for a small,
  obvious diff). Pass along: follow the commit skill, do not redesign the
  code, do not push.
- Codex: run on **Terra** or **Luna** (prefer Luna for a small, obvious diff).
- If the current session is already on one of those cheap models, skip
  delegation and just continue with Step 1.
- Only escalate back to the top-tier model when the diff is genuinely
  ambiguous — e.g. it is unclear whether a change is a fix or a feature, or
  splitting it requires understanding the design intent. State why before
  escalating.

## Step 1 — Inspect
- Run `git status` and `git diff` (and `git diff --staged`) to see every change.

## Step 2 — Plan commits (MANDATORY, write it out)
- Classify EACH changed file into exactly one category:
  fix (production behavior) / feat / refactor / test / docs / config / chore.
- One commit per category by default. Treat these as ALWAYS-SEPARATE contexts:
  - production behavior change vs test-only / non-behavioral change
  - bug fix vs new feature
  - functional change vs pure refactor or formatting
  - unrelated subsystems / packages
- Default to splitting. Only combine when changes are meaningless apart
  (e.g. a function and its sole caller). If you combine, state why in one line.
- Output the plan as: commit N -> message + file list, ordered so each commit
  builds/tests on its own (fixes before the tests that assert them).

## Step 3 — Commit each group
- NEVER stage whole directories. Stage explicit file paths per group:
  `git add <file> <file> ...` then `git commit --no-gpg-sign`.
- Verify per commit: `git diff --staged --stat` matches the planned file list
  before committing.

## Rules
- Commit messages in English. Always `--no-gpg-sign`. No emojis.
- Do NOT prefix the subject with a conventional-commit type/scope
  (no `feat:`, `fix:`, `docs(scope):`, etc.). Write a plain imperative
  subject. The Step 2 category is only for deciding how to split commits,
  never for the message text.
- If branch is `master`/`main`, create a branch first with `git switch -c`.
  - Do NOT prefix the branch name with a type (no `feat/`, `fix/`, etc.).
  - Do NOT use `/` in the branch name.
- If a change resolves a GitHub issue, include the issue number in the body.
