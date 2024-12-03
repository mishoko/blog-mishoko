#!/bin/bash
set -e

echo "Starting deployment from branch: $(git branch --show-current)"

# Ensure we're on main branch
if [[ $(git branch --show-current) != "main" ]]; then
    echo "Please switch to main branch first"
    exit 1
fi

# Switch to gh-pages with verification
if git show-ref --verify --quiet refs/heads/gh-pages; then
    echo "Switching to existing gh-pages branch..."
    git checkout gh-pages
else
    echo "Creating new gh-pages branch..."
    git checkout --orphan gh-pages
    git reset --hard
fi

echo "Current branch after switch: $(git branch --show-current)"

# Build Hugo site
hugo --minify

# Delete everything except .git and public
find . -maxdepth 1 ! -name '.git' ! -name 'public' ! -name '.' ! -name '..' -exec rm -rf {} +

# Move all contents from public up one level
mv public/* .

# Remove now-empty public directory
rm -r public

git add .
git commit -m "Deploy: $(date +%Y-%m-%d_%H-%M-%S)"

# Push to gh-pages
git push origin gh-pages

# Switch back to main
git checkout main