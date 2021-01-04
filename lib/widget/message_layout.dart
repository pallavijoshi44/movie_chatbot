import 'package:flutter/material.dart';

class MessageLayout extends StatelessWidget {
  final String text;
  final bool type;

  MessageLayout(this.text, this.type);

  @override
  Widget build(BuildContext context) {
    return new Column(
      crossAxisAlignment:
          type ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: <Widget>[Message(text, type)],
    );
  }
}

class Message extends StatelessWidget {
  final String text;
  final bool type;

  Message(this.text, this.type);

  @override
  Widget build(BuildContext context) {
    return new Container(
      decoration: BoxDecoration(
        color: type ? Colors.grey[300] : Colors.lightGreen[200],
        borderRadius: type
            ? BorderRadius.only(
                topLeft: Radius.circular(30.0),
                topRight: Radius.circular(30.0),
                bottomLeft: Radius.circular(30.0))
            : BorderRadius.only(
                topLeft: Radius.circular(30.0),
                topRight: Radius.circular(30.0),
                bottomRight: Radius.circular(30.0)),
      ),
      margin: const EdgeInsets.only(top: 15.0),
      padding: const EdgeInsets.all(15),
      child: new Text(text, style: Theme.of(context).textTheme.headline),
    );
  }
}
