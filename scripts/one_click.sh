#!/bin/bash
set -euo pipefail

# Always move to repo root (parent of scripts/)
REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$REPO_ROOT"

# Safety check
if [ ! -d ".git" ]; then
    echo "Error: .git not found in repo root."
    exit 1
fi


# Paths
sourcePath="/home/rom/Downloads/K/Posts/"
destinationPath="/home/rom/git/rom_archrive/content/posts"

# GitHub Repo
myrepo="git@github.com:rom-9611/rom_archrive.git"

# Check required commands
for cmd in git rsync python3 hugo; do
    if ! command -v $cmd &> /dev/null; then
        echo "$cmd is not installed."
        exit 1
    fi
done

# Ensure git remote exists
if [ ! -d ".git" ]; then
    echo "Error: not inside the main git repository."
    exit 1
fi


# Sync posts
echo "Syncing posts..."
rsync -av --delete "$sourcePath/" "$destinationPath/"

# Process images
echo "Processing images..."
python3 /home/rom/git/rom_archrive/scripts/image.py

# Git add/commit
if ! git diff --quiet || ! git diff --cached --quiet; then
    git add .
    git commit -m "Update site $(date +'%Y-%m-%d %H:%M:%S')"
    git push origin main
else
    echo "No changes to commit."
fi

echo "Done 🚀"

