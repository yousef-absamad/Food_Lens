import 'package:flutter/material.dart';
import 'package:food_lens/features/chatbot/view%20model/logic/chat_provider.dart';
import 'package:provider/provider.dart';

class ChatInput extends StatefulWidget {
  const ChatInput({super.key});

  @override
  State<ChatInput> createState() => _ChatInputState();
}

class _ChatInputState extends State<ChatInput> {
  final TextEditingController _controller = TextEditingController();
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_checkText);
  }

  @override
  void dispose() {
    _controller.removeListener(_checkText);
    _controller.dispose();
    super.dispose();
  }

  void _checkText() {
    setState(() {
      _hasText = _controller.text.trim().isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ChatProvider>(context);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxHeight: 200),
              child: Scrollbar(
                child: SingleChildScrollView(
                  reverse: true,
                  child: TextField(
                    maxLines: null,
                    controller: _controller,
                    onSubmitted: (msg) {
                      if (_hasText) {
                        _sendMessage(provider);
                      }
                    },
                    decoration: InputDecoration.collapsed(
                      hintText:
                          provider.isArabic(_controller.text)
                              ? 'اكتب سؤالك الصحي...'
                              : 'Type your health question...',
                    ),
                    textDirection:
                        provider.isArabic(_controller.text)
                            ? TextDirection.rtl
                            : TextDirection.ltr,
                  ),
                ),
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send, color: _hasText ? Colors.blue : Colors.grey),
            onPressed: _hasText ? () => _sendMessage(provider) : null,
          ),
        ],
      ),
    );
  }

  void _sendMessage(ChatProvider provider) {
    provider.sendUserMessage(_controller.text.trim());
    _controller.clear();
    setState(() {
      _hasText = false;
    });
  }
}
