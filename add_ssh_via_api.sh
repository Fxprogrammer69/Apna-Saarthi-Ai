#!/bin/bash

# Script to add SSH key to GitHub via API

SSH_KEY=$(cat ~/.ssh/id_ed25519_github.pub)
KEY_TITLE="Apna Saarthi AI"

echo "🔑 Adding SSH key to GitHub via API..."
echo ""

# Check if GITHUB_TOKEN is set
if [ -z "$GITHUB_TOKEN" ]; then
    echo "⚠️  GITHUB_TOKEN not found in environment"
    echo ""
    echo "📋 To add the key automatically, I need a GitHub Personal Access Token"
    echo ""
    echo "Option 1: Set token and run this script:"
    echo "  export GITHUB_TOKEN=your_token_here"
    echo "  ./add_ssh_via_api.sh"
    echo ""
    echo "Option 2: Get token now:"
    echo "  1. Go to: https://github.com/settings/tokens"
    echo "  2. Generate new token (classic) with 'admin:public_key' scope"
    echo "  3. Copy the token"
    echo "  4. Run: export GITHUB_TOKEN=your_token"
    echo "  5. Run: ./add_ssh_via_api.sh"
    echo ""
    echo "Option 3: Manual add (easiest):"
    echo "  1. Go to: https://github.com/settings/keys"
    echo "  2. Click 'New SSH key'"
    echo "  3. Paste this key:"
    echo ""
    echo "$SSH_KEY"
    echo ""
    exit 1
fi

echo "✅ Using GitHub token to add SSH key..."
echo ""

# Add SSH key via GitHub API
RESPONSE=$(curl -s -X POST \
  -H "Authorization: token $GITHUB_TOKEN" \
  -H "Accept: application/vnd.github.v3+json" \
  https://api.github.com/user/keys \
  -d "{\"title\":\"$KEY_TITLE\",\"key\":\"$SSH_KEY\"}")

# Check if successful
if echo "$RESPONSE" | grep -q "id"; then
    echo "✅ SSH key added successfully!"
    echo ""
    echo "🎉 You can now push to GitHub!"
    echo "Run: git push -u origin main"
else
    echo "❌ Failed to add SSH key"
    echo "Response: $RESPONSE"
    echo ""
    echo "💡 Try manual method: https://github.com/settings/keys"
fi

