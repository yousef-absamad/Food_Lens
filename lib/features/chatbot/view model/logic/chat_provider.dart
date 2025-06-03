import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:food_lens/features/Profile/model/user_model.dart';
import 'package:food_lens/features/chatbot/model/chat_message.dart';
import 'package:food_lens/features/chatbot/view%20model/repo/chat_repository.dart';

class ChatProvider extends ChangeNotifier {
  final ChatRepository repository = ChatRepository();
  UserModel user;

  final List<ChatMessageModel> _messages = [];
  bool _isLoading = false;
  bool _showDisclaimer = true;
  bool _isTyping = false;

  ChatProvider({required this.user});

  List<ChatMessageModel> get messages => _messages;
  bool get isLoading => _isLoading;
  bool get showDisclaimer => _showDisclaimer;
  bool get isTyping => _isTyping;


  void updateUser(UserModel newUser) {
    user = newUser;
    notifyListeners();
  }

  Future<void> sendUserMessage(String message) async {
    if (message.isEmpty) return;

    _addUserMessage(message);
    _hideDisclaimer();

    try {
      _setLoading(true);
      _setTyping(true);

      final hasConnection = await checkInternetConnection();
      if (!hasConnection) {
        _addBotMessage(
          '📡 No internet connection. Please check your network and try again.',
        );
        return;
      }

      final response = await repository.sendMessage(message: message , user: user);
      _addBotMessage(response);
    } catch (e) {
      _addBotMessage("Something went wrong. Please try again⚠️.");
    } finally {
      _setLoading(false);
      _setTyping(false);
    }
  }

  Future<bool> checkInternetConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }

  void _setTyping(bool typing) {
    _isTyping = typing;
    notifyListeners();
  }

  void _addUserMessage(String text) {
    _messages.insert(0, ChatMessageModel.user(text: text));
    notifyListeners();
  }

  void _addBotMessage(String text) {
    _messages.insert(0, ChatMessageModel.bot(text: text));
    notifyListeners();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _hideDisclaimer() {
    if (_showDisclaimer) {
      _showDisclaimer = false;
      notifyListeners();
    }
  }

  bool isArabic(String text) {
    return RegExp(r'[\u0600-\u06FF]').hasMatch(text);
  }
}