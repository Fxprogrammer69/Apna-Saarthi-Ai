from flask import Flask, render_template, request, jsonify
import json
import os
from datetime import datetime
from twilio.twiml.messaging_response import MessagingResponse
from twilio.rest import Client
from dotenv import load_dotenv

# Load environment variables from .env file
load_dotenv()

app = Flask(__name__)

# Load environment variables
TWILIO_ACCOUNT_SID = os.getenv('TWILIO_ACCOUNT_SID', '')
TWILIO_AUTH_TOKEN = os.getenv('TWILIO_AUTH_TOKEN', '')
TWILIO_WHATSAPP_NUMBER = os.getenv('TWILIO_WHATSAPP_NUMBER', 'whatsapp:+14155238886')  # Twilio Sandbox number

# Initialize Twilio client if credentials are provided
twilio_client = None
if TWILIO_ACCOUNT_SID and TWILIO_AUTH_TOKEN:
    twilio_client = Client(TWILIO_ACCOUNT_SID, TWILIO_AUTH_TOKEN)

# Load legal knowledge base
def load_knowledge_base():
    kb_path = 'legal_kb.json'
    if os.path.exists(kb_path):
        with open(kb_path, 'r', encoding='utf-8') as f:
            return json.load(f)
    return {"topics": []}

# Save knowledge base
def save_knowledge_base(kb):
    with open('legal_kb.json', 'w', encoding='utf-8') as f:
        json.dump(kb, f, indent=2, ensure_ascii=False)

# Search function
def search_legal_info(query, kb):
    query_lower = query.lower()
    results = []
    
    for topic in kb.get("topics", []):
        title = topic.get("title", "").lower()
        description = topic.get("description", "").lower()
        keywords = [k.lower() for k in topic.get("keywords", [])]
        
        # Check if query matches title, description, or keywords
        if (query_lower in title or 
            query_lower in description or 
            any(query_lower in kw for kw in keywords)):
            results.append(topic)
    
    return results

# Generate response
def generate_response(query, kb):
    results = search_legal_info(query, kb)
    
    if not results:
        return {
            "response": "I couldn't find specific information about that topic in my knowledge base. Could you please rephrase your question or ask about a different legal topic?",
            "sources": []
        }
    
    # Build response from top results
    response_parts = []
    sources = []
    
    for i, result in enumerate(results[:3], 1):  # Top 3 results
        title = result.get("title", "Unknown Topic")
        description = result.get("description", "")
        relevant_laws = result.get("relevant_laws", [])
        examples = result.get("examples", [])
        
        response_parts.append(f"**{title}**\n{description}")
        
        if relevant_laws:
            response_parts.append(f"\nRelevant Laws: {', '.join(relevant_laws)}")
        
        if examples:
            response_parts.append(f"\nExample: {examples[0]}")
        
        sources.append({
            "title": title,
            "description": description,
            "relevant_laws": relevant_laws
        })
    
    response = "\n\n".join(response_parts)
    
    return {
        "response": response,
        "sources": sources
    }

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/api/chat', methods=['POST'])
def chat():
    data = request.json
    query = data.get('query', '').strip()
    
    if not query:
        return jsonify({"error": "Query is required"}), 400
    
    kb = load_knowledge_base()
    result = generate_response(query, kb)
    
    return jsonify({
        "response": result["response"],
        "sources": result["sources"],
        "timestamp": datetime.now().isoformat()
    })

@app.route('/api/kb', methods=['GET'])
def get_knowledge_base():
    kb = load_knowledge_base()
    return jsonify(kb)

@app.route('/api/kb', methods=['POST'])
def add_to_knowledge_base():
    data = request.json
    kb = load_knowledge_base()
    
    new_topic = {
        "title": data.get("title", ""),
        "description": data.get("description", ""),
        "keywords": data.get("keywords", []),
        "relevant_laws": data.get("relevant_laws", []),
        "examples": data.get("examples", [])
    }
    
    if "topics" not in kb:
        kb["topics"] = []
    
    kb["topics"].append(new_topic)
    save_knowledge_base(kb)
    
    return jsonify({"message": "Topic added successfully", "topic": new_topic})

# WhatsApp webhook endpoint
@app.route('/whatsapp', methods=['POST'])
def whatsapp_webhook():
    """Handle incoming WhatsApp messages via Twilio"""
    incoming_message = request.form.get('Body', '').strip()
    from_number = request.form.get('From', '')
    
    if not incoming_message:
        resp = MessagingResponse()
        resp.message("Please send a valid message.")
        return str(resp)
    
    # Get response from knowledge base
    kb = load_knowledge_base()
    result = generate_response(incoming_message, kb)
    
    # Format response for WhatsApp (remove markdown, limit length)
    response_text = result["response"]
    # Remove markdown formatting for WhatsApp
    response_text = response_text.replace('**', '').replace('*', '')
    
    # Add sources if available
    if result["sources"]:
        response_text += "\n\n📚 Sources:"
        for source in result["sources"][:2]:  # Limit to 2 sources for WhatsApp
            response_text += f"\n• {source['title']}"
            if source.get('relevant_laws'):
                response_text += f"\n  Laws: {', '.join(source['relevant_laws'][:2])}"
    
    # WhatsApp messages have a 1600 character limit, so truncate if needed
    if len(response_text) > 1500:
        response_text = response_text[:1500] + "...\n\n(Message truncated. Please ask a more specific question.)"
    
    # Create Twilio response
    resp = MessagingResponse()
    resp.message(response_text)
    
    return str(resp)

# Send WhatsApp message (for testing or proactive messages)
def send_whatsapp_message(to_number, message_text):
    """Send a WhatsApp message using Twilio"""
    if not twilio_client:
        return {"error": "Twilio not configured"}
    
    try:
        twilio_message = twilio_client.messages.create(
            body=message_text,
            from_=TWILIO_WHATSAPP_NUMBER,
            to=to_number
        )
        return {"success": True, "message_sid": twilio_message.sid}
    except Exception as e:
        return {"error": str(e)}

@app.route('/whatsapp/send', methods=['POST'])
def send_whatsapp():
    """API endpoint to send WhatsApp messages"""
    if not twilio_client:
        return jsonify({"error": "Twilio not configured. Please set TWILIO_ACCOUNT_SID and TWILIO_AUTH_TOKEN"}), 400
    
    data = request.json
    to_number = data.get('to')
    message = data.get('message')
    
    if not to_number or not message:
        return jsonify({"error": "Both 'to' and 'message' are required"}), 400
    
    result = send_whatsapp_message(to_number, message)
    return jsonify(result)

if __name__ == '__main__':
    port = int(os.getenv('PORT', 5001))
    debug = os.getenv('FLASK_ENV') == 'development'
    app.run(debug=debug, host='0.0.0.0', port=port)

