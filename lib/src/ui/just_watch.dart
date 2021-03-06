import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Url extends StatelessWidget {
  Url({this.title, this.url});

  final String title;
  final String url;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: this.title + " ",
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
                _openWebView(context, url);
              },
          ),
        ],
      ),
    );
  }
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
