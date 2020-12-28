import 'package:flutter/material.dart';

class QuickReply extends StatelessWidget {
  QuickReply({this.quickReplies, this.insertQuickReply, this.title, this.name});

  final List<String> quickReplies;
  final String title;
  final String name;
  final Function insertQuickReply;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(right: 16.0),
                child: CircleAvatar(child:  Text('B')),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(this.name,
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Container(
                      margin: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                      child: Text(title),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            direction: Axis.horizontal,
            children: quickReplies.map((quickReply) {
              return Container(
                margin: const EdgeInsets.all(5.0),
                child: OutlineButton(
                  child: Text(quickReply),
                  borderSide: BorderSide(color: Colors.blue),
                  textColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5))),
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
