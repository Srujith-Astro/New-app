// lib/screens/conversation_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'gemini_service.dart';

class ConversationScreen extends StatefulWidget {
  final String subject;
  final Color color;

  ConversationScreen({required this.subject, required this.color});

  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  final TextEditingController _textController = TextEditingController();
  final List<ChatMessage> _messages = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _addMessage(ChatMessage(
      text: "Hello sweetheart! I'm here to help you with ${widget.subject}. What would you like to learn about?",
      isUser: false,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.subject} - Chat with Me'),
        backgroundColor: widget.color,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return _buildMessage(_messages[index]);
              },
            ),
          ),
          if (_isLoading)
            Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                  SizedBox(width: 16),
                  Text('Thinking...', style: TextStyle(fontSize: 16)),
                ],
              ),
            ),
          _buildInputArea(),
        ],
      ),
    );
  }

  Widget _buildMessage(ChatMessage message) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment:
        message.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!message.isUser)
            CircleAvatar(
              backgroundColor: widget.color,
              child: Icon(Icons.favorite, color: Colors.white),
            ),
          SizedBox(width: 8),
          Flexible(
            child: Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: message.isUser ? Colors.blue[100] : Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                message.text,
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
          SizedBox(width: 8),
          if (message.isUser)
            CircleAvatar(
              backgroundColor: Colors.blue,
              child: Icon(Icons.child_care, color: Colors.white),
            ),
        ],
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            offset: Offset(0, -2),
            blurRadius: 4,
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _textController,
              decoration: InputDecoration(
                hintText: 'Type your question here...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
              ),
              maxLines: null,
              onSubmitted: _sendMessage,
            ),
          ),
          SizedBox(width: 8),
          FloatingActionButton(
            onPressed: _isLoading ? null : () => _sendMessage(_textController.text),
            child: Icon(Icons.send),
            mini: true,
            backgroundColor: widget.color,
          ),
        ],
      ),
    );
  }

  void _sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    setState(() {
      _addMessage(ChatMessage(text: text, isUser: true));
      _isLoading = true;
    });

    _textController.clear();

    try {
      final geminiService = Provider.of<GeminiService>(context, listen: false);
      final response = await geminiService.getResponse(text, widget.subject, 12); // Default age

      setState(() {
        _addMessage(ChatMessage(text: response, isUser: false));
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _addMessage(ChatMessage(
          text: "I'm having trouble right now, dear. Could you try asking again in a moment?",
          isUser: false,
        ));
        _isLoading = false;
      });
    }
  }

  void _addMessage(ChatMessage message) {
    _messages.add(message);
    // Save to local database here in next version
  }
}

class ChatMessage {
  final String text;
  final bool isUser;

  ChatMessage({required this.text, required this.isUser});
}
