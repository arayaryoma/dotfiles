---
name: "commit"
description: "Generate commit message and commit"
---
Execute `git commit --no-gpg-sign` following these rules:
- Write commit messages in English.
- Always disable commit signing (`--no-gpg-sign`).
- If the current branch is `master` or `main`, create a new branch.
- If a single commit spans multiple contexts, stage only the necessary files with `git add` and split the commit.
- Do not use emojis.
- If the changes are known to resolve a GitHub issue, include the issue number in the commit message body.
- After creating a commit message, ask the user to confirm the full text before proceeding.
