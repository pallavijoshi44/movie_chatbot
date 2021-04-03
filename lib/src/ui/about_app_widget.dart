import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/src/domain/constants.dart';
import 'package:get_version/get_version.dart';
import 'package:share/share.dart';

class AboutAppWidget extends StatelessWidget {
  static const routeName = '/about';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: Platform.isIOS
            ? CupertinoNavigationBar(
                leading: CupertinoButton(
                  child: Text(
                    CANCEL,
                    textScaleFactor: 1.0,
                    style: CupertinoTheme.of(context)
                        .textTheme
                        .actionTextStyle,
                  ),
                  padding: EdgeInsets.zero,
                  onPressed: () => Navigator.of(context).pop(),
                ),
                middle: Text(ABOUT_APP,
                    style: CupertinoTheme.of(context)
                        .textTheme
                        .navTitleTextStyle),
                trailing: CupertinoButton(
                  onPressed: () {
                    _onShare(context);
                  },
                  padding: EdgeInsets.zero,
                  child: Icon(
                    CupertinoIcons.share,
                    color: Colors.white,
                  ),
                ),
              )
            : AppBar(
                title: Text(ABOUT_APP),
                actions: <Widget>[
                  IconButton(
                    icon: Icon(
                      Icons.share,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      _onShare(context);
                    },
                  )
                ],
              ),
        body: Content());
  }
}

class Content extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.all(15.0),
            padding: EdgeInsets.only(bottom: 15.0),
            child: Text(
              POWERED_BY_TMDB,
              style: TextStyle(
                fontFamily: 'QuickSand',
                fontSize: Platform.isIOS ? 14 : 16,
                color: Color.fromRGBO(13, 37, 63, 1),
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Image.asset(
            'assets/images/tmdb_logo.png',
            fit: BoxFit.cover,
            width: width - 200,
          ),
          Container(
            margin: EdgeInsets.all(15.0),
            padding: EdgeInsets.only(bottom: 15.0),
            child: Text(
              TMDB_CONTENT,
              style: TextStyle(
                fontFamily: 'QuickSand',
                fontSize:  Platform.isIOS ? 14 : 16,
                color: Color.fromRGBO(13, 37, 63, 1),
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Divider(color: Colors.black),
          Container(
            margin: EdgeInsets.all(15.0),
            padding: EdgeInsets.only(bottom: 15.0),
            child: Text(
              POWERED_BY_JUST_WATCH,
              style: TextStyle(
                fontFamily: 'QuickSand',
                fontSize:  Platform.isIOS ? 14 : 16,
                color: Color.fromRGBO(13, 37, 63, 1),
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Image.asset(
            'assets/images/just_watch_logo.png',
            fit: BoxFit.cover,
            width: width - 150,
          ),
          SizedBox(
            height: 20,
          )
        ],
      ),
    );
  }
}

_onShare(BuildContext context) async {
  String url;
  final isIOS = Theme.of(context).platform == TargetPlatform.iOS;
  if (isIOS) {
    var appId = await GetVersion.appID;
    url = "$SHARE_APP itms-apps://itunes.apple.com/app/id$appId}";
  } else {
    url =
        "$SHARE_APP http://play.google.com/store/apps/details?id=com.chatbot.mobo";
  }
  final RenderBox box = context.findRenderObject() as RenderBox;
  await Share.share(url,
      subject: SHARE_APP,
      sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
}
