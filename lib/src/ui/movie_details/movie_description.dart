import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class MovieDescriptionWidget extends StatelessWidget {
  MovieDescriptionWidget({this.title, this.description});

  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 15.0, left: 15.0, right: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("About Movie",
              style: Platform.isIOS
                  ? CupertinoTheme.of(context).textTheme.navTitleTextStyle
                  : Theme.of(context).textTheme.title),
          SizedBox(height: 5,),
          Text("This is the description of the movie",
              style: Platform.isIOS
                  ? CupertinoTheme.of(context).textTheme.tabLabelTextStyle
                  : Theme.of(context).textTheme.headline)
        ],
      ),
    );
  }
}
