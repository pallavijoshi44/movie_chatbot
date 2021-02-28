import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/constants.dart';

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
            ABOUT_APP_CONTENT,
            style: TextStyle(
              fontFamily: 'OpenSans',
              fontSize: 16,
              color: Color.fromRGBO(13, 37, 63, 1),
            ),
            textAlign: TextAlign.center,
          ),
        ),
        Image.asset(
          'assets/images/about_app.png',
          fit: BoxFit.cover,
          width: width - 200 ,
        )
      ],
    );
  }
}
