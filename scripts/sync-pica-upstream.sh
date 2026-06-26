#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
UPSTREAM_REMOTE="upstream"
UPSTREAM_URL="https://github.com/earendil-works/pi.git"
BRANCH="${PICA_SYNC_BRANCH:-main}"

cd "$REPO_ROOT"

if [[ -n "$(git status --porcelain)" ]]; then
  echo "error: worktree is dirty; commit or remove local changes before syncing" >&2
  exit 1
fi

current_branch="$(git branch --show-current)"
if [[ "$current_branch" != "$BRANCH" ]]; then
  echo "error: sync must run from $BRANCH; current branch is $current_branch" >&2
  exit 1
fi

if ! git remote get-url "$UPSTREAM_REMOTE" >/dev/null 2>&1; then
  git remote add "$UPSTREAM_REMOTE" "$UPSTREAM_URL"
fi

git fetch origin "$BRANCH"
git fetch "$UPSTREAM_REMOTE" "$BRANCH"

local_head="$(git rev-parse "$BRANCH")"
origin_head="$(git rev-parse "origin/$BRANCH")"
if [[ "$local_head" != "$origin_head" ]]; then
  echo "error: local $BRANCH does not match origin/$BRANCH" >&2
  echo "Pull or push local changes before syncing with upstream." >&2
  exit 1
fi

git merge --no-edit "$UPSTREAM_REMOTE/$BRANCH"
git push origin "$BRANCH"
