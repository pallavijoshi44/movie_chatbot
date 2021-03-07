import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/src/domain/constants.dart';
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
        margin: const EdgeInsets.only(top: 10.0),
        child: Column(
          children: <Widget>[
            CarouselSlider(
              options: CarouselOptions(
                  autoPlay: false,
                  aspectRatio: 1.0,
                  enlargeCenterPage: false,
                  enableInfiniteScroll: false,
                  enlargeStrategy: CenterPageEnlargeStrategy.height),
              items:  widget.carouselSelect.items
                  .map((item) => InkWell(
                splashColor: Theme.of(context).primaryColorLight,
                onTap: _enabled ? () {
                          return _handleTap(item);
                        } : null,
                        child: Card(
                          elevation: 5,
                          margin: EdgeInsets.all(5),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  '${item.title}',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Flexible(
                                  flex: 4,
                                  child: item.image.imageUri.contains('null')
                                      ? Image.asset(
                                          'assets/images/placeholder.jpg',
                                          fit: BoxFit.cover,
                                        )
                                      : Image.network(item.image.imageUri,
                                          fit: BoxFit.contain),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Flexible(
                                  flex: 1,
                                  child: SingleChildScrollView(
                                    child: ExpandableText(
                                      '${item.description ?? ""}',
                                      expandText: EXPAND_TEXT,
                                      collapseText: COLLAPSE_TEXT,
                                      maxLines: 3,
                                      linkColor: Colors.blue,
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 15.0,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ))
                  .toList(),
            ),
          ],
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
     if(_timer != null) {
       _timer.cancel();
     }
     super.dispose();
  }
}
