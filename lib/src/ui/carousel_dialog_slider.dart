import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_app/src/ui/rating_widget.dart';
import 'package:flutter_dialogflow/dialogflow_v2.dart';

class CarouselDialogSlider extends StatefulWidget {
  CarouselDialogSlider(this.carouselSelect, this.carouselItemClicked);

  final CarouselSelect carouselSelect;
  final Function carouselItemClicked;

  @override
  _CarouselDialogSliderState createState() => _CarouselDialogSliderState();
}

class _CarouselDialogSliderState extends State<CarouselDialogSlider> {
  bool _enabled = true;
  Timer _timer;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 415.0,
        margin: EdgeInsets.only(top: 20),
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: widget.carouselSelect.items
              .map((item) => Material(
                    color: Color.fromRGBO(249, 248, 235, 1),
                    child: InkWell(
                      splashColor: Platform.isIOS
                          ? CupertinoTheme.of(context).primaryContrastingColor
                          : Theme.of(context).primaryColorLight,
                      highlightColor: Colors.green,
                      onTap: _enabled
                          ? () {
                              return _handleTap(item);
                            }
                          : null,
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        elevation: 5,
                        child: Container(
                          width: 250,
                          child: Column(
                            children: [
                              Container(
                                margin: EdgeInsets.all(15),
                                padding: EdgeInsets.only(top: 10),
                                height: 300,
                                width: 200,
                                child: item.image.imageUri == null
                                    ? Image.asset(
                                        'assets/images/placeholder.jpg',
                                        fit: BoxFit.fitHeight,
                                      )
                                    : Image.network(item.image.imageUri,
                                        fit: BoxFit.fitHeight),
                              ),
                              Expanded(
                                child: Container(
                                  margin: EdgeInsets.only(left: 5, right: 5),
                                  child: Column(
                                    children: [
                                      Text(
                                        '${item.title}',
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        softWrap: true,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 14.0,
                                          fontFamily: 'QuickSand',
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      RatingWidget(
                                          rating: item.description,
                                          centerAlignment: true),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ))
              .toList(),
        ));
  }

  _handleTap(ItemCarousel item) {
    setState(() {
      _enabled = false;
    });
    _timer = Timer(Duration(seconds: 1), () => setState(() => _enabled = true));
    return widget.carouselItemClicked(item.info['key']);
  }

  @override
  void dispose() {
    if (_timer != null) {
      _timer.cancel();
    }
    super.dispose();
  }
}
/*
Material(
                  child: InkWell(
                    splashColor: Platform.isIOS
                        ? CupertinoTheme.of(context).primaryContrastingColor
                        : Theme.of(context).primaryColorLight,
                    highlightColor: Colors.green,
                    onTap: _enabled
                        ? () {
                            return _handleTap(item);
                          }
                        : null,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Flexible(
                          child: Card(
                            elevation: 10,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                            child: item.image.imageUri == null
                                ? Image.asset(
                                    'assets/images/placeholder.jpg',
                                    fit: BoxFit.cover,
                                  )
                                : Image.network(item.image.imageUri,
                                    fit: BoxFit.cover),
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Text(
                          '${item.title}',
                          textAlign: TextAlign.center,
                          softWrap: true,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14.0,
                            fontFamily: 'QuickSand',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        RatingWidget(
                            rating: item.description, centerAlignment: false),
                      ],
                    ),
                  ),
                ))
            .toList(),
 */
