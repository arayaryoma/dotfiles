#!/usr/bin/env bash

set -euo pipefail

UPSTREAM_REF=""
DRY_RUN=0
ASSUME_YES=0

usage() {
  cat <<'EOF'
Usage:
  resign-unsigned-local-commits.sh [--upstream <ref>] [--dry-run] [--yes]

Options:
  --upstream <ref>  Use an explicit upstream ref instead of @{upstream}
  --dry-run         Print target commits without rewriting history
  --yes             Skip confirmation prompt
  -h, --help        Show this help

Behavior:
  - Inspect local-only commits in <upstream>..HEAD
  - Detect commits with no signature (%G? == N)
  - Rebase from the parent of the first unsigned commit
  - During rebase, amend unsigned commits with `git commit --amend --no-edit -S`
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --upstream)
      if [[ $# -lt 2 ]]; then
        echo "error: --upstream requires a value" >&2
        exit 1
      fi
      UPSTREAM_REF="$2"
      shift 2
      ;;
    --dry-run)
      DRY_RUN=1
      shift
      ;;
    --yes)
      ASSUME_YES=1
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "error: unknown option: $1" >&2
      usage >&2
      exit 1
      ;;
  esac
done

if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  echo "error: not inside a git repository" >&2
  exit 1
fi

if [[ -n "$(git status --porcelain)" ]]; then
  echo "error: working tree is not clean; commit or stash changes first" >&2
  exit 1
fi

if [[ -z "$UPSTREAM_REF" ]]; then
  if ! UPSTREAM_REF="$(git rev-parse --abbrev-ref --symbolic-full-name '@{upstream}' 2>/dev/null)"; then
    echo "error: no upstream configured; pass --upstream <ref>" >&2
    exit 1
  fi
fi

if ! git rev-parse --verify "$UPSTREAM_REF" >/dev/null 2>&1; then
  echo "error: upstream ref not found: $UPSTREAM_REF" >&2
  exit 1
fi

RANGE="${UPSTREAM_REF}..HEAD"
LOCAL_COUNT="$(git rev-list --count "$RANGE")"
if [[ "$LOCAL_COUNT" -eq 0 ]]; then
  echo "No local commits ahead of $UPSTREAM_REF."
  exit 0
fi

MERGE_COUNT="$(git rev-list --count --merges "$RANGE")"
if [[ "$MERGE_COUNT" -gt 0 ]]; then
  echo "error: merge commits detected in $RANGE; handle manually" >&2
  exit 1
fi

mapfile -t UNSIGNED_COMMITS < <(
  while IFS= read -r sha; do
    if [[ "$(git show -s --format=%G? "$sha")" == "N" ]]; then
      echo "$sha"
    fi
  done < <(git rev-list --reverse "$RANGE")
)

if [[ "${#UNSIGNED_COMMITS[@]}" -eq 0 ]]; then
  echo "All local commits in $RANGE are already signed."
  exit 0
fi

echo "Unsigned commits in $RANGE:"
for sha in "${UNSIGNED_COMMITS[@]}"; do
  git show -s --format='  %h %s' "$sha"
done

FIRST_UNSIGNED="${UNSIGNED_COMMITS[0]}"
if ! BASE_COMMIT="$(git rev-parse "${FIRST_UNSIGNED}^" 2>/dev/null)"; then
  echo "error: failed to resolve parent of first unsigned commit: $FIRST_UNSIGNED" >&2
  exit 1
fi

echo
echo "Rebase base commit: $BASE_COMMIT"
echo "Unsigned commit count: ${#UNSIGNED_COMMITS[@]}"

if [[ "$DRY_RUN" -eq 1 ]]; then
  echo
  echo "Dry run only. No history was rewritten."
  exit 0
fi

if [[ "$ASSUME_YES" -ne 1 ]]; then
  read -r -p "Rewrite local history to re-sign these commits? [y/N] " response
  case "$response" in
    y|Y|yes|YES)
      ;;
    *)
      echo "Aborted."
      exit 1
      ;;
  esac
fi

if ! git rebase --exec 'if [ "$(git show -s --format=%G? HEAD)" = "N" ]; then git commit --amend --no-edit -S; fi' "$BASE_COMMIT"; then
  cat <<'EOF' >&2
error: rebase failed.
Resolve conflicts or signing errors, then continue with:
  git rebase --continue
Or abort with:
  git rebase --abort
EOF
  exit 1
fi

REMAINING_UNSIGNED=0
while IFS= read -r sha; do
  if [[ "$(git show -s --format=%G? "$sha")" == "N" ]]; then
    REMAINING_UNSIGNED=$((REMAINING_UNSIGNED + 1))
  fi
done < <(git rev-list --reverse "$RANGE")

if [[ "$REMAINING_UNSIGNED" -gt 0 ]]; then
  echo "error: $REMAINING_UNSIGNED unsigned commit(s) still remain in $RANGE" >&2
  exit 1
fi

echo
echo "Re-sign completed. Local commits now show signature state:"
git log --reverse --format='  %h %G? %s' "$RANGE"
echo
echo "Done. This script does not run git push."
echo "If needed later, run manually:"
echo "  git push --force-with-lease"
