#!/usr/bin/env bash
set -e

REPO=$(git remote get-url origin | sed 's/.*github.com[:/]\(.*\)\.git/\1/')

echo "Using repo: $REPO"

PRS=$(gh pr list --repo $REPO --limit 100 --json number --jq '.[].number')

COMMENTS=(
"Looks good 👍"
"Clean implementation"
"Consider adding tests"
"Nice structure and readability"
"Minor improvements possible"
)

i=0

for PR in $PRS; do
  comment=${COMMENTS[$((i % ${#COMMENTS[@]}))]}

  echo "Commenting on PR #$PR"

  gh pr review $PR \
    --repo $REPO \
    --comment -b "$comment"

  i=$((i+1))
done

echo "✅ Done commenting on PRs"