import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MovieDescriptionWidget extends StatelessWidget {
  MovieDescriptionWidget({required this.title, required this.description});

  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 15.0, right: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(this.title,
              style: Platform.isIOS
                  ? CupertinoTheme.of(context).textTheme.navTitleTextStyle
                  : Theme.of(context).textTheme.titleLarge),
          SizedBox(height: 5,),
          Text(this.description,
              style: Platform.isIOS
                  ? CupertinoTheme.of(context).textTheme.tabLabelTextStyle
                  : Theme.of(context).textTheme.headline1)
        ],
      ),
    );
  }
}
