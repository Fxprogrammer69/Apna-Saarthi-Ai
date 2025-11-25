#!/bin/bash

# Local Testing Script for Apna Saarhi WhatsApp Bot
# This script helps you test locally with ngrok

echo "🚀 Apna Saarhi - Local Testing Setup"
echo "===================================="
echo ""

# Check if .env exists
if [ ! -f .env ]; then
    echo "⚠️  .env file not found!"
    echo ""
    echo "Creating .env file template..."
    cat > .env << 'EOF'
# Twilio Configuration
TWILIO_ACCOUNT_SID=your_account_sid_here
TWILIO_AUTH_TOKEN=your_auth_token_here
TWILIO_WHATSAPP_NUMBER=whatsapp:+14155238886

# Server Configuration
PORT=5001
FLASK_ENV=development
EOF
    echo "✅ Created .env file"
    echo ""
    echo "📝 Please edit .env and add your Twilio credentials:"
    echo "   1. Get Account SID from: https://console.twilio.com/"
    echo "   2. Get Auth Token from: https://console.twilio.com/"
    echo "   3. Join WhatsApp Sandbox: https://console.twilio.com/us1/develop/sms/sandbox"
    echo ""
    read -p "Press Enter after you've updated .env file..."
fi

# Check if ngrok is installed
if ! command -v ngrok &> /dev/null; then
    echo "❌ ngrok not found!"
    echo ""
    echo "📥 Install ngrok:"
    echo "   macOS: brew install ngrok/ngrok/ngrok"
    echo "   Or download: https://ngrok.com/download"
    echo ""
    echo "📝 After installing, sign up at: https://dashboard.ngrok.com/signup"
    echo "   Then run: ngrok config add-authtoken YOUR_TOKEN"
    echo ""
    exit 1
fi

# Check if Flask is running
if lsof -Pi :5001 -sTCP:LISTEN -t >/dev/null ; then
    echo "⚠️  Flask app is already running on port 5001"
    read -p "Continue anyway? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

echo "✅ All checks passed!"
echo ""
echo "📋 Starting services..."
echo ""

# Start Flask app in background
echo "1️⃣  Starting Flask app on port 5001..."
python app.py > flask.log 2>&1 &
FLASK_PID=$!
echo "   Flask PID: $FLASK_PID"
echo "   Logs: tail -f flask.log"
sleep 2

# Start ngrok
echo ""
echo "2️⃣  Starting ngrok tunnel..."
echo "   Please wait for ngrok URL..."
ngrok http 5001 > ngrok.log 2>&1 &
NGROK_PID=$!
echo "   ngrok PID: $NGROK_PID"
sleep 5

# Get ngrok URL
NGROK_URL=$(curl -s http://localhost:4040/api/tunnels | grep -o '"public_url":"https://[^"]*"' | head -1 | cut -d'"' -f4)

if [ -z "$NGROK_URL" ]; then
    echo "   ⚠️  Could not get ngrok URL automatically"
    echo "   Please check ngrok output manually"
else
    echo "   ✅ ngrok URL: $NGROK_URL"
    echo ""
    echo "📝 Configure Twilio webhook:"
    echo "   Webhook URL: $NGROK_URL/whatsapp"
    echo "   Go to: https://console.twilio.com/us1/develop/sms/sandbox"
    echo ""
fi

echo "✅ Setup complete!"
echo ""
echo "📋 What to do next:"
echo "   1. Copy the ngrok URL above"
echo "   2. Go to Twilio Console → WhatsApp Sandbox"
echo "   3. Set webhook URL to: $NGROK_URL/whatsapp"
echo "   4. Send WhatsApp message to sandbox number: +1 415 523 8886"
echo "   5. Test with: 'What is RTI?'"
echo ""
echo "📊 Monitor:"
echo "   - Flask logs: tail -f flask.log"
echo "   - ngrok dashboard: http://localhost:4040"
echo ""
echo "🛑 To stop:"
echo "   kill $FLASK_PID $NGROK_PID"
echo ""
echo "Press Ctrl+C to stop..."

# Wait for interrupt
wait

