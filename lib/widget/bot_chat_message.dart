import 'package:flutter/cupertino.dart';

import 'avatar.dart';
import 'message_layout.dart';

class BotChatMessage extends StatelessWidget {
  final String text;
  final String avatarText;

  const BotChatMessage({this.text, this.avatarText});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Avatar(avatarText),
        MessageLayout(text, false),
      ],
    );
  }

}