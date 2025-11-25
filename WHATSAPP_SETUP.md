# WhatsApp Deployment Guide

This guide will help you deploy your Apna Saarhi Legal Assistant as a WhatsApp chatbot using Twilio.

## Prerequisites

1. A Twilio account (sign up at https://www.twilio.com/try-twilio)
2. A server with a public URL (for webhooks) - you can use:
   - Heroku
   - Railway
   - Render
   - AWS/GCP/Azure
   - ngrok (for local testing)

## Step 1: Set Up Twilio Account

1. **Create a Twilio Account**
   - Go to https://www.twilio.com/try-twilio
   - Sign up for a free account (includes $15.50 credit)

2. **Get Your Twilio Credentials**
   - Go to Twilio Console: https://console.twilio.com/
   - Find your **Account SID** and **Auth Token** on the dashboard
   - Save these for later

3. **Enable WhatsApp Sandbox (for testing)**
   - Go to: https://console.twilio.com/us1/develop/sms/sandbox
   - Follow instructions to join the sandbox
   - You'll get a number like: `whatsapp:+14155238886`
   - Send the join code to this number from your WhatsApp

## Step 2: Configure Environment Variables

1. **Create a `.env` file** in your project root:
```bash
TWILIO_ACCOUNT_SID=your_account_sid_here
TWILIO_AUTH_TOKEN=your_auth_token_here
TWILIO_WHATSAPP_NUMBER=whatsapp:+14155238886
```

2. **For Production**, get your own WhatsApp number:
   - Go to: https://www.twilio.com/whatsapp
   - Request a WhatsApp-enabled number
   - Update `TWILIO_WHATSAPP_NUMBER` in your `.env`

## Step 3: Deploy Your Application

### Option A: Using ngrok (Local Testing)

1. **Install ngrok**: https://ngrok.com/download

2. **Start your Flask app**:
```bash
python app.py
```

3. **In another terminal, start ngrok**:
```bash
ngrok http 5001
```

4. **Copy the HTTPS URL** (e.g., `https://abc123.ngrok.io`)

### Option B: Deploy to Heroku

1. **Install Heroku CLI**: https://devcenter.heroku.com/articles/heroku-cli

2. **Create a Procfile**:
```
web: python app.py
```

3. **Deploy**:
```bash
heroku create apna-saarhi-bot
git push heroku main
heroku config:set TWILIO_ACCOUNT_SID=your_sid
heroku config:set TWILIO_AUTH_TOKEN=your_token
heroku config:set TWILIO_WHATSAPP_NUMBER=whatsapp:+14155238886
```

### Option C: Deploy to Railway

1. **Connect your GitHub repo** to Railway
2. **Add environment variables** in Railway dashboard
3. **Deploy automatically**

## Step 4: Configure Twilio Webhook

1. **Go to Twilio Console** → Messaging → Settings → WhatsApp Sandbox Settings
   (or WhatsApp → Senders → Your Number for production)

2. **Set Webhook URL**:
   - When a message comes in: `https://your-domain.com/whatsapp`
   - Use HTTPS (required by Twilio)

3. **Save the configuration**

## Step 5: Test Your Bot

1. **Send a WhatsApp message** to your Twilio number
2. **Ask a legal question** like "What is RTI?"
3. **You should receive a response** from your bot!

## API Endpoints

- `POST /whatsapp` - Webhook endpoint for incoming WhatsApp messages (used by Twilio)
- `POST /whatsapp/send` - API to send WhatsApp messages programmatically
  ```json
  {
    "to": "whatsapp:+1234567890",
    "message": "Your message here"
  }
  ```

## Production Checklist

- [ ] Get a production WhatsApp number from Twilio
- [ ] Set up proper error handling and logging
- [ ] Configure rate limiting
- [ ] Set up monitoring/analytics
- [ ] Add user session management (if needed)
- [ ] Implement message queuing for high volume
- [ ] Set up database for conversation history (optional)

## Troubleshooting

### Bot not responding?
- Check Twilio webhook URL is correct and accessible
- Verify environment variables are set correctly
- Check Twilio console for error logs
- Ensure your server is running and accessible

### Getting "Twilio not configured" error?
- Make sure `.env` file exists with correct credentials
- Verify environment variables are loaded (check server logs)

### Messages not being received?
- Verify webhook URL in Twilio console
- Check that your server is publicly accessible
- Ensure HTTPS is used (Twilio requires HTTPS)

## Cost Considerations

- **Twilio WhatsApp Pricing**: ~$0.005 per message (varies by country)
- **Free Tier**: $15.50 credit for new accounts
- **Sandbox**: Free for testing (limited to verified numbers)

## Alternative: WhatsApp Cloud API (Meta)

For production at scale, consider Meta's WhatsApp Cloud API:
- Direct integration with Meta
- Lower costs for high volume
- More features and customization
- Requires Meta Business verification

## Support

For issues:
- Twilio Support: https://support.twilio.com/
- Flask Documentation: https://flask.palletsprojects.com/
- Project README: See README.md

