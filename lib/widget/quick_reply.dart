import 'package:flutter/material.dart';
import 'package:flutter_app/widget/avatar.dart';
import 'package:flutter_app/widget/bot_chat_message.dart';
import 'package:flutter_app/widget/message_layout.dart';

class QuickReply extends StatelessWidget {
  QuickReply({this.quickReplies, this.insertQuickReply, this.title, this.name});

  final List<String> quickReplies;
  final String title;
  final String name;
  final Function insertQuickReply;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          BotChatMessage(text: title, avatarText: 'B',),
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            direction: Axis.horizontal,
            children: quickReplies.map((quickReply) {
              return Container(
                margin: const EdgeInsets.all(10),
                child: OutlineButton(
                  child: Text(quickReply),
                  borderSide: BorderSide(color: Colors.blue),
                  textColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15))),
                  onPressed: () {
                    return insertQuickReply(quickReply);
                  },
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
