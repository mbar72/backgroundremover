#!/bin/bash

REPO="mbar72/backgroundremover.git"

# pick today's issue based on day index
INDEX=$(($(date +%j) % 10 + 1))
TITLE=$(sed -n "${INDEX}p" issues.txt)

echo "Creating issue: $TITLE"

# create issue
ISSUE_URL=$(gh issue create \
  --repo $REPO \
  --title "$TITLE" \
  --body "Daily progress: $TITLE")

ISSUE_NUMBER=$(echo $ISSUE_URL | grep -oE '[0-9]+$')

BRANCH="feature/issue-$ISSUE_NUMBER"

echo "Creating branch: $BRANCH"

git checkout -b $BRANCH

# create starter file
FILE="progress_$ISSUE_NUMBER.txt"
echo "Working on: $TITLE" > $FILE

git add .
git commit -m "$TITLE (#$ISSUE_NUMBER)"

git push -u origin $BRANCH

echo "Creating PR..."

gh pr create \
  --repo $REPO \
  --title "$TITLE" \
  --body "Fixes #$ISSUE_NUMBER" \
  --base main \
  --head $BRANCH

echo "Done. Now review + merge manually."