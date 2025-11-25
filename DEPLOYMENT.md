# Quick Deployment Guide

## 🚀 Deploy to Railway (Easiest)

1. **Push your code to GitHub**
   ```bash
   git init
   git add .
   git commit -m "Initial commit"
   git remote add origin <your-github-repo-url>
   git push -u origin main
   ```

2. **Go to Railway.app**
   - Sign up/login at https://railway.app
   - Click "New Project" → "Deploy from GitHub repo"
   - Select your repository

3. **Add Environment Variables** in Railway dashboard:
   - `TWILIO_ACCOUNT_SID` - Your Twilio Account SID
   - `TWILIO_AUTH_TOKEN` - Your Twilio Auth Token
   - `TWILIO_WHATSAPP_NUMBER` - Your WhatsApp number (e.g., `whatsapp:+14155238886`)

4. **Railway will auto-deploy!** Get your public URL from Railway dashboard

5. **Configure Twilio Webhook**:
   - Go to Twilio Console → WhatsApp Sandbox
   - Set webhook URL: `https://your-railway-url.railway.app/whatsapp`

## 🚀 Deploy to Render

1. **Connect GitHub repo** to Render
2. **Create new Web Service**
3. **Set environment variables**:
   - `TWILIO_ACCOUNT_SID`
   - `TWILIO_AUTH_TOKEN`
   - `TWILIO_WHATSAPP_NUMBER`
4. **Set webhook URL** in Twilio: `https://your-app.onrender.com/whatsapp`

## 🚀 Deploy to Heroku

```bash
# Install Heroku CLI first
heroku create apna-saarhi-bot
git push heroku main
heroku config:set TWILIO_ACCOUNT_SID=your_sid
heroku config:set TWILIO_AUTH_TOKEN=your_token
heroku config:set TWILIO_WHATSAPP_NUMBER=whatsapp:+14155238886
```

## 🧪 Local Testing with ngrok

1. **Start your app**:
   ```bash
   python app.py
   ```

2. **In another terminal, start ngrok**:
   ```bash
   ngrok http 5001
   ```

3. **Copy the HTTPS URL** (e.g., `https://abc123.ngrok.io`)

4. **Set Twilio webhook** to: `https://abc123.ngrok.io/whatsapp`

5. **Create `.env` file**:
   ```bash
   TWILIO_ACCOUNT_SID=your_account_sid
   TWILIO_AUTH_TOKEN=your_auth_token
   TWILIO_WHATSAPP_NUMBER=whatsapp:+14155238886
   ```

## 📝 Setup Checklist

- [ ] Get Twilio account and credentials
- [ ] Join WhatsApp Sandbox (for testing)
- [ ] Create `.env` file with credentials (for local)
- [ ] Deploy to Railway/Render/Heroku
- [ ] Set webhook URL in Twilio console
- [ ] Test by sending WhatsApp message
- [ ] Get production WhatsApp number (when ready)

## 🔗 Important URLs

- **Twilio Console**: https://console.twilio.com/
- **WhatsApp Sandbox**: https://console.twilio.com/us1/develop/sms/sandbox
- **Get WhatsApp Number**: https://www.twilio.com/whatsapp

