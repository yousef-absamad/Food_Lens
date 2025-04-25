import 'package:flutter/material.dart';
import 'package:food_lens/features/Profile/model/user_model.dart';
import 'package:food_lens/features/chatbot/model/chat_message.dart';
import 'package:food_lens/features/chatbot/view%20model/logic/chat_provider.dart';
import 'package:food_lens/features/chatbot/view/widgets/chat_bubble.dart';
import 'package:food_lens/features/chatbot/view/widgets/chat_input.dart';
import 'package:food_lens/features/chatbot/view/widgets/disclaimer_banner.dart';
import 'package:food_lens/features/chatbot/view/widgets/typing_indicator.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  final UserModel user;

  const ChatScreen({super.key, required this.user});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late ChatProvider _provider;

  @override
  void initState() {
    super.initState();
    _provider = ChatProvider(user: widget.user);
  }

  @override
  void didUpdateWidget(ChatScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.user != oldWidget.user) {
      _provider.updateUser(widget.user);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _provider,
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          title: const Text('Health Assistant'),
          backgroundColor: Colors.white,
          elevation: 2,
        ),
        body: const _ChatBody(),
      ),
    );
  }
}

class _ChatBody extends StatelessWidget {
  const _ChatBody();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Consumer<ChatProvider>(
            builder: (context, provider, _) {
              return Stack(
                children: [
                  _ChatMessagesList(
                    messages: provider.messages,
                    isTyping: provider.isTyping,
                  ),
                  if (provider.showDisclaimer)
                    Positioned(
                      top: 16,
                      left: 16,
                      right: 16,
                      child: const MedicalChatDisclaimer(),
                    ),
                ],
              );
            },
          ),
        ),
        const ChatInput(),
      ],
    );
  }
}

class _ChatMessagesList extends StatelessWidget {
  final List<ChatMessageModel> messages;
  final bool isTyping;

  const _ChatMessagesList({required this.messages, required this.isTyping});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      reverse: true,
      padding: const EdgeInsets.only(bottom: 12),
      itemCount: messages.length + (isTyping ? 1 : 0),
      itemBuilder: (context, index) {
        if (isTyping && index == 0) {
          return const TypingIndicator();
        }
        final message = messages[isTyping ? index - 1 : index];
        return ChatBubble(messageModel: message);
      },
    );
  }
}
