import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/src/resources/constants.dart';

class AboutAppWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(ABOUT_APP),
        ),
        body: Content());
  }
}

class Content extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var width =  MediaQuery.of(context).size.width;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.all(15.0),
          padding: EdgeInsets.only(bottom: 15.0),
          child: Text(
            POWERED_BY_TMDB,
            style: TextStyle(
              fontFamily: 'OpenSans',
              fontSize: 16,
              color: Color.fromRGBO(13, 37, 63, 1),
            ),
            textAlign: TextAlign.center,
          ),
        ),
        Image.asset(
          'assets/images/tmdb_logo.png',
          fit: BoxFit.cover,
          width: width - 200 ,
        ),
        Container(
          margin: EdgeInsets.all(15.0),
          padding: EdgeInsets.only(bottom: 15.0),
          child: Text(
            TMDB_CONTENT,
            style: TextStyle(
              fontFamily: 'OpenSans',
              fontSize: 16,
              color: Color.fromRGBO(13, 37, 63, 1),
            ),
            textAlign: TextAlign.center,
          ),
        ),
        Divider(
            color: Colors.black
        ),
        Container(
          margin: EdgeInsets.all(15.0),
          padding: EdgeInsets.only(bottom: 15.0),
          child: Text(
            POWERED_BY_JUST_WATCH,
            style: TextStyle(
              fontFamily: 'OpenSans',
              fontSize: 16,
              color: Color.fromRGBO(13, 37, 63, 1),
            ),
            textAlign: TextAlign.center,
          ),
        ),
        Image.asset(
          'assets/images/just_watch_logo.png',
          fit: BoxFit.cover,
          width: width - 150 ,
        ),
      ],
    );
  }
}
