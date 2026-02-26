---
name: re-sign-before-push
description: Re-sign all local unpushed Git commits before push by rewriting only local history with rebase and amend. Use when the user asks to re-sign local commits, satisfy signed-commit branch policies, or standardize signatures before running git push.
---

# Re Sign Before Push

Re-sign all local unpushed commits with signed commit metadata and stop before `git push`.

## Workflow

1. Ensure the repository is clean:
   - `git status --short` must be empty.
2. Preview local commits that will be rewritten:
   - `scripts/resign-unsigned-local-commits.sh --dry-run`
3. Re-sign all commits in local-only history:
   - `scripts/resign-unsigned-local-commits.sh`
4. Verify rewritten commit list:
   - `git log --oneline @{upstream}..HEAD`
5. Stop and report completion:
   - Do not run `git push` in this skill.
   - Share the exact push command only if the user asks.

## Script Options

- `--dry-run`: Show local commits to rewrite without changing history.
- `--upstream <ref>`: Use a specific upstream ref instead of `@{upstream}`.
- `--yes`: Skip the confirmation prompt and execute immediately.

## Safety Rules

- Rewrite all commits in `<upstream>..HEAD`.
- Stop when the working tree is dirty.
- Stop when merge commits exist in the local-only range.
- Never run `git push` automatically in this skill.
