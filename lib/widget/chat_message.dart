import 'package:flutter/material.dart';

class ChatMessage extends StatelessWidget {
  ChatMessage({this.text, this.name, this.type});

  final String text;
  final String name;
  final bool type;

  List<Widget> otherMessage(context) {
    return <Widget>[
      new Container(
        margin: const EdgeInsets.only(right: 16.0),
        child: new CircleAvatar(
          child: new Text(
            'B',
            style: Theme.of(context).textTheme.headline,
          ),
          backgroundColor: Colors.lightGreen[200],
        ),
      ),
      new Expanded(
          child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Container(
            decoration: BoxDecoration(
              color: Colors.lightGreen[200],
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  topRight: Radius.circular(30.0),
                  bottomRight: Radius.circular(30.0)),
            ),
            margin: const EdgeInsets.only(top: 5.0),
            padding: const EdgeInsets.all(15),
            child: new Text(text, style: Theme.of(context).textTheme.headline),
          ),
        ],
      )),
    ];
  }

  Widget myMessage(context) {
    return Flex(
      direction: Axis.horizontal,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        new Container(
          alignment: Alignment.centerRight,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30.0),
                topRight: Radius.circular(30.0),
                bottomLeft: Radius.circular(30.0)),
          ),
          margin: const EdgeInsets.only(top: 5.0),
          padding: const EdgeInsets.all(15),
          child: new Text(text, style: Theme.of(context).textTheme.headline),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return this.type
        ? myMessage(context)
        : new Container(
            margin: const EdgeInsets.symmetric(vertical: 10.0),
            child: new Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: otherMessage(context),
            ),
          );
  }
}
