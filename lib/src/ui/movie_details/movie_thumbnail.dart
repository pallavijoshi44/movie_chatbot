import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'thumbnail_view.dart';


class MovieThumbnailDetail extends StatelessWidget {
  final String url;
  final String thumbNail;

  const MovieThumbnailDetail({Key key, this.url, this.thumbNail}) : super(key: key);

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
    return Container(
      child: ThumbnailView(
          onPressed: (url) {
            _launchURL();
          },
          url: url,
          thumbNail: thumbNail),
    );
  }
}
