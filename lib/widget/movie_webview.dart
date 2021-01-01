import 'dart:async';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MovieWebView extends StatelessWidget {
  final String url;
  final String movieName;

  var alert;

  MovieWebView({this.url, this.movieName});

  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(this.movieName, style: Theme.of(context).textTheme.title),
        ),
        body: Builder(builder: (BuildContext context) {
          return WebView(
            initialUrl: url,
            javascriptMode: JavascriptMode.unrestricted,
            onWebViewCreated: (WebViewController webViewController) {
              _controller.complete(webViewController);
            },
            navigationDelegate: (NavigationRequest request) {
              return NavigationDecision.navigate;
            },
            onPageStarted: (String url) {
              _showAlertDialog(context);
            },
            onPageFinished: (String url) {
              Navigator.pop(context);
            },
            gestureNavigationEnabled: true,
          );
        }));
  }

  _showAlertDialog(BuildContext context) {
    alert = AlertDialog(
      content: new Row(
        children: [
          CircularProgressIndicator(),
          Container(
              margin: EdgeInsets.only(left: 10),
              child: Text("Loading",  style: Theme.of(context).textTheme.headline)),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
