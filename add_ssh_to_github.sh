#!/bin/bash

# Script to add SSH key to GitHub

echo "🔑 SSH Key Generated!"
echo ""
echo "📋 Your public SSH key:"
echo "=================================="
cat ~/.ssh/id_ed25519_github.pub
echo "=================================="
echo ""

# Configure SSH for GitHub
echo "⚙️  Configuring SSH for GitHub..."

# Add SSH config if it doesn't exist
if [ ! -f ~/.ssh/config ]; then
    touch ~/.ssh/config
    chmod 600 ~/.ssh/config
fi

# Add GitHub configuration to SSH config
if ! grep -q "github.com" ~/.ssh/config; then
    cat >> ~/.ssh/config << 'EOF'
Host github.com
    HostName github.com
    User git
    IdentityFile ~/.ssh/id_ed25519_github
    IdentitiesOnly yes
EOF
    echo "✅ SSH config updated"
fi

echo ""
echo "📝 Next Steps:"
echo "1. Copy the SSH key above"
echo "2. Go to: https://github.com/settings/keys"
echo "3. Click 'New SSH key'"
echo "4. Paste the key and save"
echo ""
echo "Or I can try to open it for you..."
echo ""

# Try to open the browser
if command -v open &> /dev/null; then
    read -p "Open GitHub SSH keys page? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        open "https://github.com/settings/keys"
        echo "✅ Browser opened! Add the SSH key shown above."
    fi
fi

echo ""
echo "🔗 Direct link: https://github.com/settings/keys"
echo ""
echo "After adding the key, run:"
echo "  git push -u origin main"

