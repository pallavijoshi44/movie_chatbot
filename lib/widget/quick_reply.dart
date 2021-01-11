import 'package:flutter/material.dart';
import 'package:flutter_app/widget/avatar.dart';
import 'package:flutter_app/widget/bot_chat_message.dart';
import 'package:flutter_app/widget/message_layout.dart';

class QuickReply extends StatelessWidget {
  QuickReply(
      {this.quickReplies,
      this.insertQuickReply,
      this.title,
      this.name,
      this.isEnabled});

  final List<String> quickReplies;
  final String title;
  final String name;
  final Function insertQuickReply;
  final bool isEnabled;

  @override
  Widget build(BuildContext context) {
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
      Container(
          margin: const EdgeInsets.only(top: 15.0),
          padding: const EdgeInsets.only(top: 15.0),
          child: Avatar('B')),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Message(title, false),
            Wrap(
                alignment: WrapAlignment.spaceBetween,
                direction: Axis.horizontal,
                children: quickReplies.map((quickReply) {
                  return Container(
                    margin: const EdgeInsets.all(10),
                    child: OutlineButton(
                      disabledBorderColor:  Colors.grey[600] ,
                      disabledTextColor:  Colors.grey[900],
                      child: Text(quickReply,
                          style:
                              TextStyle(fontFamily: 'OpenSans', fontSize: 14)),
                      borderSide: BorderSide(color: Colors.lightGreen[900]),
                      textColor: Colors.lightGreen[900],
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15))),
                      onPressed: isEnabled ? () {
                        return insertQuickReply(quickReply);
                      } : null,
                    ),
                  );
                }).toList()),
          ],
        ),
      ),
    ]);
    //  BotChatMessage(text
  }
}
