---
name: re-sign-before-push
description: Re-sign all local Git commits ahead of origin/main before push by rewriting only local history with rebase and amend. Use when the user asks to re-sign local commits, satisfy signed-commit branch policies, or standardize signatures before running git push.
---

# Re Sign Before Push

Re-sign all local commits ahead of `origin/main` with signed commit metadata and stop before `git push`.

## Workflow

1. Ensure the repository is clean:
   - `git status --short` must be empty.
2. Preview local commits that will be rewritten:
   - `$HOME/.agents/skills/re-sign-before-push/scripts/resign-unsigned-local-commits.sh --dry-run`
3. Re-sign all commits in local-only history:
   - `$HOME/.agents/skills/re-sign-before-push/scripts/resign-unsigned-local-commits.sh`
4. Verify rewritten commit list:
   - `git log --oneline origin/main..HEAD`
5. Stop and report completion:
   - Do not run `git push` in this skill.
   - Share the exact push command only if the user asks.

## Script Options

- `--dry-run`: Show local commits to rewrite without changing history.
- `--upstream <ref>`: Use a specific base ref instead of `origin/main`.
- `--yes`: Skip the confirmation prompt and execute immediately.

## Safety Rules

- Rewrite all commits in `origin/main..HEAD` by default.
- Stop when the working tree is dirty.
- Stop when merge commits exist in the local-only range.
- Never run `git push` automatically in this skill.
