#!/usr/bin/env bash
# Merge public upstream changes into main and push to your private origin.
set -euo pipefail

cd -- "$(dirname -- "${BASH_SOURCE[0]}")"

if [[ -n "$(git status --porcelain)" ]]; then
    echo "Commit or stash your local changes before syncing." >&2
    exit 1
fi

if ! git remote get-url upstream >/dev/null 2>&1; then
    git remote add upstream https://github.com/Niko1221/Strata.git
fi

git switch main
git fetch upstream main
git merge --no-edit upstream/main
git push origin main

echo "Synced upstream/main to main and pushed to origin."
