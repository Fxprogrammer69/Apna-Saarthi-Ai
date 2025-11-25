# Apna Saarhi - Legal Assistant

An AI-powered legal assistant that helps users understand legal concepts, rights, and laws in India.

## Features

- 🤖 AI-powered legal question answering
- 📚 Knowledge base of legal topics
- 💬 Interactive chat interface (Web & WhatsApp)
- 📱 WhatsApp chatbot integration
- 🔍 Search through legal information
- 📖 Source citations for responses

## Installation

1. Install dependencies:
```bash
pip install -r requirements.txt
```

2. Run the application:
```bash
python app.py
```

3. Open your browser and navigate to:
```
http://localhost:5001
```

## WhatsApp Deployment

This application can be deployed as a WhatsApp chatbot using Twilio. See [WHATSAPP_SETUP.md](WHATSAPP_SETUP.md) for detailed deployment instructions.

**Quick Setup:**
1. Create a Twilio account and get your credentials
2. Create a `.env` file with your Twilio credentials
3. Deploy your app to a public server (Heroku, Railway, etc.)
4. Configure Twilio webhook to point to `https://your-domain.com/whatsapp`
5. Start chatting on WhatsApp!

## Usage

1. Type your legal question in the input box
2. Press Enter or click Send
3. Get instant responses with relevant legal information
4. View sources and relevant laws for each response

## API Endpoints

### Web Interface
- `GET /` - Main web interface
- `POST /api/chat` - Send a query and get a response
- `GET /api/kb` - Get the knowledge base
- `POST /api/kb` - Add a new topic to the knowledge base

### WhatsApp Integration
- `POST /whatsapp` - Webhook endpoint for incoming WhatsApp messages (Twilio)
- `POST /whatsapp/send` - API to send WhatsApp messages programmatically

## Knowledge Base

The legal knowledge base is stored in `legal_kb.json`. You can:
- Add new topics via the API
- Edit the JSON file directly
- Expand with more legal information

## Example Questions

- "What is RTI?"
- "Tell me about consumer rights"
- "What are my property rights?"
- "Explain employment rights"
- "What is domestic violence law?"

## Technologies

- Flask - Web framework
- Twilio - WhatsApp API integration
- HTML/CSS/JavaScript - Frontend
- JSON - Knowledge base storage

## Environment Variables

Create a `.env` file in the project root:

```env
TWILIO_ACCOUNT_SID=your_account_sid
TWILIO_AUTH_TOKEN=your_auth_token
TWILIO_WHATSAPP_NUMBER=whatsapp:+14155238886
```

See `.env.example` for a template.

