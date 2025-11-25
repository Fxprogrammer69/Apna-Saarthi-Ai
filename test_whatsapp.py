#!/usr/bin/env python3
"""
Test script for WhatsApp integration
This script tests the WhatsApp send functionality
"""

import os
import sys
from dotenv import load_dotenv
from twilio.rest import Client

# Load environment variables
load_dotenv()

TWILIO_ACCOUNT_SID = os.getenv('TWILIO_ACCOUNT_SID')
TWILIO_AUTH_TOKEN = os.getenv('TWILIO_AUTH_TOKEN')
TWILIO_WHATSAPP_NUMBER = os.getenv('TWILIO_WHATSAPP_NUMBER', 'whatsapp:+14155238886')

def test_whatsapp_connection():
    """Test Twilio WhatsApp connection"""
    if not TWILIO_ACCOUNT_SID or not TWILIO_AUTH_TOKEN:
        print("❌ Error: TWILIO_ACCOUNT_SID and TWILIO_AUTH_TOKEN must be set in .env file")
        return False
    
    try:
        client = Client(TWILIO_ACCOUNT_SID, TWILIO_AUTH_TOKEN)
        print("✅ Twilio client initialized successfully")
        print(f"📱 WhatsApp Number: {TWILIO_WHATSAPP_NUMBER}")
        return True
    except Exception as e:
        print(f"❌ Error initializing Twilio client: {e}")
        return False

def test_send_message(to_number, message):
    """Test sending a WhatsApp message"""
    if not TWILIO_ACCOUNT_SID or not TWILIO_AUTH_TOKEN:
        print("❌ Error: Twilio credentials not configured")
        return False
    
    try:
        client = Client(TWILIO_ACCOUNT_SID, TWILIO_AUTH_TOKEN)
        message_obj = client.messages.create(
            body=message,
            from_=TWILIO_WHATSAPP_NUMBER,
            to=to_number
        )
        print(f"✅ Message sent successfully!")
        print(f"   Message SID: {message_obj.sid}")
        print(f"   Status: {message_obj.status}")
        return True
    except Exception as e:
        print(f"❌ Error sending message: {e}")
        return False

if __name__ == '__main__':
    print("🧪 Testing WhatsApp Integration\n")
    
    # Test connection
    if not test_whatsapp_connection():
        sys.exit(1)
    
    # Test sending message (if number provided)
    if len(sys.argv) > 1:
        to_number = sys.argv[1]
        message = sys.argv[2] if len(sys.argv) > 2 else "Hello from Apna Saarhi Legal Assistant! 🚀"
        
        print(f"\n📤 Sending test message to {to_number}...")
        test_send_message(to_number, message)
    else:
        print("\n💡 To test sending a message, run:")
        print("   python test_whatsapp.py whatsapp:+1234567890 'Your message here'")
        print("\n⚠️  Note: Make sure the recipient has joined your Twilio WhatsApp sandbox")

