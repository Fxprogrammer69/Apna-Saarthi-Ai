#!/bin/bash

# Automated push script using Personal Access Token

echo "🚀 Automated GitHub Push"
echo "========================="
echo ""

# Check if token is provided
if [ -z "$1" ]; then
    echo "📋 To push automatically, I need your GitHub Personal Access Token"
    echo ""
    echo "🔗 Get your token:"
    echo "   1. Go to: https://github.com/settings/tokens"
    echo "   2. Generate new token (classic)"
    echo "   3. Select 'repo' scope"
    echo "   4. Copy the token"
    echo ""
    echo "💡 Then run:"
    echo "   ./push_with_token.sh YOUR_TOKEN"
    echo ""
    echo "OR set it as environment variable:"
    echo "   export GITHUB_TOKEN=your_token"
    echo "   ./push_with_token.sh"
    echo ""
    exit 1
fi

TOKEN=${1:-$GITHUB_TOKEN}
USERNAME="Fxprogrammer69"
REPO_URL="https://github.com/Fxprogrammer69/Apna-Saarthi-Ai.git"

echo "✅ Using token to authenticate..."
echo ""

# Configure git credential helper
git config credential.helper store

# Push using token in URL (temporary)
git remote set-url origin "https://${USERNAME}:${TOKEN}@github.com/Fxprogrammer69/Apna-Saarthi-Ai.git"

echo "📤 Pushing to GitHub..."
echo ""

if git push -u origin main 2>&1; then
    echo ""
    echo "✅ Successfully pushed to GitHub!"
    echo ""
    echo "🔗 Your code is now at:"
    echo "   https://github.com/Fxprogrammer69/Apna-Saarthi-Ai"
    echo ""
    # Remove token from URL for security
    git remote set-url origin "https://github.com/Fxprogrammer69/Apna-Saarthi-Ai.git"
else
    echo ""
    echo "❌ Push failed. Please check your token."
    # Remove token from URL for security
    git remote set-url origin "https://github.com/Fxprogrammer69/Apna-Saarthi-Ai.git"
    exit 1
fi

