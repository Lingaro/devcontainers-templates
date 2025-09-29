#!/usr/bin/env bash

set -euo pipefail

# set template name (subdirectory in the repo)
TEMPLATE=lingaro-samanta

URL=https://github.com/Lingaro-Enterprise-PoC/devcontainers-templates.git
BRANCH=feature/samanta
REMOTE=devcontainers-templates
DEST=.devcontainer
CLEAN=0  # set CLEAN=1, to clear DEST before import

# install VSCode Dev Containers extension if not installed
if CODE="$(command -v code-insiders 2>/dev/null)"; then
  :
elif CODE="$(command -v code 2>/dev/null)"; then
  :
else
  echo "❌ VSCode command line tool (code or code-insiders) not found in PATH"
  exit 1
fi
EXTENSION="ms-vscode-remote.remote-containers"
if ! "$CODE" --list-extensions | grep -qi "^${EXTENSION}$"; then
  "$CODE" --install-extension "$EXTENSION" --force
fi

# add or update devcontainers-templates repo
if git remote get-url "$REMOTE" >/dev/null 2>&1; then
  git remote set-url "$REMOTE" "$URL"
else
  git remote add "$REMOTE" "$URL"
fi

git fetch "$REMOTE" "$BRANCH"

# check if path exists in the given branch
git cat-file -e "$REMOTE/$BRANCH:$TEMPLATE" || {
  echo "❌ No '$TEMPLATE' on $REMOTE/$BRANCH"; exit 1;
}

if [ "$CLEAN" = "1" ]; then
  rm -rf "$DEST"
fi
mkdir -p "$DEST"

# import files
git archive "$REMOTE/$BRANCH:$TEMPLATE" | tar -x -C "$DEST"

echo "✅ Imported: $REMOTE/$BRANCH:$TEMPLATE → $DEST"
