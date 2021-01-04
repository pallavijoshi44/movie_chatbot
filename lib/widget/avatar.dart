import 'package:flutter/material.dart';

class Avatar extends StatelessWidget {
  final String text;

  const Avatar(this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 16.0),
      child: CircleAvatar(
        child: Text(
          text,
          style: Theme.of(context).textTheme.headline,
        ),
        backgroundColor: Colors.lightGreen[200],
      ),
    );
  }
}
