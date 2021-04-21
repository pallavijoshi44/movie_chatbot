import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'choice_chip_mobo.dart';

class QuickReply extends StatefulWidget {
  QuickReply({this.quickReplies, this.insertQuickReply});

  final List<String> quickReplies;
  final Function insertQuickReply;

  @override
  _QuickReplyState createState() => _QuickReplyState();
}

class _QuickReplyState extends State<QuickReply> {
  bool _isSelected = true;
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
              children: widget.quickReplies.map((quickReply) {
                return ChoiceChipMobo(
                    label: quickReply,
                    selected: false,
                    onSelected: (isSelected) {
                      var isTapped = _isSelected;
                      setState(() {
                        _isSelected = false;
                      });
                      return widget.insertQuickReply(quickReply, isTapped);
                    });
              }).toList()),
        ),
      ]),
    );
    //  BotChatMessage(text
  }
}
