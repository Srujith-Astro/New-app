import 'package:flutter/material.dart';

class ConversationProvider extends ChangeNotifier {
  // Example variable (add your conversation logic here)
  List<String> _messages = [];

  List<String> get messages => _messages;

  void addMessage(String msg) {
    _messages.add(msg);
    notifyListeners();
  }
}
