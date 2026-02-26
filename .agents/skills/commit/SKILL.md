---
name: "commit"
description: "Generate commit message and commit"
---
Execute Git staging and commit in separate steps following these rules:
- Run `git add` first to stage only the intended files.
- Run `git commit --no-gpg-sign` after staging is complete.
- Write commit messages in English.
- Always disable commit signing (`--no-gpg-sign`).
- If the current branch is `master` or `main`, create a new branch.
- If a single commit spans multiple contexts, stage only the necessary files with `git add` and split the commit.
- Do not use emojis.
- If the changes are known to resolve a GitHub issue, include the issue number in the commit message body.
