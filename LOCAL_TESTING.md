# 🧪 Local Testing & Production Number Setup Guide

## Step 1: Set Up Twilio Credentials

### A. Create Twilio Account (if you don't have one)
1. Go to: https://www.twilio.com/try-twilio
2. Sign up for a free account (includes $15.50 credit)
3. Verify your email and phone number

### B. Get Your Credentials
1. Go to: https://console.twilio.com/
2. Find your **Account SID** and **Auth Token** on the dashboard
3. Copy them (you'll need them for the .env file)

### C. Join WhatsApp Sandbox (for testing)
1. Go to: https://console.twilio.com/us1/develop/sms/sandbox
2. You'll see a join code like "join abc-xyz"
3. Send that exact message to the sandbox number: `+1 415 523 8886`
4. You'll get a confirmation message

### D. Create .env File
Create a `.env` file in the project root:

```bash
TWILIO_ACCOUNT_SID=your_account_sid_here
TWILIO_AUTH_TOKEN=your_auth_token_here
TWILIO_WHATSAPP_NUMBER=whatsapp:+14155238886
PORT=5001
FLASK_ENV=development
```

## Step 2: Install ngrok

### macOS:
```bash
brew install ngrok/ngrok/ngrok
# Or download from: https://ngrok.com/download
```

### Linux/Windows:
Download from: https://ngrok.com/download

### Sign up for ngrok (Free)
1. Go to: https://dashboard.ngrok.com/signup
2. Get your auth token
3. Run: `ngrok config add-authtoken YOUR_TOKEN`

## Step 3: Test Locally with ngrok

### Terminal 1: Start Flask App
```bash
python app.py
```
You should see: `Running on http://0.0.0.0:5001`

### Terminal 2: Start ngrok
```bash
ngrok http 5001
```
You'll get output like:
```
Forwarding   https://abc123.ngrok.io -> http://localhost:5001
```
Copy the HTTPS URL (e.g., `https://abc123.ngrok.io`)

### Terminal 3: Test Connection
```bash
# Test if your app is accessible
curl https://abc123.ngrok.io

# Test WhatsApp webhook endpoint
curl -X POST https://abc123.ngrok.io/whatsapp \
  -d "Body=What is RTI?" \
  -d "From=whatsapp:+1234567890"
```

## Step 4: Configure Twilio Webhook

1. **Go to Twilio Console**: https://console.twilio.com/
2. **Navigate to**: Messaging → Settings → WhatsApp Sandbox
3. **Set Webhook URL**: 
   - When a message comes in: `https://abc123.ngrok.io/whatsapp`
   - (Use your actual ngrok URL)
4. **HTTP Method**: POST
5. **Save**

⚠️ **Note**: ngrok free URLs change every time you restart ngrok. For production, use a permanent domain.

## Step 5: Test WhatsApp Bot

1. Open WhatsApp on your phone
2. Send a message to the sandbox number: `+1 415 523 8886`
3. Ask: "What is RTI?"
4. You should receive a response from your bot!

## Step 6: Get Production WhatsApp Number

### Option A: Request WhatsApp Number from Twilio (Recommended)

1. **Go to Twilio Console**: https://console.twilio.com/
2. **Navigate to**: Messaging → Try it out → Send a WhatsApp message
3. **Click**: "Request a WhatsApp Number"
4. **Fill out the form**:
   - Business Name
   - Business Description
   - Business Website
   - Use Case
   - Business Address
   - Phone Number
5. **Submit** and wait for approval (usually 24-48 hours)

### Option B: Use Existing Twilio Phone Number

1. **Go to**: Phone Numbers → Manage → Buy a number
2. **Buy a number** in your desired country
3. **Go to**: Messaging → Senders → WhatsApp
4. **Click**: "Add a Sender"
5. **Enter your phone number** and complete verification
6. **Set webhook URL**: `https://your-domain.com/whatsapp`

### Requirements for Production Number:

- ✅ Verified Twilio account
- ✅ Business verification (may be required)
- ✅ Business address and contact information
- ✅ Approved use case
- ✅ Public webhook URL (HTTPS required)

## Step 7: Update Production Configuration

Once you have a production number:

1. **Update `.env`**:
```bash
TWILIO_WHATSAPP_NUMBER=whatsapp:+12345678900  # Your production number
```

2. **Update Twilio webhook** to point to your production URL:
   - Go to: Messaging → Senders → WhatsApp → Your Number
   - Set webhook: `https://your-production-domain.com/whatsapp`

3. **Test** with the production number

## Testing Commands

```bash
# Test Twilio connection
python test_whatsapp.py

# Test sending message
python test_whatsapp.py whatsapp:+1234567890 "Test message"

# Test webhook locally
curl -X POST http://localhost:5001/whatsapp \
  -d "Body=What is consumer rights?" \
  -d "From=whatsapp:+1234567890"

# Test through ngrok
curl -X POST https://abc123.ngrok.io/whatsapp \
  -d "Body=What is RTI?" \
  -d "From=whatsapp:+1234567890"
```

## Troubleshooting

### Bot not responding?
- ✅ Check Flask app is running
- ✅ Check ngrok is running and URL is correct
- ✅ Verify webhook URL in Twilio console
- ✅ Check `.env` file has correct credentials
- ✅ Look at Flask app logs for errors

### Getting "Twilio not configured"?
- ✅ Make sure `.env` file exists in project root
- ✅ Verify environment variables are correct
- ✅ Restart Flask app after changing `.env`

### Webhook not receiving messages?
- ✅ Ensure ngrok URL uses HTTPS (not HTTP)
- ✅ Check webhook URL is exactly: `https://your-url.ngrok.io/whatsapp`
- ✅ Verify Flask app `/whatsapp` endpoint is working
- ✅ Check ngrok web interface: http://localhost:4040

### ngrok URL keeps changing?
- ✅ Free tier: URLs change on restart (use for testing)
- ✅ Paid tier: Get static domain (for production)
- ✅ Or deploy to Railway/Render for permanent URL

## Next Steps After Testing

1. **Deploy to Production**:
   - Deploy to Railway/Render/Heroku
   - Get permanent HTTPS URL
   - Update Twilio webhook

2. **Get Production Number**:
   - Complete Twilio business verification
   - Request production WhatsApp number
   - Update configuration

3. **Monitor & Scale**:
   - Set up logging
   - Add error handling
   - Implement rate limiting
   - Monitor message costs

