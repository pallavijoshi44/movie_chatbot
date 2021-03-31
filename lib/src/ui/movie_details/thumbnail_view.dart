import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../originalmoviedetails/thumbnail_card.dart';

class ThumbnailView extends StatefulWidget {
  const ThumbnailView({
    Key key,
    this.url,
    this.thumbNail,
    this.keepAlive = true,
    this.overlayChild,
    this.onPressed,
    this.titleTextStyle,
    this.titleTextBackGroundColor = const Color(0xFFFFFFFF),
  }) : super(key: key);

  final bool keepAlive;
  final String url;
  final String thumbNail;
  final Function(String) onPressed;
  final Widget overlayChild;
  final Color titleTextBackGroundColor;
  final TextStyle titleTextStyle;

  @override
  _ThumbnailViewState createState() => _ThumbnailViewState();
}

class _ThumbnailViewState extends State<ThumbnailView>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => widget.keepAlive;

  Widget buildVideoThumbnail(String url) {
    return Container(
      child: ThumbnailCard(
        shadow: Shadow.soft,
        onPressed: () {
          if (widget.onPressed != null) {
            widget.onPressed(url);
          }
        },
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            // loading indicator
            widget.thumbNail == null || widget.thumbNail == ""
                ? SizedBox(
                    child: Image.asset(
                    'assets/images/thumbnail_default.png',
                    fit: BoxFit.cover,
                  ))
                : SizedBox(
                    child: Image.network(
                      widget.thumbNail,
                      fit: BoxFit.cover,
                      loadingBuilder: (BuildContext context, Widget child,
                          ImageChunkEvent loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: Container(
                            height: 150,
                            color: Color(0xFFEEEEEE),
                          ),
                        );
                      },
                    ),
                  ),

            // play button
            widget.thumbNail == null || widget.thumbNail == ""
                ? Container()
                : Container(
                    child: ThumbnailCard(
                      borderRadiusValue: 0,
                      child: Platform.isIOS
                          ? Icon(CupertinoIcons.play,
                              color: Colors.white, size: 32)
                          : Icon(Icons.play_arrow,
                              color: Colors.white, size: 32),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return buildVideoThumbnail(widget.url);
  }
}
