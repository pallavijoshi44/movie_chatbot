import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/widget/url.dart';
import 'package:flutter_svg/svg.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constants.dart';

class MovieJustWatch extends StatelessWidget {
  MovieJustWatch({this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(children: [
        Container(
          margin: const EdgeInsets.only(right: 16.0),
          child: CircleAvatar(
            child: Text(''),
            backgroundColor: Colors.transparent,
          ),
        ),
        Expanded(
            child: Container(
                decoration: BoxDecoration(
                  color: Colors.lightGreen[200],
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30.0),
                      topRight: Radius.circular(30.0),
                      bottomRight: Radius.circular(30.0)),
                ),
                margin: const EdgeInsets.only(top: 15.0),
                padding: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      this.title,
                      style: Theme.of(context).textTheme.headline,
                    ),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: JUST_WATCH_TEXT,
                            style: Theme.of(context).textTheme.headline,
                          ),
                          TextSpan(
                            text: "Just Watch",
                            style: TextStyle(
                                fontFamily: 'OpenSans',
                                fontSize: 14,
                                color: Colors.blue),
                            recognizer: new TapGestureRecognizer()
                              ..onTap = () {
                                _openWebView(context, "https://www.justwatch.com/");
                              },
                          ),
                        ],
                      ),
                    )
                  ],
                ))),
      ]),
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
