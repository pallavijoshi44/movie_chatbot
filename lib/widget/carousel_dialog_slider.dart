import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dialogflow/dialogflow_v2.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class CarouselDialogSlider extends StatefulWidget {
  CarouselDialogSlider(this.carouselSelect, this.carouselItemClicked);

  final CarouselSelect carouselSelect;
  final Function carouselItemClicked;

  @override
  _CarouselDialogSliderState createState() => _CarouselDialogSliderState();
}

class _CarouselDialogSliderState extends State<CarouselDialogSlider> {
  @override
  Widget build(BuildContext context) {
    final List<String> imageList =
        widget.carouselSelect.items.map((item) => item.image.imageUri).toList();
    return Container(
        child: Column(
      children: <Widget>[
        CarouselSlider(
          options: CarouselOptions(
            autoPlay: true,
            aspectRatio: 1.0,
            enlargeCenterPage: true,
            enableInfiniteScroll: false,
          ),
          items: imageList
              .map((item) => InkWell(
                    onTap: () async {
                      // var permission = await Geolocator.checkPermission();
                      var currentPosition =
                          await Geolocator.getCurrentPosition();
                      var placeMarks = await placemarkFromCoordinates(
                          currentPosition.latitude, currentPosition.longitude);
                      var _countryCode = 'US';

                      if (placeMarks != null && placeMarks.length > 0) {
                        _countryCode = placeMarks[0].isoCountryCode;
                      }
                      var movieTitle = widget
                          .carouselSelect.items[imageList.indexOf(item)].title;
                      widget.carouselItemClicked(
                          _countryCode,
                          widget.carouselSelect.items[imageList.indexOf(item)]
                              .info['key'],
                          movieTitle.substring(0, movieTitle.indexOf(' (')));
                      // return _inform(context,
                      // '${widget.carouselSelect.items[imageList.indexOf(item)].title}');
                    },
                    child: Card(
                      elevation: 5,
                      margin: EdgeInsets.all(5),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      child: Column(
                        children: [
                          Flexible(
                            child: Container(
                              child: ClipRRect(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(15),
                                      topRight: Radius.circular(15)),
                                  child: item.contains('null')
                                      ? Image.asset(
                                          'assets/images/placeholder.png',
                                          width: 1000.0,
                                          fit: BoxFit.cover,
                                        )
                                      : Image.network(item,
                                          fit: BoxFit.cover, width: 1000.0)),
                            ),
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                              ),
                              padding: EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 20.0),
                              child: Text(
                                '${widget.carouselSelect.items[imageList.indexOf(item)].title}',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(15),
                                      bottomRight: Radius.circular(15))),
                              padding: EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 20.0),
                              child: Text(
                                '${widget.carouselSelect.items[imageList.indexOf(item)].description ?? ""}',
                                maxLines: 5,
                                overflow: TextOverflow.ellipsis,
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
                  ))
              .toList(),
        ),
      ],
    ));
  }
}
