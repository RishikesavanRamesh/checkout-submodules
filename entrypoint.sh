#!/bin/sh -l

# $1 should be your PAT
PAT_TOKEN="$1"

# --- DYNAMIC SAFE DIRECTORY ---
# Get the absolute path of the current workspace
CURRENT_DIR=$(pwd)
echo "Detecting workspace: $CURRENT_DIR"

# Mark the current directory as safe so Git doesn't complain about ownership
git config --global --add safe.directory "$CURRENT_DIR"
# ------------------------------

if [ -n "$PAT_TOKEN" ]; then
    echo "✅ PAT detected. Configuring Git for private submodule access..."
    
    # Use global config to handle nested submodules automatically
    git config --global url."https://x-access-token:${PAT_TOKEN}@github.com/".insteadOf "https://github.com/"
    git config --global url."https://x-access-token:${PAT_TOKEN}@github.com/".insteadOf "git@github.com:"
else
    echo "⚠️ No PAT detected. Public-only mode."
fi

# --init: initialize uninitialized submodules
# --recursive: find submodules within submodules
# --checkout: ensures the files are actually pulled into the folders
echo "Running: git submodule update --init --recursive"
git submodule update --init --recursive

RESULT=$?

if [ $RESULT -eq 0 ]; then
    echo "🚀 Submodules updated successfully!"
else
    echo "❌ Submodule update failed."
    exit $RESULT
fi
