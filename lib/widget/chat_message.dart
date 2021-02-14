import 'package:flutter/material.dart';
import 'package:flutter_app/widget/message_layout.dart';
import '../constants.dart';
import 'bot_chat_message.dart';

class ChatMessage extends StatelessWidget {
  ChatMessage({this.text, this.type});

  final String text;
  final bool type;

  @override
  Widget build(BuildContext context) {
    return this.type
        ? MessageLayout(this.text, this.type)
        : BotChatMessage(text: this.text, avatarText: BOT_PREFIX,);
  }
}
