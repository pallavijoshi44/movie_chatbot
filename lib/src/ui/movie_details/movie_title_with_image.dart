import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class MovieTitleWithImage extends StatelessWidget {
  MovieTitleWithImage({this.title, this.image});

  final String title;
  final String image;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 10.0, right: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            elevation: 5,
            child: Image.asset(
              'assets/images/placeholder.jpg',
              fit: BoxFit.cover,
              height: 200,
            ),
          ),
          Flexible(
            child: Container(
              margin: EdgeInsets.only(left: 10.0, right: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Movie Title",
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'OpenSans',
                          fontSize: 25,
                          fontWeight: FontWeight.bold)),
                  SizedBox(
                    height: 5.0,
                  ),
                  Text("2018",
                      style: TextStyle(
                          color: Colors.grey,
                          fontFamily: 'OpenSans',
                          fontSize: 16,
                          fontWeight: FontWeight.bold))
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
