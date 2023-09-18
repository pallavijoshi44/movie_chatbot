import 'package:flutter/material.dart';

import 'bot_chat_message.dart';
import 'message_layout.dart';

class ChatMessage extends StatelessWidget {
  ChatMessage({required this.text, required this.type});

  final String text;
  final bool type;

  @override
  Widget build(BuildContext context) {
    return this.type
        ? MessageLayout(this.text, this.type)
        : BotChatMessage(text: this.text);
  }
}
