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
        child: new CircleAvatar(child: new Text('B')),
      ),
      new Expanded(
          child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Text(this.name, style: Theme.of(context).textTheme.title),
          new Container(
            decoration: BoxDecoration(
              color: Colors.amber,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(25),
                topLeft: Radius.circular(25),
                bottomLeft: Radius.circular(25),
              ),
            ),
            margin: const EdgeInsets.only(top: 5.0),
            padding: const EdgeInsets.all(15),
            child: new Text(text, style: Theme.of(context).textTheme.headline),
          ),
        ],
      )),
    ];
  }

  List<Widget> myMessage(context) {
    return <Widget>[
      new Expanded(
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            new Text(this.name, style: Theme.of(context).textTheme.title),
            new Container(
              margin: const EdgeInsets.only(top: 5.0),
              child:
                  new Text(text, style: Theme.of(context).textTheme.headline),
            ),
          ],
        ),
      ),
      new Container(
        margin: const EdgeInsets.only(left: 16.0),
        child: new CircleAvatar(
          child: new Text(this.name[0]),
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: new Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: this.type ? myMessage(context) : otherMessage(context),
      ),
    );
  }
}
