#!/usr/bin/env bash
set -e

REPO=$(git remote get-url origin | sed 's/.*github.com[:/]\(.*\)\.git/\1/')

PRS=$(gh pr list --repo $REPO --limit 50 --json number --jq '.[].number')

for PR in $PRS; do
  echo "Merging PR #$PR"

  echo "y" | gh pr merge $PR \
    --repo $REPO \
    --merge \
    --delete-branch

done

echo "✅ All PRs merged"