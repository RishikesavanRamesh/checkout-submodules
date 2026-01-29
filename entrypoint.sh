#!/bin/sh -l

# $1 should be your PAT (passed from the workflow)
PAT_TOKEN="$1"

# Check if PAT is provided
if [ -n "$PAT_TOKEN" ]; then
    echo "✅ PAT detected. Configuring Git for private submodule access..."
    
    # Force Git to use the PAT for any github.com URL (HTTPS)
    git config --global url."https://x-access-token:${PAT_TOKEN}@github.com/".insteadOf "https://github.com/"
    
    # Automatically convert SSH submodule URLs to HTTPS with token
    git config --global url."https://x-access-token:${PAT_TOKEN}@github.com/".insteadOf "git@github.com:"
    
    echo "Authentication headers configured."
else
    echo "⚠️ No PAT detected. Proceeding with public-only checkout..."
    # We explicitly unset any previous 'insteadOf' to ensure a clean state 
    # if this runner was used for a private build previously.
    git config --global --unset-all url."https://x-access-token:".insteadOf || true
fi

# Initialize and update submodules recursively
echo "Running: git submodule update --init --recursive"
git submodule update --init --recursive

# Capture the exit code to give a helpful message
RESULT=$?

if [ $RESULT -eq 0 ]; then
    echo "🚀 Submodules updated successfully!"
else
    if [ -z "$PAT_TOKEN" ]; then
        echo "❌ Submodule update failed. One or more submodules might be private."
        echo "   Please provide a PAT_TOKEN to access private repositories."
    else
        echo "❌ Submodule update failed even with a PAT."
        echo "   Check if the token has 'repo' scope and SSO is authorized for the Org."
    fi
    exit $RESULT
fi