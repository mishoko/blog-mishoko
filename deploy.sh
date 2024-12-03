#!/bin/bash

# Ensure we're on main branch
if [[ $(git branch --show-current) != "main" ]]; then
    echo "Please switch to main branch first"
    exit 1
fi

# Build the Hugo site
hugo --minify

# Create and switch to gh-pages branch
git checkout gh-pages 2>/dev/null || git checkout -b gh-pages

# Remove existing content (except .git)
#find . -maxdepth 1 ! -name '.git' ! -name '.' ! -name '..' -exec rm -rf {} +

# Copy contents from public folder
cp -r public/* .

# Add all changes
git add .

# Commit
git commit -m "Deploy: $(date +%Y-%m-%d_%H-%M-%S)"

# Push to remote
git push origin gh-pages

# Switch back to original branch
git checkout -