import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/src/domain/constants.dart';
import 'package:url_launcher/url_launcher.dart';

class MovieJustWatch extends StatelessWidget {
  MovieJustWatch({this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
          padding: const EdgeInsets.all(15),
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                    text: JUST_WATCH_TEXT,
                    style: TextStyle(color: Colors.black,fontFamily: 'QuickSand', fontSize: 14)),
                TextSpan(
                  text: "JustWatch",
                  style: TextStyle(
                      fontFamily: 'QuickSand',
                      fontSize: 14,
                      color: Colors.blue),
                  recognizer: new TapGestureRecognizer()
                    ..onTap = () {
                      _openWebView(
                          context, "https://www.justwatch.com/");
                    },
                ),
              ],
            ),
          )),
    );
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
