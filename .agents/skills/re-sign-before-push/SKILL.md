---
name: re-sign-before-push
description: Re-sign unsigned local Git commits before push by rewriting only unpushed history. Use when the user asks to fix unsigned commits, satisfy signed-commit branch policies, or check that local commits are signed before running git push.
---

# Re Sign Before Push

Re-sign local unpushed commits with signed commit metadata and stop before `git push`.

## Workflow

1. Ensure the repository is clean:
   - `git status --short` must be empty.
2. Detect unsigned local commits:
   - `scripts/resign-unsigned-local-commits.sh --dry-run`
3. Re-sign unsigned commits in local-only history:
   - `scripts/resign-unsigned-local-commits.sh`
4. Verify signatures:
   - `git log --oneline --show-signature @{upstream}..HEAD`
5. Stop and report completion:
   - Do not run `git push` in this skill.
   - Share the exact push command only if the user asks.

## Script Options

- `--dry-run`: Show unsigned commits without rewriting history.
- `--upstream <ref>`: Use a specific upstream ref instead of `@{upstream}`.
- `--yes`: Skip the confirmation prompt and execute immediately.

## Safety Rules

- Rewrite only commits in `<upstream>..HEAD`.
- Stop when the working tree is dirty.
- Stop when merge commits exist in the local-only range.
- Never run `git push` automatically in this skill.
