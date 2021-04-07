import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:url_launcher/url_launcher.dart';

class MovieProvider extends StatelessWidget {
  MovieProvider({this.title, this.logos, this.watchProviderLink});

  final String title;
  final String watchProviderLink;
  final List<dynamic> logos;

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
      Container(
          constraints:
              BoxConstraints(maxWidth: MediaQuery.of(context).size.width - 60),
          padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
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
                direction: Axis.horizontal,
                children: this.logos.map((logo) {
                  return IconButton(
                    highlightColor: Colors.green,
                      iconSize: 50,
                      icon: Image.network(logo,),
                      padding: const EdgeInsets.only(right: 5.0),
                      onPressed: () { _openWebView(context, watchProviderLink); },
                    );
                }).toList()),
          ]))
    ]));
  }

  Future<void> _openWebView(BuildContext context, String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: false,
        forceWebView: false,
      );
    } else {
      throw 'Could not launch $url';
    }
  }
}
