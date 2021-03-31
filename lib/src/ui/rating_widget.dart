import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RatingWidget extends StatelessWidget {
  final String rating;
  final bool centerAlignment;

  RatingWidget({Key key, this.rating, this.centerAlignment}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
          centerAlignment ? MainAxisAlignment.center : MainAxisAlignment.start,
      children: [
        Text(this.rating,
            style: TextStyle(
                color: Colors.grey[900], fontFamily: 'OpenSans', fontSize: 16)),
        SizedBox(
          width: 5.0,
        ),
        Icon(
          Platform.isIOS ? CupertinoIcons.star_fill : Icons.star,
          color: Colors.yellow[900],
          size: 14,
        ),
      ],
    );
  }
}
