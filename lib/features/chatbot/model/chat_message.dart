class ChatMessageModel {
  final String text;
  final bool isUser;
  final bool isArabic;

  ChatMessageModel._({
    required this.text,
    required this.isUser,
    required this.isArabic,
  });

  factory ChatMessageModel.user({required String text}) {
    return ChatMessageModel._(
      text: text,
      isUser: true,
      isArabic: _detectArabic(text),
    );
  }

  factory ChatMessageModel.bot({required String text}) {
    return ChatMessageModel._(
      text: text,
      isUser: false,
      isArabic: _detectArabic(text),
    );
  }

  static bool _detectArabic(String text) {
    return RegExp(r'[\u0600-\u06FF]').hasMatch(text);
  }
}