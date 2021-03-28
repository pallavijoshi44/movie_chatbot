import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'thumbnail_view.dart';


class MovieThumbnail extends StatelessWidget {
  final String url;
  final String thumbNail;

  const MovieThumbnail({Key key, this.url, this.thumbNail}) : super(key: key);

  _launchURL() async {
    if (await canLaunch(url)) {
      await launch(url, forceSafariVC: false);
    } else {
      await launch(
        url,
        forceSafariVC: false,
        forceWebView: false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
      Container(
        margin: const EdgeInsets.only(right: 16.0),
        child: Image.asset('assets/icon/app_icon.png', width: 30, height: 30, fit: BoxFit.cover,),
      ),
      Expanded(
        child: Container(
          margin: const EdgeInsets.only(top: 15.0),
          child: ThumbnailView(
              onPressed: (url) {
                _launchURL();
              },
              url: url,
              thumbNail: thumbNail),
        ),
      ),
    ]);
  }
}
