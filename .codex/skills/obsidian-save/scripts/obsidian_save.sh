#!/usr/bin/env bash

set -euo pipefail

commit_message="notes: sync"

if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  echo "Not a git repository." >&2
  exit 1
fi

current_branch="$(git branch --show-current)"
if [[ -z "${current_branch}" ]]; then
  echo "Unable to determine the current branch." >&2
  exit 1
fi

if [[ -z "$(git status --short)" ]]; then
  echo "No changes to commit."
  exit 0
fi

git add -A
git commit -m "${commit_message}"
git push origin "${current_branch}"
