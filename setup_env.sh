#!/bin/bash

# Quick setup script for WhatsApp chatbot

echo "🚀 Setting up Apna Saarhi WhatsApp Bot..."
echo ""

# Check if .env exists
if [ -f .env ]; then
    echo "⚠️  .env file already exists. Skipping..."
else
    echo "📝 Creating .env file..."
    cat > .env << EOF
# Twilio WhatsApp Configuration
TWILIO_ACCOUNT_SID=your_account_sid_here
TWILIO_AUTH_TOKEN=your_auth_token_here
TWILIO_WHATSAPP_NUMBER=whatsapp:+14155238886
EOF
    echo "✅ Created .env file. Please edit it with your Twilio credentials."
fi

# Install dependencies
echo ""
echo "📦 Installing dependencies..."
pip install -r requirements.txt

echo ""
echo "✅ Setup complete!"
echo ""
echo "📋 Next steps:"
echo "1. Edit .env file with your Twilio credentials"
echo "2. Get credentials from: https://console.twilio.com/"
echo "3. Join WhatsApp Sandbox: https://console.twilio.com/us1/develop/sms/sandbox"
echo "4. Run: python app.py"
echo "5. For local testing, use ngrok: ngrok http 5001"
echo "6. Set webhook in Twilio to: https://your-ngrok-url.ngrok.io/whatsapp"
echo ""
echo "📖 See DEPLOYMENT.md for full deployment guide"

