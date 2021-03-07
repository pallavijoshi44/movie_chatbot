import 'package:flutter/cupertino.dart';

import 'avatar.dart';
import 'message_layout.dart';

class BotChatMessage extends StatelessWidget {
  final String text;

  const BotChatMessage({this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Avatar(),
        Expanded(child: MessageLayout(text, false)),
      ],
    );
  }

}