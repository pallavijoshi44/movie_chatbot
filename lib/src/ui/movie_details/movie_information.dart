import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_app/src/ui/rating_widget.dart';

class MovieInformationWidget extends StatelessWidget {
  MovieInformationWidget({this.title, this.image, this.year, this.rating, this.duration});

  final String title;
  final String image;
  final String year;
  final String rating;
  final String duration;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 10.0, right: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            elevation: 5,
            child: image == null
                ? Image.asset(
                    'assets/images/placeholder.jpg',
                    fit: BoxFit.contain,
                    height: 200,
                  )
                : Image.network(
                    image,
                    fit: BoxFit.contain,
                    height: 200,
                  ),
          ),
          Flexible(
            child: Container(
              margin: EdgeInsets.only(left: 20.0, right: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(this.title,
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'OpenSans',
                          fontSize: 25,
                          fontWeight: FontWeight.bold)),
                  SizedBox(
                    height: 5.0,
                  ),
                  Visibility(
                    visible: shouldShow(this.year),
                    child: Text(this.year,
                        style: TextStyle(
                            color: Colors.grey,
                            fontFamily: 'OpenSans',
                            fontSize: 16,
                            fontWeight: FontWeight.bold)),
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Visibility(
                      visible: shouldShow(this.rating),
                      child: RatingWidget(rating: this.rating, centerAlignment: false,)),
                  SizedBox(
                    height: 5.0,
                  ),
                  Visibility(
                    visible: shouldShow(this.duration),
                    child: Text(this.duration,
                        style: TextStyle(
                            color: Colors.grey[900],
                            fontFamily: 'OpenSans',
                            fontSize: 16)),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  bool shouldShow(String item) =>  item != null || item != "";
}
