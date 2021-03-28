import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MovieProvider extends StatelessWidget {
  MovieProvider({this.title, this.logos});

  final String title;
  final List<dynamic> logos;

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
      Container(
          constraints:
              BoxConstraints(maxWidth: MediaQuery.of(context).size.width - 60),
          margin: const EdgeInsets.only(top: 15.0),
          padding: const EdgeInsets.all(15),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title,
                style: Platform.isIOS
                    ? CupertinoTheme.of(context).textTheme.navTitleTextStyle
                    : Theme.of(context).textTheme.title),
            SizedBox(
              height: 10,
            ),
            Wrap(
                runSpacing: 10.0,
                alignment: WrapAlignment.spaceBetween,
                direction: Axis.horizontal,
                children: this.logos.map((logo) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                    child: Image.network(
                      logo,
                      fit: BoxFit.cover,
                      width: 50.0,
                      height: 50.0,
                    ),
                  );
                }).toList()),
          ]))
    ]));
  }
}
