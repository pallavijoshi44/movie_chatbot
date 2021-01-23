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
        margin: const EdgeInsets.only(top: 10.0),
        child: Column(
          children: <Widget>[
            CarouselSlider(
              options: CarouselOptions(
                  autoPlay: true,
                  aspectRatio: 1.0,
                  enlargeCenterPage: true,
                  enableInfiniteScroll: false,
                  enlargeStrategy: CenterPageEnlargeStrategy.height),
              items: imageList
                  .map((item) => InkWell(
                        onTap: () async {
                          var currentPosition =
                              await Geolocator.getCurrentPosition();
                          var placeMarks = await placemarkFromCoordinates(
                              currentPosition.latitude,
                              currentPosition.longitude);
                          var _countryCode = 'US';

                          if (placeMarks != null && placeMarks.length > 0) {
                            _countryCode = placeMarks[0].isoCountryCode;
                          }
                          var movieTitle = widget.carouselSelect
                              .items[imageList.indexOf(item)].title;
                          widget.carouselItemClicked(
                              _countryCode,
                              widget.carouselSelect
                                  .items[imageList.indexOf(item)].info['key'],
                              movieTitle.substring(
                                  0, movieTitle.indexOf(' (')));
                        },
                        child: Card(
                          elevation: 5,
                          margin: EdgeInsets.all(5),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Flexible(
                                child: ClipRRect(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(15.0),
                                      topRight: Radius.circular(15.0),
                                    ),
                                    child: item.contains('null')
                                        ? Image.asset(
                                            'assets/images/placeholder.png',
                                            fit: BoxFit.cover,
                                          )
                                        : Image.network(item,
                                             fit: BoxFit.scaleDown)),
                              ),
                              ListTile(
                                title: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 5.0),
                                  child: Text(
                                    '${widget.carouselSelect.items[imageList.indexOf(item)].title}',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                subtitle: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 5.0),
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
                              ),
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
