import 'package:dash_chat/dash_chat.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class UrlWidget extends StatelessWidget {
  UrlWidget({this.title, this.url});

  final String title;
  final String url;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(children: [
        Container(
          margin: const EdgeInsets.only(right: 16.0),
          child: CircleAvatar(
            child: Text(''),
            backgroundColor: Colors.transparent,
          ),
        ),
        Expanded(
            child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
                decoration: BoxDecoration(
                  color: Colors.amber,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(25),
                    topLeft: Radius.circular(25),
                    bottomLeft: Radius.circular(25),
                  ),
                ),
                margin: const EdgeInsets.only(top: 5.0),
                padding: const EdgeInsets.all(15),
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: this.title + " ",
                        style: Theme.of(context).textTheme.headline,
                      ),
                      TextSpan(
                        text: "[Click here]",
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
                )),
          ],
        )),
      ]),
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
