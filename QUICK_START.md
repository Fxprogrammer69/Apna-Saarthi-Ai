# ⚡ Quick Start Guide - Test Locally & Get Production Number

## 🎯 Your Goals:
1. ✅ Test locally with ngrok
2. ✅ Deploy locally (with ngrok)
3. ✅ Get production WhatsApp number

---

## 📋 Step-by-Step Instructions

### Step 1: Set Up Twilio Account & Get Credentials

1. **Create/Login to Twilio**: https://www.twilio.com/try-twilio
   - Free account includes $15.50 credit

2. **Get Your Credentials**: https://console.twilio.com/
   - Copy **Account SID**
   - Copy **Auth Token**

3. **Join WhatsApp Sandbox**: https://console.twilio.com/us1/develop/sms/sandbox
   - Send join code to: `+1 415 523 8886`
   - Example: If code is "join abc-xyz", send "join abc-xyz"

4. **Update .env File**:
   ```bash
   TWILIO_ACCOUNT_SID=ACxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
   TWILIO_AUTH_TOKEN=your_auth_token_here
   TWILIO_WHATSAPP_NUMBER=whatsapp:+14155238886
   PORT=5001
   FLASK_ENV=development
   ```

### Step 2: Install ngrok

**macOS**:
```bash
brew install ngrok/ngrok/ngrok
```

**Or download**: https://ngrok.com/download

**Sign up & Auth**:
1. Go to: https://dashboard.ngrok.com/signup
2. Get your auth token
3. Run: `ngrok config add-authtoken YOUR_TOKEN`

### Step 3: Test Locally (Easy Way)

**Option A: Use the automated script**
```bash
./start_local_test.sh
```

**Option B: Manual setup**

Terminal 1 - Start Flask:
```bash
python app.py
```

Terminal 2 - Start ngrok:
```bash
ngrok http 5001
```

You'll get output like:
```
Forwarding   https://abc123.ngrok.io -> http://localhost:5001
```

**Copy the HTTPS URL** (e.g., `https://abc123.ngrok.io`)

### Step 4: Configure Twilio Webhook

1. **Go to**: https://console.twilio.com/us1/develop/sms/sandbox
2. **Set Webhook URL**: 
   - When a message comes in: `https://abc123.ngrok.io/whatsapp`
   - (Use YOUR ngrok URL)
3. **HTTP Method**: POST
4. **Save**

### Step 5: Test WhatsApp Bot

1. Open **WhatsApp** on your phone
2. Send message to: `+1 415 523 8886`
3. Try: "What is RTI?"
4. **You should get a response!** 🎉

---

## 📱 Step 6: Get Production WhatsApp Number

### Quick Method:

1. **Go to**: https://console.twilio.com/
2. **Navigate**: Messaging → Try it out → Send a WhatsApp message
3. **Click**: "Request a WhatsApp Number"
4. **Fill Form**:
   - Business Name
   - Business Description
   - Website (if you have one)
   - Use Case: "Legal assistant chatbot"
   - Business Address
   - Contact Phone & Email
5. **Submit** → Wait 24-48 hours for approval

### Alternative: Support Ticket

1. Go to: https://support.twilio.com/
2. Submit ticket requesting WhatsApp Business API
3. Provide business details
4. Wait for approval

### After Approval:

1. Get your number from: Messaging → Senders → WhatsApp
2. Update `.env`:
   ```bash
   TWILIO_WHATSAPP_NUMBER=whatsapp:+12345678900
   ```
3. Update webhook URL in Twilio console
4. Test with production number

---

## 🧪 Testing Commands

```bash
# Test Twilio connection
python test_whatsapp.py

# Test sending message (replace with your number)
python test_whatsapp.py whatsapp:+1234567890 "Test message"

# Test webhook locally
curl -X POST http://localhost:5001/whatsapp \
  -d "Body=What is consumer rights?" \
  -d "From=whatsapp:+1234567890"

# Check ngrok dashboard
open http://localhost:4040
```

---

## 🔍 Troubleshooting

### "Twilio not configured"?
- ✅ Check `.env` file exists and has correct values
- ✅ Restart Flask app after changing `.env`

### Bot not responding?
- ✅ Flask running on port 5001?
- ✅ ngrok running and showing HTTPS URL?
- ✅ Webhook URL set correctly in Twilio?
- ✅ Check Flask logs for errors

### Can't get ngrok URL?
- ✅ Check ngrok is installed: `which ngrok`
- ✅ Check auth token: `ngrok config check`
- ✅ Visit ngrok dashboard: http://localhost:4040

---

## 📚 Detailed Guides

- **Full Testing Guide**: See `LOCAL_TESTING.md`
- **Production Number**: See `get_production_number.md`
- **Deployment**: See `DEPLOYMENT.md`
- **WhatsApp Setup**: See `WHATSAPP_SETUP.md`

---

## ✅ Checklist

- [ ] Twilio account created
- [ ] Credentials added to `.env`
- [ ] Joined WhatsApp Sandbox
- [ ] ngrok installed and authenticated
- [ ] Flask app running
- [ ] ngrok tunnel running
- [ ] Webhook configured in Twilio
- [ ] Test message sent and received
- [ ] Production number requested (if needed)

---

## 🎉 You're Done!

Once everything is working:
1. Test thoroughly with sandbox
2. Request production number
3. Deploy to production server (Railway/Render/Heroku)
4. Update webhook to production URL
5. Launch! 🚀

**Need help?** Check the detailed guides or Twilio support!

