import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../domain/constants.dart';

class UnreadMessage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(top: 15.0, bottom: 15.0),
        child: Row(children: <Widget>[
          Expanded(
              child: Divider(
            thickness: 1,
            color: Colors.green,
          )),
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(UNREAD_MESSAGE,
                  style: Platform.isIOS
                      ? CupertinoTheme.of(context).textTheme.tabLabelTextStyle
                      : Theme.of(context).textTheme.headline)),
          Expanded(
              child: Divider(
            thickness: 1,
            color: Colors.green,
          )),
        ]));
  }
}
