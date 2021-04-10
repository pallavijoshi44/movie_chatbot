import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class TvDetailsWidget extends StatelessWidget {
  TvDetailsWidget(
      {this.lastAirDate, this.nextEpisodeAirDate, this.numberOfSeasons});

  final String lastAirDate;
  final String nextEpisodeAirDate;
  final int numberOfSeasons;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 15.0, right: 15.0, top: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          if (this.numberOfSeasons != null)
            _buildColumn(
                context, "No. of seasons", this.numberOfSeasons.toString()),
          if (isValid(this.lastAirDate))
            _buildColumn(context, "Last episode", this.lastAirDate),
          if (isValid(this.nextEpisodeAirDate))
            _buildColumn(context, "Next episode", this.nextEpisodeAirDate),
        ],
      ),
    );
  }

  Widget _buildColumn(BuildContext context, String title, String text) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(width: 1, style: BorderStyle.solid, color: Colors.grey)),
        margin: EdgeInsets.all(2),
        padding: EdgeInsets.all(5),
        width: 100,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      fontFamily: "QuickSand")),
              SizedBox(
                height: 5,
              ),
              Text(text,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                      fontFamily: "QuickSand")),
            ]),
      ),
    );
  }

  bool isValid(String item) => item != null && item.isNotEmpty;
}
