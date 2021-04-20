import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'choice_chip_mobo.dart';

class QuickReply extends StatelessWidget {
  QuickReply({this.quickReplies, this.insertQuickReply});

  final List<String> quickReplies;
  final Function insertQuickReply;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 15.0),
      child:
      Row(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
        CircleAvatar(
          child: Text(''),
          backgroundColor: Colors.transparent,
        ),
        Expanded(
          child: Wrap(
              alignment: WrapAlignment.spaceEvenly,
              runSpacing: 10,
              direction: Axis.horizontal,
              children: quickReplies.map((quickReply) {
                return ChoiceChipMobo(
                    label: quickReply,
                    selected: false,
                    onSelected: (isSelected) {
                      return insertQuickReply(quickReply);
                    });
              }).toList()),
        ),
      ]),
    );
    //  BotChatMessage(text
  }
}
