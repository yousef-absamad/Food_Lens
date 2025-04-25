import 'package:flutter/material.dart';
import 'package:food_lens/features/chatbot/model/chat_message.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart'; 

class ChatBubble extends StatelessWidget {
  final ChatMessageModel messageModel;

  const ChatBubble({super.key, required this.messageModel});

  @override
  Widget build(BuildContext context) {
    final isUser = messageModel.isUser;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Row(
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: CircleAvatar(
                backgroundColor: Colors.blue[100],
                radius: 16,
                backgroundImage: AssetImage('assets/image/chatbot.png'),
              ),
            ),
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.8,
              ),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isUser ? Colors.blue[200] : Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Directionality(
                textDirection: messageModel.isArabic ? TextDirection.rtl : TextDirection.ltr,
                child: MarkdownBody(
                  data: messageModel.text,
                  styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
                    p: TextStyle(fontSize: 15), 
                  ),
                  onTapLink: (text, href, title) {
                    if (href != null) {
                      _launchURL(href);
                    }
                  },
                  selectable: true, 
                ),
              ),
              
            ),
          ),
        ],
      ),
    );
  }

  _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }
}
