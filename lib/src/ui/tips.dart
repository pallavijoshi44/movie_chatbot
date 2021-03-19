import 'dart:io';

import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../domain/constants.dart';

class Tips extends StatelessWidget {
  Tips({this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Container(
          margin: const EdgeInsets.only(right: 16.0),
          child: CircleAvatar(
            child: Text(TIP_TEXT,
                style: Platform.isIOS
                    ? TextStyle(
                        color: Colors.black,
                        fontFamily: 'OpenSans',
                        fontSize: 14)
                    : Theme.of(context).textTheme.headline),
            backgroundColor: Colors.red[200],
          ),
        ),
        Expanded(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Container(
                decoration: BoxDecoration(
                  color: Colors.red[200],
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30.0),
                      topRight: Radius.circular(30.0),
                      bottomRight: Radius.circular(30.0)),
                ),
                margin: const EdgeInsets.only(top: 15.0),
                padding: const EdgeInsets.all(15),
                child: ExpandableText(text,
                    expandText: EXPAND_TEXT,
                    collapseText: COLLAPSE_TEXT,
                    maxLines: 6,
                    linkColor: Colors.blue,
                    style: Platform.isIOS
                        ? CupertinoTheme.of(context).textTheme.tabLabelTextStyle
                        : Theme.of(context).textTheme.headline))
          ],
        )),
      ],
    );
  }
}
