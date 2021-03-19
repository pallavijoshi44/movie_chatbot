import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class QuickReply extends StatelessWidget {
  QuickReply({this.quickReplies, this.insertQuickReply});

  final List<String> quickReplies;
  final Function insertQuickReply;

  @override
  Widget build(BuildContext context) {
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
      Container(
        margin: const EdgeInsets.only(top: 15.0),
        padding: const EdgeInsets.only(top: 15.0),
        child: CircleAvatar(
          child: Text(''),
          backgroundColor: Colors.transparent,
        ),
      ),
      Expanded(
        child: Wrap(
            alignment: WrapAlignment.spaceEvenly,
            direction: Axis.horizontal,
            children: quickReplies.map((quickReply) {
              return Container(
                  margin: const EdgeInsets.all(10),
                  child: OutlineButton(
                    disabledBorderColor: Colors.grey[600],
                    disabledTextColor: Colors.grey[900],
                    child: Text(quickReply,
                        style: TextStyle(fontFamily: 'OpenSans', fontSize: 14)),
                    borderSide: BorderSide(color: Colors.lightGreen[900]),
                    textColor: Colors.lightGreen[900],
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15))),
                    onPressed: () {
                      return insertQuickReply(quickReply);
                    },
                  ));
            }).toList()),
      ),
    ]);
    //  BotChatMessage(text
  }

  Widget _buildWidget(String quickReply) {
    return Platform.isIOS
        ? CupertinoButton(
            disabledColor: Colors.grey[600],
            color: Colors.lightGreen[900],
            child: Text(quickReply,
                style: TextStyle(fontFamily: 'OpenSans', fontSize: 14)),
            borderRadius: BorderRadius.all(Radius.circular(15)),
            onPressed: () {
              return insertQuickReply(quickReply);
            })
        : OutlineButton(
            disabledBorderColor: Colors.grey[600],
            disabledTextColor: Colors.grey[900],
            child: Text(quickReply,
                style: TextStyle(fontFamily: 'OpenSans', fontSize: 14)),
            borderSide: BorderSide(color: Colors.lightGreen[900]),
            textColor: Colors.lightGreen[900],
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15))),
            onPressed: () {
              return insertQuickReply(quickReply);
            },
          );
  }
}
