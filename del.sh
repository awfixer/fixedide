#!/bin/bash
REPO="{owner}/{repo}"  # Replace with your repo, e.g., octocat/hello-world
DEFAULT_BRANCH=$(gh api repos/"$REPO" --jq '.default_branch')

# Step 1: Clone and reset local repository
git clone https://github.com/"$REPO".git
cd "$(basename "$REPO")"
rm -rf .git
git init
git add . || true  # Add files, ignore if none
git commit -m "Initial commit" || git commit --allow-empty -m "Initial commit"
git remote add origin https://github.com/"$REPO".git
git push --force origin "$DEFAULT_BRANCH"

# Step 2: Delete all releases
gh release list --repo "$REPO" --jq '.[] | .tag_name' | while read -r tag; do
    gh release delete "$tag" --repo "$REPO" --yes
    echo "Deleted release: $tag"
done

# Step 3: Delete all tags
gh api repos/"$REPO"/tags --jq '.[].name' | while read -r tag; do
    gh api -X DELETE repos/"$REPO"/git/refs/tags/"$tag"
    echo "Deleted tag: $tag"
done

# Step 4: Delete all non-default branches
gh api repos/"$REPO"/branches --jq '.[].name' | grep -v "$DEFAULT_BRANCH" | while read -r branch; do
    gh api -X DELETE repos/"$REPO"/git/refs/heads/"$branch"
    echo "Deleted branch: $branch"
done

echo "Commit history, tags, releases, and non-default branches deleted."
